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

    if (_allOrders.isEmpty) {
      await _seedSampleOrders();
      _allOrders = await repository.getActiveOrders();
      if (_allOrders.isEmpty) {
        _allOrders = _getSampleOrdersList();
      }
    }

    if (_selectedOrder == null && _allOrders.isNotEmpty) {
      _selectedOrder = _allOrders.first;
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

  List<OrderEntity> _getSampleOrdersList() {
    final now = DateTime.now();
    return [
      OrderEntity(
        id: 1,
        orderToken: '#B-101',
        customerId: 0,
        customerName: 'Chaudhry Nadeem',
        customerPhone: '0300-8452199',
        garmentType: 'Silai Kurta Pajama',
        bookingDate: DateTime(now.year, now.month, now.day - 2, 14, 30),
        targetDeadline: DateTime(now.year, now.month, now.day + 2),
        isUrgent: true,
        status: OrderStatus.active,
        stitchingRate: 1800.0,
        advancePaid: 1000.0,
      ),
      OrderEntity(
        id: 2,
        orderToken: '#B-102',
        customerId: 0,
        customerName: 'Sheikh Tariq',
        customerPhone: '0321-4567890',
        garmentType: 'Silai Two-Piece Suit',
        bookingDate: DateTime(now.year, now.month, now.day - 3, 11, 15),
        targetDeadline: DateTime(now.year, now.month, now.day + 1),
        isUrgent: true,
        status: OrderStatus.active,
        stitchingRate: 6500.0,
        advancePaid: 4000.0,
      ),
      OrderEntity(
        id: 3,
        orderToken: '#B-103',
        customerId: 0,
        customerName: 'Bilal Farooq',
        customerPhone: '0333-9876543',
        garmentType: 'Silai Shalwar Kameez',
        bookingDate: DateTime(now.year, now.month, now.day - 1, 16, 45),
        targetDeadline: DateTime(now.year, now.month, now.day + 4),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 1600.0,
        advancePaid: 1600.0,
      ),
      OrderEntity(
        id: 4,
        orderToken: '#B-104',
        customerId: 0,
        customerName: 'Malik Zeeshan',
        customerPhone: '0312-3456789',
        garmentType: 'Silai Waistcoat',
        bookingDate: DateTime(now.year, now.month, now.day, 10, 20),
        targetDeadline: DateTime(now.year, now.month, now.day + 5),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 2200.0,
        advancePaid: 800.0,
      ),
      OrderEntity(
        id: 5,
        orderToken: '#B-105',
        customerId: 0,
        customerName: 'Haji Abdul Rehman',
        customerPhone: '0345-1234567',
        garmentType: 'Silai Kurta Shalwar',
        bookingDate: DateTime(now.year, now.month, now.day - 6, 12, 0),
        targetDeadline: DateTime(now.year, now.month, now.day - 1),
        isUrgent: false,
        status: OrderStatus.completed,
        stitchingRate: 2000.0,
        advancePaid: 2000.0,
      ),
    ];
  }

  Future<void> _seedSampleOrders() async {
    for (final order in _getSampleOrdersList()) {
      await repository.saveOrder(order);
    }
  }
}
