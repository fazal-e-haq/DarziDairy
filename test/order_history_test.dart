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

  group('Bottom Navigation Bar & Shell Tests', () {
    testWidgets('Bottom bar displays 4 navigation items and settings/FAB are removed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Verify 4 bottom navigation destinations exist
      expect(find.text('Orders'), findsWidgets);
      expect(find.text('New Order'), findsWidgets);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);

      // Verify settings button is removed from AppBar as requested
      expect(find.byIcon(Icons.settings_outlined), findsNothing);

      // Verify FloatingActionButton is removed from Dashboard as requested
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('Tapping History in bottom bar switches to Order History tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap History bottom nav tab
      await tester.tap(find.byIcon(Icons.history_outlined));
      await tester.pumpAndSettle();

      // Verify Order History page is displayed
      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('Haji Abdul Rehman'), findsOneWidget);
    });

    testWidgets('Tapping Expenses in bottom bar switches to Profile & Expenses tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap Expenses bottom nav tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      // Verify Profile & Expenses page is displayed
      expect(find.text('Profile & Expenses'), findsOneWidget);
      expect(find.text('Financial Overview (حساب کتاب)'), findsOneWidget);
      expect(find.text('Daily Expenses (روزنامچہ)'), findsOneWidget);
    });

    testWidgets('Tapping New Order in bottom bar switches to Create Order tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap New Order bottom nav tab
      await tester.tap(find.byIcon(Icons.add_box_outlined));
      await tester.pumpAndSettle();

      // Verify Create Order form is displayed
      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);
      expect(find.text('Customer Details'), findsOneWidget);
      expect(find.text('Garment & Delivery'), findsOneWidget);
    });
  });

  group('OrderCard Styling Tests', () {
    testWidgets('Completed order card displays soft green tint and border',
        (WidgetTester tester) async {
      final completedOrder = OrderEntity(
        id: 99,
        orderToken: '#99',
        customerId: 1,
        customerName: 'Test Completed Customer',
        customerPhone: '0300-1111111',
        garmentType: 'Silai Shalwar Kameez',
        bookingDate: DateTime.now().subtract(const Duration(days: 3)),
        targetDeadline: DateTime.now().subtract(const Duration(days: 1)),
        isUrgent: false,
        status: OrderStatus.completed,
        stitchingRate: 2000.0,
        advancePaid: 2000.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: completedOrder),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify completed visual badge
      expect(find.textContaining('Completed:'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Verify soft green background
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(OrderCard),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFF0FDF4));
    });

    testWidgets('Urgent active order card displays soft red tint and border',
        (WidgetTester tester) async {
      final urgentOrder = OrderEntity(
        id: 98,
        orderToken: '#98',
        customerId: 1,
        customerName: 'Test Urgent Customer',
        customerPhone: '0300-2222222',
        garmentType: 'Silai Kurta Pajama',
        bookingDate: DateTime.now(),
        targetDeadline: DateTime.now().add(const Duration(days: 2)),
        isUrgent: true,
        status: OrderStatus.active,
        stitchingRate: 2500.0,
        advancePaid: 1000.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: urgentOrder),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify soft red background
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(OrderCard),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFFF1F1));
    });
  });

  group('CreateOrderScreen Validation & UI Tests', () {
    testWidgets('Customer Name and Phone Number are required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Switch to New Order tab
      await tester.tap(find.byIcon(Icons.add_box_outlined));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);

      // Tap Save Order without entering name or phone
      final saveBtn = find.text('Save Order');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('Customer name is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('Fraction toolbar removed and Urdu measurement labels present',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Switch to New Order tab
      await tester.tap(find.byIcon(Icons.add_box_outlined));
      await tester.pumpAndSettle();

      // Verify fraction texts and chips are not present anywhere
      expect(find.textContaining('fraction'), findsNothing);
      expect(find.text('.25'), findsNothing);
      expect(find.text('.50'), findsNothing);
      expect(find.text('.75'), findsNothing);

      // Verify Urdu names in brackets exist in measurement fields
      expect(find.text('Length (لمبائی)'), findsOneWidget);
      expect(find.text('Chest (چھاتی)'), findsOneWidget);
    });
  });
}
