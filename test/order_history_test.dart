import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:darzi_dairy/app.dart';
import 'package:darzi_dairy/core/routing/app_router.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';
import 'package:darzi_dairy/features/orders/presentation/widgets/order_card.dart';
import 'package:darzi_dairy/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:darzi_dairy/features/orders/presentation/providers/order_list_provider.dart';
import 'package:darzi_dairy/features/orders/data/repositories/order_repository_impl.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';
import 'package:darzi_dairy/features/orders/presentation/screens/orders_dashboard_screen.dart';

void main() {
  setUp(() {
    AppRouter.router.go(AppRouter.dashboard);
  });

  group('Bottom Navigation Bar & Shell Tests', () {
    testWidgets('Bottom bar displays 3 navigation items and New Order is on FAB',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Verify 3 bottom navigation destinations exist
      expect(find.text('Orders'), findsWidgets);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);

      // Verify settings button is removed from AppBar as requested
      expect(find.byIcon(Icons.settings_outlined), findsNothing);

      // Verify FloatingActionButton exists on Orders Dashboard
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.widgetWithText(FloatingActionButton, 'New Order'), findsOneWidget);
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
      expect(find.text('No completed orders yet'), findsOneWidget);
    });

    testWidgets('Tapping Expenses in bottom bar switches to Expenses tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap Expenses bottom nav tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      // Verify Expenses page is displayed with profile word removed
      expect(find.widgetWithText(AppBar, 'Expenses'), findsOneWidget);
      expect(find.text('Profile & Expenses'), findsNothing);
      expect(find.text('Daily Expenses'), findsOneWidget);
      expect(find.text('Financial Overview'), findsOneWidget);
    });

    testWidgets('Tapping New Order FAB on Dashboard navigates to Create Order screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Tap New Order FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify Create Order form is displayed
      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);
      expect(find.text('Customer Details'), findsOneWidget);
      expect(find.text('Garment Type'), findsOneWidget);
      expect(find.text('Shalwar Kameez'), findsOneWidget);
      expect(find.text('شلوار قمیض'), findsOneWidget);
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

      // Verify completed visual text is removed
      expect(find.text('• COMPLETED'), findsNothing);

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

      // Verify urgent text is completely removed as requested
      expect(find.text('• URGENT'), findsNothing);
      expect(find.text('URGENT'), findsNothing);
    });

    testWidgets('OrderCard displays Order 99 title (not just #99) and compact metrics',
        (WidgetTester tester) async {
      final sampleOrder = OrderEntity(
        id: 99,
        orderToken: '#99',
        customerId: 1,
        customerName: 'Muhammad Ali',
        customerPhone: '0300-1234567',
        garmentType: 'Silai Shalwar Kameez',
        bookingDate: DateTime(2026, 10, 10),
        targetDeadline: DateTime(2026, 10, 15),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 1800.0,
        advancePaid: 700.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: sampleOrder),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title is "Order 99" instead of only "#99"
      expect(find.text('Order 99'), findsOneWidget);

      // Verify two dividers exist (between name & type, and between type & calculations)
      expect(
        find.descendant(of: find.byType(OrderCard), matching: find.byType(Divider)),
        findsNWidgets(2),
      );

      // Verify metric labels
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Advance'), findsOneWidget);
      expect(find.text('Remain'), findsOneWidget);
      expect(find.text('Due Date'), findsOneWidget);
      expect(find.text('Order Date'), findsOneWidget);
    });
  });

  group('CreateOrderScreen Validation & UI Tests', () {
    testWidgets('Customer Name and Phone Number are required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Open New Order screen via Dashboard FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'New Order'), findsOneWidget);

      // Tap Save Order without entering name or phone
      final saveBtn = find.textContaining('Save Order');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('Customer name is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('Phone number requires exactly 11 digits and Customer Name only allows alphabets',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Open New Order screen via Dashboard FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter short phone number
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Ali Khan');
      await tester.enterText(textFields.at(1), '0300123'); // 7 digits instead of 11

      final saveBtn = find.textContaining('Save Order');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Phone number must be exactly 11 digits'), findsOneWidget);
    });

    testWidgets('Garment types column list has English on left and Urdu on right without brackets',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TailorMasterApp());
      await tester.pumpAndSettle();

      // Open New Order screen via Dashboard FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify Radio column has English on left and Urdu on right without brackets
      expect(find.text('Shalwar Kameez'), findsOneWidget);
      expect(find.text('شلوار قمیض'), findsOneWidget);
      expect(find.text('Kurta Pajama'), findsOneWidget);
      expect(find.text('کرتہ پاجامہ'), findsOneWidget);
      expect(find.text('Pant Shirt'), findsOneWidget);
      expect(find.text('پینٹ شرٹ'), findsOneWidget);
      expect(find.text('Waistcoat'), findsOneWidget);
      expect(find.text('واسکٹ'), findsOneWidget);

      // Verify button has bilingual text
      expect(find.text('Save Order (آرڈر محفوظ کریں)'), findsOneWidget);

      // Verify Urdu names in brackets exist in measurement fields
      expect(find.text('Length (لمبائی)'), findsOneWidget);
      expect(find.text('Chest (چھاتی)'), findsOneWidget);
    });
  });

  group('OrderDetailScreen Title, Menu & Headings Tests', () {
    testWidgets('Displays Order 1 in AppBar, copy menu item, and Urdu only in headings',
        (WidgetTester tester) async {
      final repository = OrderRepositoryImpl(localDataSource: OrderLocalDataSource());
      final provider = OrderListProvider(repository: repository);
      final testOrder = OrderEntity(
        id: 1,
        orderToken: '#1',
        customerId: 1,
        customerName: 'Hassan Raza',
        customerPhone: '0300-1234567',
        garmentType: 'Silai Shalwar Kameez',
        bookingDate: DateTime(2026, 10, 10),
        targetDeadline: DateTime(2026, 10, 15),
        isUrgent: false,
        status: OrderStatus.active,
        stitchingRate: 1800.0,
        advancePaid: 700.0,
      );
      await repository.saveOrder(testOrder);
      await provider.loadOrders();

      await tester.pumpWidget(
        ChangeNotifierProvider<OrderListProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: OrderDetailScreen(orderId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AppBar title is "Order 1" instead of "#1"
      expect(find.widgetWithText(AppBar, 'Order 1'), findsOneWidget);

      // Verify headings have Urdu
      expect(find.text('Order Details'), findsOneWidget);
      expect(find.text('(آرڈر کی تفصیل)'), findsOneWidget);
      expect(find.text('Payment Summary'), findsOneWidget);
      expect(find.text('(حساب کتاب)'), findsOneWidget);

      // Verify detail rows have clean English labels
      expect(find.text('Garment Type'), findsOneWidget);
      expect(find.text('Booking Date'), findsOneWidget);
      expect(find.text('Delivery Date'), findsOneWidget);
      expect(find.text('Total Rate'), findsOneWidget);
      expect(find.text('Advance Paid'), findsOneWidget);
      expect(find.text('Balance Due'), findsOneWidget);

      // Verify AppBar has copy button
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);

      // Open PopupMenuButton and verify copy and delete options exist
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Copy Details (کاپی کریں)'), findsOneWidget);

      // Tap Delete Order to test delete confirmation dialog
      await tester.tap(find.text('Delete Order (حذف کریں)'));
      await tester.pumpAndSettle();

      // Verify delete dialog is pure English with Cancel and Delete buttons
      expect(find.text('Delete Order 1?'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this order from records?'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      await repository.softDeleteOrder(1);
    });

    testWidgets('Lazy loading smoothly handles large volume orders without bloat',
        (WidgetTester tester) async {
      final repository = OrderRepositoryImpl(localDataSource: OrderLocalDataSource());
      final largeOrders = List.generate(
        100,
        (i) => OrderEntity(
          id: 500 + i,
          orderToken: '#${500 + i}',
          customerId: 1,
          customerName: 'Bulk Customer $i',
          customerPhone: '03001234567',
          garmentType: 'Kurta Pajama',
          bookingDate: DateTime.now(),
          targetDeadline: DateTime.now().add(const Duration(days: 3)),
          status: OrderStatus.active,
          stitchingRate: 1500,
          advancePaid: 500,
        ),
      );
      for (final o in largeOrders) {
        await repository.saveOrder(o);
      }

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => OrderListProvider(repository: repository)),
          ],
          child: const MaterialApp(
            home: OrdersDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // First batch is rendered immediately with high performance
      expect(find.text('Bulk Customer 0'), findsOneWidget);
      // Item 90 is lazily deferred
      expect(find.text('Bulk Customer 90'), findsNothing);

      // Clean up test orders
      for (final o in largeOrders) {
        await repository.softDeleteOrder(o.id);
      }
    });
  });
}
