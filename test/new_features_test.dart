import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:darzi_dairy/app.dart';
import 'package:darzi_dairy/core/routing/app_router.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';
import 'package:darzi_dairy/features/orders/data/repositories/order_repository_impl.dart';
import 'package:darzi_dairy/features/orders/presentation/providers/order_list_provider.dart';

void main() {
  setUp(() {
    AppRouter.router.go(AppRouter.dashboard);
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

  group('Dashboard Empty State Illustration & Sentence Tests', () {
    testWidgets('Displays illustrator icon and no orders sentence without button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Dashboard empty state displays illustrator icon and single sentence
      expect(find.text('No orders yet (ابھی کوئی آرڈر نہیں ہے)'), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
      expect(find.byIcon(Icons.content_cut_rounded), findsWidgets);

      // Verify no extra description or duplicate button in empty view
      expect(find.text('Start recording customer measurements, stitching rates, and delivery dates.'), findsNothing);
      expect(find.text('+ نیا آرڈر لکھیں (New Order)'), findsNothing);

      // Tap New Order FAB
      await tester.tap(find.widgetWithText(FloatingActionButton, 'New Order'));
      await tester.pumpAndSettle();

      // Should navigate to New Order form
      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);
    });
  });

  group('Expenses Screen Ordered Sections & No Chart Tests', () {
    testWidgets('Financial Overview is on top, Daily Expenses has add icon, and no chart exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Switch to Expenses tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      // Financial Overview and Daily Expenses must be present
      expect(find.text('Financial Overview'), findsOneWidget);
      expect(find.text('Daily Expenses'), findsOneWidget);
      expect(find.byTooltip('Add Expense'), findsOneWidget);

      // Verify graph/chart is completely absent
      expect(find.text('Financial Analytics (چارٹ گراف)'), findsNothing);
      expect(find.text('Categories'), findsNothing);
    });
  });
}
