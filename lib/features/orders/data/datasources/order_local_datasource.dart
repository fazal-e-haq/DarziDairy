import 'dart:async';
import '../models/order_collection.dart';

/// In-memory datasource for workshop orders
class OrderLocalDataSource {
  static final List<OrderCollection> _store = [];
  static int _nextId = 1;

  Future<List<OrderCollection>> getActiveOrders() async {
    return _store.where((o) => !o.isDeleted).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getOrdersByStatus(int statusIndex) async {
    return _store.where((o) => !o.isDeleted && o.status == statusIndex).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getUrgentOrders() async {
    return _store.where((o) => !o.isDeleted && o.isUrgent).toList()
      ..sort((a, b) => a.targetDeadline.compareTo(b.targetDeadline));
  }

  Future<List<OrderCollection>> getOrdersForCustomer(int customerId) async {
    return _store.where((o) => o.customerId == customerId && !o.isDeleted).toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  Future<OrderCollection?> getOrderById(int id) async {
    try {
      return _store.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> putOrder(OrderCollection order) async {
    if (order.id == 0) {
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
    final order = await getOrderById(id);
    if (order != null) {
      order.status = statusIndex;
    }
  }

  Future<void> softDelete(int id) async {
    final order = await getOrderById(id);
    if (order != null) {
      order.isDeleted = true;
      order.deletedAt = DateTime.now();
    }
  }

  Future<void> restore(int id) async {
    final order = await getOrderById(id);
    if (order != null) {
      order.isDeleted = false;
      order.deletedAt = null;
    }
  }

  Future<List<OrderCollection>> getRecycleBinOrders() async {
    return _store.where((o) => o.isDeleted).toList();
  }

  Stream<List<OrderCollection>> watchOrders() {
    return Stream.value(_store.where((o) => !o.isDeleted).toList());
  }
}
