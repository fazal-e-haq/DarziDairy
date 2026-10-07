import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:darzi_dairy/app.dart';
import 'package:darzi_dairy/core/routing/app_router.dart';
import 'package:darzi_dairy/features/notifications/presentation/providers/notification_provider.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';
import 'package:darzi_dairy/features/orders/data/repositories/order_repository_impl.dart';
import 'package:darzi_dairy/features/orders/presentation/providers/order_list_provider.dart';

void main() {
  setUp(() {
    AppRouter.router.go(AppRouter.dashboard);
  });

  group('Notification Feature Tests', () {
    test('NotificationProvider identifies overdue, due today, and urgent orders', () {
      final now = DateTime.now();
      final provider = NotificationProvider();

      final orders = [
        // Overdue order
        OrderEntity(
          id: 1,
          orderToken: '#1',
          customerId: 1,
          customerName: 'Zubair Khan',
          customerPhone: '0300-1111111',
          garmentType: 'Shalwar Kameez',
          bookingDate: now.subtract(const Duration(days: 5)),
          targetDeadline: now.subtract(const Duration(days: 2)),
          status: OrderStatus.active,
        ),
        // Due today order
        OrderEntity(
          id: 2,
          orderToken: '#2',
          customerId: 2,
          customerName: 'Ali Raza',
          customerPhone: '0300-2222222',
          garmentType: 'Kurta',
          bookingDate: now.subtract(const Duration(days: 2)),
          targetDeadline: now,
          status: OrderStatus.active,
        ),
        // Urgent rush order
        OrderEntity(
          id: 3,
          orderToken: '#3',
          customerId: 3,
          customerName: 'Tariq Mehmood',
          customerPhone: '0300-3333333',
          garmentType: 'Suit',
          bookingDate: now,
          targetDeadline: now.add(const Duration(days: 5)),
          isUrgent: true,
          status: OrderStatus.active,
        ),
      ];

      provider.updateFromOrders(orders);

      expect(provider.notifications.length, 3);
      expect(provider.overdueCount, 1);
      expect(provider.dueTodayCount, 1);
      expect(provider.urgentCount, 1);
      expect(provider.unreadCount, 3);

      // Verify marking as read
      final firstId = provider.notifications.first.id;
      provider.markAsRead(firstId);
      expect(provider.unreadCount, 2);

      // Verify marking all as read
      provider.markAllAsRead();
      expect(provider.unreadCount, 0);
    });
  });

  group('Advance Payment Feature Tests', () {
    test('OrderEntity correctly calculates balanceDue and isFullyPaid', () {
      final order = OrderEntity(
        id: 10,
        orderToken: '#10',
        customerId: 1,
        customerName: 'Customer Test',
        customerPhone: '0300-9999999',
        garmentType: 'Suit',
        bookingDate: DateTime(2026, 1, 1),
        targetDeadline: DateTime(2026, 1, 5),
        stitchingRate: 3000.0,
        advancePaid: 1000.0,
      );

      expect(order.totalBill, 3000.0);
      expect(order.balanceDue, 2000.0);
      expect(order.isFullyPaid, false);
    });

    test('updateAdvancePayment updates order and sets fully paid status', () async {
      final repository = OrderRepositoryImpl(localDataSource: OrderLocalDataSource());
      final provider = OrderListProvider(repository: repository);

      final initialOrder = OrderEntity(
        id: 50,
        orderToken: '#50',
        customerId: 1,
        customerName: 'Payment Test Customer',
        customerPhone: '0300-5555555',
        garmentType: 'Sherwani',
        bookingDate: DateTime.now(),
        targetDeadline: DateTime.now().add(const Duration(days: 3)),
        stitchingRate: 5000.0,
        advancePaid: 1500.0,
      );

      await repository.saveOrder(initialOrder);
      await provider.loadOrders();

      expect(provider.allOrders.firstWhere((o) => o.id == 50).balanceDue, 3500.0);

      // Customer pays remaining 3500
      await provider.updateAdvancePayment(50, 5000.0);
      final updated = provider.allOrders.firstWhere((o) => o.id == 50);
      expect(updated.advancePaid, 5000.0);
      expect(updated.balanceDue, 0.0);
      expect(updated.isFullyPaid, true);

      // Clean up order 50 so subsequent tests start with empty list
      await repository.softDeleteOrder(50);
    });
  });

  group('Dashboard Empty State Button Tests', () {
    testWidgets('Displays Create New Order button when no orders exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Dashboard should display "+ نیا آرڈر لکھیں (New Order)" button
      expect(find.textContaining('New Order'), findsWidgets);

      // Tap New Order button
      await tester.tap(find.textContaining('New Order').first);
      await tester.pumpAndSettle();

      // Should navigate to New Order form
      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);
    });
  });

  group('Expenses Screen Top Card & No Chart Tests', () {
    testWidgets('Expense card is rendered on top and no chart exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Switch to Expenses tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      // Daily Expenses card must be present
      expect(find.text('Daily Expenses (روزنامچہ)'), findsOneWidget);
      expect(find.textContaining('Add Expense'), findsOneWidget);

      // Verify graph/chart is completely absent
      expect(find.text('Financial Analytics (چارٹ گراف)'), findsNothing);
      expect(find.text('Categories'), findsNothing);
    });
  });
}
