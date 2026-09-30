import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/isar_service.dart';
import '../models/expense_collection.dart';
import '../../domain/entities/expense_entity.dart';

/// Repository managing persistent workshop expense ledger.
/// Backed by Isar NoSQL with safe in-memory fallback for test runners.
class ExpenseRepository {
  static final List<ExpenseCollection> _inMemoryStore = [];
  static int _inMemoryId = 1;

  bool get _useIsar => IsarService.instance.isOpen;
  Isar get _isar => IsarService.instance.isar;

  /// Retrieves all non-deleted expenses ordered by date descending
  Future<List<ExpenseEntity>> getExpenses() async {
    try {
      if (_useIsar) {
        final models = await _isar.expenseCollections
            .filter()
            .isDeletedEqualTo(false)
            .sortByDateDesc()
            .findAll();
        return models.map(_toEntity).toList();
      }
    } catch (e) {
      debugPrint('ExpenseRepository fallback to in-memory: $e');
    }

    return _inMemoryStore
        .where((e) => !e.isDeleted)
        .map(_toEntity)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Saves a new or updated expense record
  Future<int> saveExpense(ExpenseEntity entity) async {
    try {
      if (_useIsar) {
        final model = _toModel(entity);
        int generatedId = 0;
        await _isar.writeTxn(() async {
          generatedId = await _isar.expenseCollections.put(model);
        });
        return generatedId;
      }
    } catch (e) {
      debugPrint('ExpenseRepository write error, falling back: $e');
    }

    final model = _toModel(entity);
    if (entity.id > 0) {
      final index = _inMemoryStore.indexWhere((e) => e.id == entity.id);
      if (index != -1) {
        _inMemoryStore[index] = model;
        return entity.id;
      }
    }
    model.id = _inMemoryId++;
    _inMemoryStore.add(model);
    return model.id;
  }

  /// Soft deletes an expense record
  Future<void> deleteExpense(int id) async {
    try {
      if (_useIsar) {
        await _isar.writeTxn(() async {
          final model = await _isar.expenseCollections.get(id);
          if (model != null) {
            model.isDeleted = true;
            await _isar.expenseCollections.put(model);
          }
        });
        return;
      }
    } catch (e) {
      debugPrint('ExpenseRepository delete fallback: $e');
    }

    final index = _inMemoryStore.indexWhere((e) => e.id == id);
    if (index != -1) {
      _inMemoryStore[index].isDeleted = true;
    }
  }

  static ExpenseEntity _toEntity(ExpenseCollection m) {
    return ExpenseEntity(
      id: m.id,
      title: m.title,
      category: m.category,
      amount: m.amount,
      note: m.note,
      date: m.date,
      createdAt: m.createdAt,
    );
  }

  static ExpenseCollection _toModel(ExpenseEntity e) {
    final m = ExpenseCollection()
      ..title = e.title
      ..category = e.category
      ..amount = e.amount
      ..note = e.note
      ..date = e.date
      ..createdAt = e.createdAt;
    if (e.id > 0) {
      m.id = e.id;
    }
    return m;
  }
}
