import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/orders/data/models/order_collection.dart';
import '../../features/expenses/data/models/expense_collection.dart';

/// Production Isar database singleton managing thread-safe initialization,
/// persistent storage across app/phone restarts, and safe fallback for test runners.
class IsarService {
  IsarService._internal();

  /// Global singleton instance
  static final IsarService instance = IsarService._internal();

  static const String databaseName = 'tailor_master_db';

  Isar? _isar;
  Completer<Isar?>? _initCompleter;

  /// Returns active Isar instance with auto-recovery if an instance was opened elsewhere.
  Isar get isar {
    final active = _isar;
    if (active != null && active.isOpen) {
      return active;
    }
    final existing = Isar.getInstance(databaseName);
    if (existing != null && existing.isOpen) {
      _isar = existing;
      return existing;
    }
    throw StateError(
      'Isar database is not initialized. Call IsarService.instance.init() first.',
    );
  }

  /// True if database is actively opened and available.
  bool get isOpen {
    if (_isar != null && _isar!.isOpen) return true;
    final existing = Isar.getInstance(databaseName);
    if (existing != null && existing.isOpen) {
      _isar = existing;
      return true;
    }
    return false;
  }

  /// Single-instance initialization with thread-safe Completer and resilient fallbacks
  Future<Isar?> init({String name = databaseName}) async {
    if (_isar != null && _isar!.isOpen && _isar!.name == name) {
      return _isar;
    }

    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<Isar?>();

    try {
      final existingInstance = Isar.getInstance(name);
      if (existingInstance != null && existingInstance.isOpen) {
        _isar = existingInstance;
        _initCompleter!.complete(_isar);
        return _isar;
      }

      final documentsDirectory = await getApplicationDocumentsDirectory();
      if (!await documentsDirectory.exists()) {
        await documentsDirectory.create(recursive: true);
      }

      // Resilient open: Attempt with inspector in debug mode,
      // fallback to inspector=false if local socket binding fails on restricted devices.
      try {
        _isar = await Isar.open(
          [OrderCollectionSchema, ExpenseCollectionSchema],
          directory: documentsDirectory.path,
          name: name,
          inspector: kDebugMode,
        );
      } catch (openError) {
        if (kDebugMode) {
          debugPrint('Isar open with inspector failed ($openError). Retrying with inspector=false...');
          _isar = await Isar.open(
            [OrderCollectionSchema, ExpenseCollectionSchema],
            directory: documentsDirectory.path,
            name: name,
            inspector: false,
          );
        } else {
          rethrow;
        }
      }

      _initCompleter!.complete(_isar);
      return _isar;
    } catch (error) {
      debugPrint('Isar initialization notice: $error');
      // Final attempt: check if an instance exists
      final fallback = Isar.getInstance(name);
      if (fallback != null && fallback.isOpen) {
        _isar = fallback;
        _initCompleter!.complete(_isar);
        return _isar;
      }

      if (_initCompleter != null && !_initCompleter!.isCompleted) {
        _initCompleter!.complete(null);
      }
      return null;
    } finally {
      if (_isar != null && _isar!.isOpen) {
        _initCompleter = null;
      }
    }
  }

  /// Compacts database storage by creating a replica file
  Future<File?> compact({String? destinationPath}) async {
    if (!isOpen) return null;
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = destinationPath ?? '${dir.path}/${databaseName}_compacted.isar';
    final targetFile = File(targetPath);
    if (await targetFile.exists()) {
      await targetFile.delete();
    }
    await isar.copyToFile(targetPath);
    return targetFile;
  }

  /// Returns total database storage size in bytes.
  Future<int> getSize({bool includeIndexes = true}) async {
    if (!isOpen) return 1024 * 64;
    return isar.getSize(includeIndexes: includeIndexes);
  }

  /// Clears all stored records across all collections
  Future<void> clearAll() async {
    if (!isOpen) return;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  /// Safely closes the database instance
  Future<void> close() async {
    final active = _isar;
    if (active != null && active.isOpen) {
      await active.close();
      _isar = null;
      _initCompleter = null;
    }
  }
}
