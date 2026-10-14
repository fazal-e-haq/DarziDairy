import 'package:flutter/foundation.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_order_repository.dart';

/// Provider for managing workshop order list, search, and status toggle
class OrderListProvider extends ChangeNotifier {
  final IOrderRepository repository;

  OrderListProvider({required this.repository}) {
    loadOrders();
  }

  List<OrderEntity> _allOrders = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<OrderEntity> get allOrders => _allOrders;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  /// Returns only active orders, filtered by search query
  List<OrderEntity> get activeOrders {
    var list = _allOrders.where((o) => o.status == OrderStatus.active).toList();
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((o) => o.customerName.toLowerCase().contains(query)).toList();
    }
    return list;
  }

  /// Returns completed orders, optionally filtered by customer query
  List<OrderEntity> get completedOrders =>
      _allOrders.where((o) => o.status == OrderStatus.completed).toList();

  List<OrderEntity> getCompletedOrders([String? query]) {
    var list = _allOrders.where((o) => o.status == OrderStatus.completed).toList();
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((o) => o.customerName.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    _allOrders = await repository.getActiveOrders();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Toggle status between Active and Completed with a single tap
  Future<void> toggleOrderStatus(int orderId) async {
    final index = _allOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _allOrders[index];
      final newStatus = current.status == OrderStatus.active
          ? OrderStatus.completed
          : OrderStatus.active;
      await repository.updateOrderStatus(orderId, newStatus);
      if (newStatus == OrderStatus.completed) {
        await NotificationService.instance.cancel(orderId);
      } else {
        await NotificationService.instance.schedule3DaysBefore(current.copyWith(status: newStatus));
      }
      await loadOrders();
    }
  }

  Future<void> updateStatus(int orderId, OrderStatus status) async {
    await repository.updateOrderStatus(orderId, status);
    if (status == OrderStatus.completed) {
      await NotificationService.instance.cancel(orderId);
    }
    await loadOrders();
  }

  Future<void> deleteOrder(int orderId) async {
    await repository.softDeleteOrder(orderId);
    await NotificationService.instance.cancel(orderId);
    await loadOrders();
  }

  /// Update advance payment amount for an existing order
  Future<void> updateAdvancePayment(int orderId, double newAdvancePaid) async {
    final index = _allOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _allOrders[index];
      await repository.saveOrder(current.copyWith(advancePaid: newAdvancePaid));
      await loadOrders();
    }
  }
}
