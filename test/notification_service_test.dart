import 'package:flutter_test/flutter_test.dart';
import 'package:darzi_dairy/core/services/notification_service.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Tests', () {
    test('NotificationService singleton initializes safely without throwing', () async {
      await expectLater(NotificationService.instance.init(), completes);
    });

    test('schedule3DaysBefore handles completed order by cancelling', () async {
      final order = OrderEntity(
        id: 101,
        orderToken: '#101',
        customerId: 1,
        customerName: 'Test Customer',
        customerPhone: '03001234567',
        garmentType: 'Kurta Pajama',
        bookingDate: DateTime.now(),
        targetDeadline: DateTime.now().add(const Duration(days: 7)),
        status: OrderStatus.completed,
      );

      await expectLater(
        NotificationService.instance.schedule3DaysBefore(order),
        completes,
      );
    });

    test('schedule3DaysBefore handles past/near-term deadline without throwing', () async {
      final order = OrderEntity(
        id: 102,
        orderToken: '#102',
        customerId: 1,
        customerName: 'Test Customer 2',
        customerPhone: '03001234567',
        garmentType: 'Shalwar Kameez',
        bookingDate: DateTime.now().subtract(const Duration(days: 2)),
        targetDeadline: DateTime.now().add(const Duration(days: 1)), // Less than 3 days
        status: OrderStatus.active,
      );

      await expectLater(
        NotificationService.instance.schedule3DaysBefore(order),
        completes,
      );
    });

    test('cancel completes safely for any order id', () async {
      await expectLater(NotificationService.instance.cancel(999), completes);
    });

    test('OrderEntity copyWith copies and overrides fields accurately', () {
      final order = OrderEntity(
        id: 1,
        orderToken: '#1',
        customerId: 10,
        customerName: 'Ali',
        customerPhone: '03001112233',
        garmentType: 'Kameez',
        bookingDate: DateTime(2026, 1, 1),
        targetDeadline: DateTime(2026, 1, 10),
      );

      final updated = order.copyWith(id: 42, status: OrderStatus.completed, advancePaid: 500);

      expect(updated.id, 42);
      expect(updated.status, OrderStatus.completed);
      expect(updated.advancePaid, 500);
      expect(updated.customerName, 'Ali');
      expect(updated.orderToken, '#1');
    });
  });
}
