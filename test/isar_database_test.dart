import 'package:flutter_test/flutter_test.dart';
import 'package:darzi_dairy/core/database/isar_service.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';
import 'package:darzi_dairy/features/orders/data/repositories/order_repository_impl.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OrderLocalDataSource localDataSource;
  late OrderRepositoryImpl repository;

  setUp(() {
    localDataSource = OrderLocalDataSource();
    repository = OrderRepositoryImpl(localDataSource: localDataSource);
  });

  group('Isar Database & Service Tests', () {
    test('IsarService singleton has valid configuration', () {
      final service = IsarService.instance;
      expect(service, isNotNull);
      expect(IsarService.databaseName, 'tailor_master_db');
    });

    test('IsarService handles init safely without throwing', () async {
      final service = IsarService.instance;
      // Should not throw any exception in any environment
      await expectLater(service.init(), completes);
    });

    test('IsarService reports non-negative storage size', () async {
      final service = IsarService.instance;
      final size = await service.getSize();
      expect(size, greaterThanOrEqualTo(0));
    });
  });

  group('Order Persistence & Repository Tests', () {
    test('Saving and retrieving orders persists data correctly', () async {
      final newOrder = OrderEntity(
        id: 0,
        orderToken: '#10',
        customerId: 10,
        customerName: 'Muhammad Akram',
        customerPhone: '0301-7654321',
        garmentType: 'Silai Kurta Pajama',
        bookingDate: DateTime(2026, 10, 1, 10, 30),
        targetDeadline: DateTime(2026, 10, 5),
        isUrgent: true,
        status: OrderStatus.active,
        stitchingRate: 2400.0,
        advancePaid: 1000.0,
      );

      final savedId = await repository.saveOrder(newOrder);
      expect(savedId, greaterThan(0));

      final fetchedOrder = await repository.getOrderById(savedId);
      expect(fetchedOrder, isNotNull);
      expect(fetchedOrder!.orderToken, '#10');
      expect(fetchedOrder.customerName, 'Muhammad Akram');
      expect(fetchedOrder.customerPhone, '0301-7654321');
      expect(fetchedOrder.stitchingRate, 2400.0);
      expect(fetchedOrder.isUrgent, isTrue);
    });

    test('Updating order status persists between active and completed', () async {
      final newOrder = OrderEntity(
        id: 0,
        orderToken: '#11',
        customerId: 11,
        customerName: 'Tahir Mehmood',
        customerPhone: '0322-9876543',
        garmentType: 'Silai Two-Piece Suit',
        bookingDate: DateTime(2026, 10, 2),
        targetDeadline: DateTime(2026, 10, 7),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 4500.0,
        advancePaid: 2000.0,
      );

      final savedId = await repository.saveOrder(newOrder);

      // Transition to completed
      await repository.updateOrderStatus(savedId, OrderStatus.completed);
      final completedOrder = await repository.getOrderById(savedId);
      expect(completedOrder!.status, OrderStatus.completed);
      expect(completedOrder.isCompleted, isTrue);

      // Transition back to active
      await repository.updateOrderStatus(savedId, OrderStatus.active);
      final reactivatedOrder = await repository.getOrderById(savedId);
      expect(reactivatedOrder!.status, OrderStatus.active);
      expect(reactivatedOrder.isCompleted, isFalse);
    });

    test('Soft deleting and restoring orders functions properly', () async {
      final newOrder = OrderEntity(
        id: 0,
        orderToken: '#12',
        customerId: 12,
        customerName: 'Kamran Ashraf',
        customerPhone: '0334-5556677',
        garmentType: 'Silai Waistcoat',
        bookingDate: DateTime(2026, 10, 3),
        targetDeadline: DateTime(2026, 10, 8),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 1800.0,
        advancePaid: 1800.0,
      );

      final savedId = await repository.saveOrder(newOrder);

      // Soft delete
      await repository.softDeleteOrder(savedId);
      final activeList = await repository.getActiveOrders();
      expect(activeList.any((o) => o.id == savedId), isFalse);

      final recycleList = await repository.getRecycleBinOrders();
      expect(recycleList.any((o) => o.id == savedId), isTrue);

      // Restore
      await repository.restoreOrder(savedId);
      final restoredList = await repository.getActiveOrders();
      expect(restoredList.any((o) => o.id == savedId), isTrue);
    });
  });
}
