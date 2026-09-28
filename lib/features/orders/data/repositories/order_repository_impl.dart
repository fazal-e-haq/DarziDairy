import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_order_repository.dart';
import '../datasources/order_local_datasource.dart';
import '../models/order_collection.dart';

/// Concrete repository implementation for workshop orders
class OrderRepositoryImpl implements IOrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<List<OrderEntity>> getActiveOrders() async {
    final list = await localDataSource.getActiveOrders();
    return list.map(_toEntity).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status) async {
    final list = await localDataSource.getOrdersByStatus(status.index);
    return list.map(_toEntity).toList();
  }

  @override
  Future<List<OrderEntity>> getUrgentOrders() async {
    final list = await localDataSource.getUrgentOrders();
    return list.map(_toEntity).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersForCustomer(int customerId) async {
    final list = await localDataSource.getOrdersForCustomer(customerId);
    return list.map(_toEntity).toList();
  }

  @override
  Future<OrderEntity?> getOrderById(int id) async {
    final model = await localDataSource.getOrderById(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<int> saveOrder(OrderEntity order) async {
    final model = _toModel(order);
    return localDataSource.putOrder(model);
  }

  @override
  Future<void> updateOrderStatus(int id, OrderStatus newStatus) async {
    await localDataSource.updateStatus(id, newStatus.index);
  }

  @override
  Future<void> softDeleteOrder(int id) async {
    await localDataSource.softDelete(id);
  }

  @override
  Future<void> restoreOrder(int id) async {
    await localDataSource.restore(id);
  }

  @override
  Future<List<OrderEntity>> getRecycleBinOrders() async {
    final list = await localDataSource.getRecycleBinOrders();
    return list.map(_toEntity).toList();
  }

  @override
  Stream<List<OrderEntity>> watchActiveOrders() {
    return localDataSource.watchOrders().map(
          (models) => models.map(_toEntity).toList(),
        );
  }

  static OrderEntity _toEntity(OrderCollection m) {
    return OrderEntity(
      id: m.id,
      orderToken: m.orderToken,
      customerId: m.customerId,
      customerName: m.customerName,
      customerPhone: m.customerPhone,
      garmentType: m.garmentType,
      fabricImagePaths: m.fabricImagePaths,
      bookingDate: m.bookingDate,
      targetDeadline: m.targetDeadline,
      isUrgent: m.isUrgent,
      status: OrderStatus.values[m.status.clamp(0, OrderStatus.values.length - 1)],
      stitchingRate: m.stitchingRate,
      fabricCharges: m.fabricCharges,
      urgentSurcharge: m.urgentSurcharge,
      advancePaid: m.advancePaid,
      isDeleted: m.isDeleted,
      deletedAt: m.deletedAt,
    );
  }

  static OrderCollection _toModel(OrderEntity e) {
    final m = OrderCollection()
      ..orderToken = e.orderToken
      ..customerId = e.customerId
      ..customerName = e.customerName
      ..customerPhone = e.customerPhone
      ..garmentType = e.garmentType
      ..fabricImagePaths = e.fabricImagePaths
      ..bookingDate = e.bookingDate
      ..targetDeadline = e.targetDeadline
      ..isUrgent = e.isUrgent
      ..status = e.status.index
      ..stitchingRate = e.stitchingRate
      ..fabricCharges = e.fabricCharges
      ..urgentSurcharge = e.urgentSurcharge
      ..advancePaid = e.advancePaid
      ..balanceDue = e.balanceDue
      ..isDeleted = e.isDeleted
      ..deletedAt = e.deletedAt;
    if (e.id > 0) {
      m.id = e.id;
    }
    return m;
  }
}
