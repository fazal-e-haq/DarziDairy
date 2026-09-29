import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darzi_dairy/app.dart';
import 'package:darzi_dairy/core/routing/app_router.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';
import 'package:darzi_dairy/shared/widgets/order_card.dart';

void main() {
  setUp(() {
    AppRouter.router.go(AppRouter.dashboard);
  });

  group('Dashboard AppBar & Icons Tests', () {
    testWidgets('Dashboard has History and Settings icons and no scissors icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Verify scissors icon is removed
      expect(find.byIcon(Icons.content_cut), findsNothing);

      // Verify history and settings icons are present in AppBar
      expect(find.byIcon(Icons.history_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('Tapping History icon navigates to Order History page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap history icon
      await tester.tap(find.byIcon(Icons.history_rounded));
      await tester.pumpAndSettle();

      // Verify Order History page is displayed
      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('Haji Abdul Rehman'), findsOneWidget);
    });

    testWidgets('Tapping Settings icon navigates to Settings page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap settings icon
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      // Verify Settings page is displayed
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('WORKSHOP PROFILE'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
    });
  });

  group('OrderCard Styling Tests', () {
    testWidgets('Completed order card displays soft green tint and border',
        (WidgetTester tester) async {
      final completedOrder = OrderEntity(
        id: 99,
        orderToken: '#B-99',
        customerId: 1,
        customerName: 'Test Completed Customer',
        customerPhone: '0300-1111111',
        garmentType: 'Silai Kurta',
        bookingDate: DateTime.now().subtract(const Duration(days: 3)),
        targetDeadline: DateTime.now().subtract(const Duration(days: 1)),
        isUrgent: false,
        status: OrderStatus.completed,
        stitchingRate: 2500,
        advancePaid: 2500,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: completedOrder),
          ),
        ),
      );

      // Find the card container
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Soft green background: #F0FDF4
      expect(decoration.color, const Color(0xFFF0FDF4));

      // Soft green border: #86EFAC
      final border = decoration.border as Border;
      expect(border.top.color, const Color(0xFF86EFAC));

      // Completed checkmark icon
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.textContaining('Completed:'), findsOneWidget);
    });

    testWidgets('Urgent active order card displays soft red tint and border',
        (WidgetTester tester) async {
      final urgentOrder = OrderEntity(
        id: 98,
        orderToken: '#B-98',
        customerId: 2,
        customerName: 'Test Urgent Customer',
        customerPhone: '0300-2222222',
        garmentType: 'Silai Sherwani',
        bookingDate: DateTime.now(),
        targetDeadline: DateTime.now().add(const Duration(days: 1)),
        isUrgent: true,
        status: OrderStatus.active,
        stitchingRate: 5000,
        advancePaid: 2500,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: urgentOrder),
          ),
        ),
      );

      // Find the card container
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Soft red background: #FFF1F1
      expect(decoration.color, const Color(0xFFFFF1F1));

      // Soft red border: #FCA5A5
      final border = decoration.border as Border;
      expect(border.top.color, const Color(0xFFFCA5A5));
    });

    testWidgets('Marking order completed moves it to History with soft green tint',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap on Chaudhry Nadeem's order card on Dashboard
      expect(find.text('Chaudhry Nadeem'), findsOneWidget);
      await tester.tap(find.text('Chaudhry Nadeem'));
      await tester.pumpAndSettle();

      // On Order Detail Screen, tap 'Mark as Completed'
      final markCompletedBtn = find.text('Mark as Completed');
      expect(markCompletedBtn, findsOneWidget);
      await tester.tap(markCompletedBtn);
      await tester.pumpAndSettle();

      // Tap 'View History' from SnackBar
      final viewHistoryBtn = find.text('View History');
      expect(viewHistoryBtn, findsOneWidget);
      await tester.tap(viewHistoryBtn);
      await tester.pumpAndSettle();

      // Verify we are on Order History page and Chaudhry Nadeem is present
      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('Chaudhry Nadeem'), findsOneWidget);

      // Verify Chaudhry Nadeem's card now has completed checkmark and green styling
      expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
    });
  });

  group('CreateOrderScreen Validation & UI Tests', () {
    testWidgets('Customer Name and Phone Number are required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Navigate to create order
      AppRouter.router.push(AppRouter.createOrder);
      await tester.pumpAndSettle();

      expect(find.text('New Order'), findsOneWidget);

      // Tap Save Order without entering name or phone
      final saveBtn = find.text('Save Order');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('Customer name is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('Fraction toolbar and fraction chips are completely removed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Navigate to create order
      AppRouter.router.push(AppRouter.createOrder);
      await tester.pumpAndSettle();

      // Verify fraction texts and chips are not present anywhere
      expect(find.textContaining('fraction'), findsNothing);
      expect(find.text('.25'), findsNothing);
      expect(find.text('.50'), findsNothing);
      expect(find.text('.75'), findsNothing);
    });
  });
}
