import '../entities/order_entity.dart';

/// Abstract repository contract for tailoring workshop orders
abstract class IOrderRepository {
  Future<List<OrderEntity>> getActiveOrders();
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status);
  Future<List<OrderEntity>> getUrgentOrders();
  Future<List<OrderEntity>> getOrdersForCustomer(int customerId);
  Future<OrderEntity?> getOrderById(int id);
  Future<int> saveOrder(OrderEntity order);
  Future<void> updateOrderStatus(int id, OrderStatus newStatus);
  Future<void> softDeleteOrder(int id);
  Future<void> restoreOrder(int id);
  Future<List<OrderEntity>> getRecycleBinOrders();
  Stream<List<OrderEntity>> watchActiveOrders();
}
