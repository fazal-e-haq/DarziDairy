import 'dart:async';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../models/order_collection.dart';

/// Production-ready datasource for workshop orders.
/// Saves directly to persistent Isar database when available,
/// maintaining data across device/phone restarts.
class OrderLocalDataSource {
  static final List<OrderCollection> _store = [];
  static int _nextId = 1;

  Future<List<OrderCollection>> getActiveOrders() async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections
          .filter()
          .isDeletedEqualTo(false)
          .sortByTargetDeadline()
          .findAll();
    }
    return _store.where((o) => !o.isDeleted).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getOrdersByStatus(int statusIndex) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections
          .filter()
          .isDeletedEqualTo(false)
          .and()
          .statusEqualTo(statusIndex)
          .sortByTargetDeadline()
          .findAll();
    }
    return _store.where((o) => !o.isDeleted && o.status == statusIndex).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getUrgentOrders() async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections
          .filter()
          .isDeletedEqualTo(false)
          .and()
          .isUrgentEqualTo(true)
          .sortByTargetDeadline()
          .findAll();
    }
    return _store.where((o) => !o.isDeleted && o.isUrgent).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getOrdersForCustomer(int customerId) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections
          .filter()
          .customerIdEqualTo(customerId)
          .and()
          .isDeletedEqualTo(false)
          .sortByBookingDateDesc()
          .findAll();
    }
    return _store.where((o) => o.customerId == customerId && !o.isDeleted).toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  Future<OrderCollection?> getOrderById(int id) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections.get(id);
    }
    try {
      return _store.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> putOrder(OrderCollection order) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.writeTxn(() async {
        return await isar.orderCollections.put(order);
      });
    }
    if (order.id <= 0 || order.id == Isar.autoIncrement) {
      order.id = _nextId++;
      _store.add(order);
    } else {
      final index = _store.indexWhere((o) => o.id == order.id);
      if (index >= 0) {
        _store[index] = order;
      } else {
        _store.add(order);
      }
    }
    return order.id;
  }

  Future<void> updateStatus(int id, int statusIndex) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      await isar.writeTxn(() async {
        final order = await isar.orderCollections.get(id);
        if (order != null) {
          order.status = statusIndex;
          await isar.orderCollections.put(order);
        }
      });
      return;
    }
    final order = await getOrderById(id);
    if (order != null) {
      order.status = statusIndex;
    }
  }

  Future<void> softDelete(int id) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      await isar.writeTxn(() async {
        final order = await isar.orderCollections.get(id);
        if (order != null) {
          order.isDeleted = true;
          order.deletedAt = DateTime.now();
          await isar.orderCollections.put(order);
        }
      });
      return;
    }
    final order = await getOrderById(id);
    if (order != null) {
      order.isDeleted = true;
      order.deletedAt = DateTime.now();
    }
  }

  Future<void> restore(int id) async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      await isar.writeTxn(() async {
        final order = await isar.orderCollections.get(id);
        if (order != null) {
          order.isDeleted = false;
          order.deletedAt = null;
          await isar.orderCollections.put(order);
        }
      });
      return;
    }
    final order = await getOrderById(id);
    if (order != null) {
      order.isDeleted = false;
      order.deletedAt = null;
    }
  }

  Future<List<OrderCollection>> getRecycleBinOrders() async {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return await isar.orderCollections
          .filter()
          .isDeletedEqualTo(true)
          .findAll();
    }
    return _store.where((o) => o.isDeleted).toList();
  }

  Stream<List<OrderCollection>> watchOrders() {
    if (IsarService.instance.isOpen) {
      final isar = IsarService.instance.isar;
      return isar.orderCollections
          .filter()
          .isDeletedEqualTo(false)
          .sortByTargetDeadline()
          .watch(fireImmediately: true);
    }
    return Stream.value(_store.where((o) => !o.isDeleted).toList());
  }
}
