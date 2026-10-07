import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_order_repository.dart';

enum OrderFilter { active, completed, all }

/// Provider for managing workshop order list, search, and status toggle
class OrderListProvider extends ChangeNotifier {
  final IOrderRepository repository;

  OrderListProvider({required this.repository}) {
    loadOrders();
  }

  List<OrderEntity> _allOrders = [];
  OrderFilter _activeFilter = OrderFilter.active;
  String _searchQuery = '';
  OrderEntity? _selectedOrder;
  bool _isLoading = false;

  List<OrderEntity> get allOrders => _allOrders;
  OrderFilter get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  OrderEntity? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;

  /// Returns filtered list based on the active filter and search query
  List<OrderEntity> get filteredOrders {
    List<OrderEntity> list;
    switch (_activeFilter) {
      case OrderFilter.active:
        list = _allOrders.where((o) => o.status == OrderStatus.active).toList();
        break;
      case OrderFilter.completed:
        list = _allOrders.where((o) => o.status == OrderStatus.completed).toList();
        break;
      case OrderFilter.all:
        list = List.from(_allOrders);
        break;
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((o) {
        return o.customerName.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  // Count getters for badges
  int get countActive => _allOrders.where((o) => o.status == OrderStatus.active).length;
  int get countCompleted => _allOrders.where((o) => o.status == OrderStatus.completed).length;
  int get countAll => _allOrders.length;

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

    // Automatically purge legacy pre-made sample orders so user starts with a clean ledger
    const dummyNames = {
      'Chaudhry Nadeem',
      'Sheikh Tariq',
      'Bilal Farooq',
      'Malik Zeeshan',
      'Haji Abdul Rehman'
    };
    final dummyOrders = _allOrders.where((o) => dummyNames.contains(o.customerName)).toList();
    if (dummyOrders.isNotEmpty) {
      for (final d in dummyOrders) {
        await repository.softDeleteOrder(d.id);
      }
      _allOrders = await repository.getActiveOrders();
    }

    if (_selectedOrder != null) {
      final updated = _allOrders.where((o) => o.id == _selectedOrder!.id).firstOrNull;
      _selectedOrder = updated;
    } else if (_allOrders.isNotEmpty) {
      _selectedOrder = _allOrders.first;
    } else {
      _selectedOrder = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(OrderFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectOrder(OrderEntity order) {
    _selectedOrder = order;
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
      await loadOrders();
    }
  }

  Future<void> updateStatus(int orderId, OrderStatus status) async {
    await repository.updateOrderStatus(orderId, status);
    await loadOrders();
  }

  Future<void> deleteOrder(int orderId) async {
    await repository.softDeleteOrder(orderId);
    await loadOrders();
  }

  /// Update advance payment amount for an existing order
  Future<void> updateAdvancePayment(int orderId, double newAdvancePaid) async {
    final index = _allOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _allOrders[index];
      final updated = OrderEntity(
        id: current.id,
        orderToken: current.orderToken,
        customerId: current.customerId,
        customerName: current.customerName,
        customerPhone: current.customerPhone,
        garmentType: current.garmentType,
        bookingDate: current.bookingDate,
        targetDeadline: current.targetDeadline,
        isUrgent: current.isUrgent,
        status: current.status,
        stitchingRate: current.stitchingRate,
        fabricCharges: current.fabricCharges,
        urgentSurcharge: current.urgentSurcharge,
        advancePaid: newAdvancePaid,
        measurements: current.measurements,
        isDeleted: current.isDeleted,
        deletedAt: current.deletedAt,
      );
      await repository.saveOrder(updated);
      await loadOrders();
    }
  }
}
