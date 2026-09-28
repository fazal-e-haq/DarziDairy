import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_order_repository.dart';

enum OrderFilter { all, today, cutting, trialReady, urgent }

/// Provider for managing workshop order pipeline and filtering
class OrderListProvider extends ChangeNotifier {
  final IOrderRepository repository;

  OrderListProvider({required this.repository}) {
    loadOrders();
  }

  List<OrderEntity> _allOrders = [];
  OrderFilter _activeFilter = OrderFilter.all;
  OrderEntity? _selectedOrder;
  bool _isLoading = false;

  List<OrderEntity> get allOrders => _allOrders;
  OrderFilter get activeFilter => _activeFilter;
  OrderEntity? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;

  /// Returns filtered list based on the active filter pill
  List<OrderEntity> get filteredOrders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_activeFilter) {
      case OrderFilter.all:
        return _allOrders;
      case OrderFilter.today:
        return _allOrders.where((o) {
          final target = DateTime(o.targetDeadline.year, o.targetDeadline.month, o.targetDeadline.day);
          return target.isBefore(today.add(const Duration(days: 1)));
        }).toList();
      case OrderFilter.cutting:
        return _allOrders.where((o) => o.status == OrderStatus.cutting).toList();
      case OrderFilter.trialReady:
        return _allOrders.where((o) => o.status == OrderStatus.trialReady).toList();
      case OrderFilter.urgent:
        return _allOrders.where((o) => o.isUrgent).toList();
    }
  }

  // Count getters for filter badges
  int get countAll => _allOrders.length;
  int get countUrgent => _allOrders.where((o) => o.isUrgent).length;
  int get countToday => _allOrders.where((o) {
        final now = DateTime.now();
        final target = DateTime(o.targetDeadline.year, o.targetDeadline.month, o.targetDeadline.day);
        return target.isBefore(DateTime(now.year, now.month, now.day + 1));
      }).length;
  int get countCutting => _allOrders.where((o) => o.status == OrderStatus.cutting).length;
  int get countTrialReady => _allOrders.where((o) => o.status == OrderStatus.trialReady).length;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    _allOrders = await repository.getActiveOrders();

    // Auto-seed sample orders for initial showcase if database is empty
    if (_allOrders.isEmpty) {
      await _seedSampleOrders();
      _allOrders = await repository.getActiveOrders();
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

  void selectOrder(OrderEntity order) {
    _selectedOrder = order;
    notifyListeners();
  }

  Future<void> advanceStatus(int orderId) async {
    final index = _allOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final currentOrder = _allOrders[index];
      if (currentOrder.status.index < OrderStatus.values.length - 1) {
        final nextStatus = OrderStatus.values[currentOrder.status.index + 1];
        await repository.updateOrderStatus(orderId, nextStatus);
        await loadOrders();
      }
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

  Future<void> _seedSampleOrders() async {
    final now = DateTime.now();
    final sampleOrders = [
      OrderEntity(
        id: 0,
        orderToken: '#B-101',
        customerId: 1,
        customerName: 'Chaudhry Nadeem',
        customerPhone: '0300-8452199',
        garmentType: 'Kurta Pajama',
        bookingDate: now.subtract(const Duration(days: 3)),
        targetDeadline: now.add(const Duration(days: 1)),
        isUrgent: true,
        status: OrderStatus.cutting,
        stitchingRate: 1800.0,
        fabricCharges: 400.0,
        urgentSurcharge: 300.0,
        advancePaid: 1000.0,
      ),
      OrderEntity(
        id: 0,
        orderToken: '#B-102',
        customerId: 2,
        customerName: 'Sheikh Tariq',
        customerPhone: '0321-4567890',
        garmentType: 'Two-Piece Suit',
        bookingDate: now.subtract(const Duration(days: 5)),
        targetDeadline: now,
        isUrgent: true,
        status: OrderStatus.stitching,
        stitchingRate: 6500.0,
        fabricCharges: 1200.0,
        urgentSurcharge: 500.0,
        advancePaid: 4000.0,
      ),
      OrderEntity(
        id: 0,
        orderToken: '#B-103',
        customerId: 3,
        customerName: 'Bilal Farooq',
        customerPhone: '0333-9876543',
        garmentType: 'Shalwar Kameez',
        bookingDate: now.subtract(const Duration(days: 2)),
        targetDeadline: now.add(const Duration(days: 3)),
        isUrgent: false,
        status: OrderStatus.trialReady,
        stitchingRate: 1600.0,
        fabricCharges: 0.0,
        urgentSurcharge: 0.0,
        advancePaid: 1600.0,
      ),
      OrderEntity(
        id: 0,
        orderToken: '#B-104',
        customerId: 4,
        customerName: 'Malik Zeeshan',
        customerPhone: '0312-3456789',
        garmentType: 'Waistcoat',
        bookingDate: now.subtract(const Duration(days: 1)),
        targetDeadline: now.add(const Duration(days: 4)),
        isUrgent: false,
        status: OrderStatus.pending,
        stitchingRate: 2200.0,
        fabricCharges: 600.0,
        urgentSurcharge: 0.0,
        advancePaid: 800.0,
      ),
    ];

    for (final order in sampleOrders) {
      await repository.saveOrder(order);
    }
  }
}
