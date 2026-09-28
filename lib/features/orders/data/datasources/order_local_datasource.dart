import 'package:isar/isar.dart';
import 'package:darzi_dairy/core/database/isar_service.dart';
import '../models/order_collection.dart';

/// Direct Isar datasource for workshop orders with defensive fallback
class OrderLocalDataSource {
  Isar? get _isar => IsarService.instance.isOpen ? IsarService.instance.isar : null;

  Future<List<OrderCollection>> getActiveOrders() async {
    final db = _isar;
    if (db == null) return [];
    return db.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .sortByTargetDeadline()
        .findAll();
  }

  Future<List<OrderCollection>> getOrdersByStatus(int statusIndex) async {
    final db = _isar;
    if (db == null) return [];
    return db.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .statusEqualTo(statusIndex)
        .sortByTargetDeadline()
        .findAll();
  }

  Future<List<OrderCollection>> getUrgentOrders() async {
    final db = _isar;
    if (db == null) return [];
    return db.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .isUrgentEqualTo(true)
        .sortByTargetDeadline()
        .findAll();
  }

  Future<List<OrderCollection>> getOrdersForCustomer(int customerId) async {
    final db = _isar;
    if (db == null) return [];
    return db.orderCollections
        .filter()
        .customerIdEqualTo(customerId)
        .sortByBookingDateDesc()
        .findAll();
  }

  Future<OrderCollection?> getOrderById(int id) async {
    final db = _isar;
    if (db == null) return null;
    return db.orderCollections.get(id);
  }

  Future<int> putOrder(OrderCollection order) async {
    final db = _isar;
    if (db == null) return order.id;
    return db.writeTxn(() => db.orderCollections.put(order));
  }

  Future<void> updateStatus(int id, int statusIndex) async {
    final db = _isar;
    if (db == null) return;
    final order = await db.orderCollections.get(id);
    if (order != null) {
      order.status = statusIndex;
      await db.writeTxn(() => db.orderCollections.put(order));
    }
  }

  Future<void> softDelete(int id) async {
    final db = _isar;
    if (db == null) return;
    final order = await db.orderCollections.get(id);
    if (order != null) {
      order.isDeleted = true;
      order.deletedAt = DateTime.now();
      await db.writeTxn(() => db.orderCollections.put(order));
    }
  }

  Future<void> restore(int id) async {
    final db = _isar;
    if (db == null) return;
    final order = await db.orderCollections.get(id);
    if (order != null) {
      order.isDeleted = false;
      order.deletedAt = null;
      await db.writeTxn(() => db.orderCollections.put(order));
    }
  }

  Future<List<OrderCollection>> getRecycleBinOrders() async {
    final db = _isar;
    if (db == null) return [];
    return db.orderCollections.filter().isDeletedEqualTo(true).findAll();
  }

  Stream<List<OrderCollection>> watchOrders() {
    final db = _isar;
    if (db == null) return Stream.value([]);
    return db.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .sortByTargetDeadline()
        .watch(fireImmediately: true);
  }
}
