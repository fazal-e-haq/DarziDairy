import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:darzi_dairy/features/expenses/data/repositories/expense_repository.dart';
import 'package:darzi_dairy/features/expenses/domain/entities/expense_entity.dart';
import 'package:darzi_dairy/features/expenses/presentation/providers/expense_provider.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/monthly_report_card.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/financial_overview_card.dart';
import 'package:darzi_dairy/features/expenses/utils/monthly_report_pdf_generator.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';
import 'package:darzi_dairy/features/orders/data/repositories/order_repository_impl.dart';
import 'package:darzi_dairy/features/orders/domain/entities/order_entity.dart';
import 'package:darzi_dairy/features/orders/presentation/providers/order_list_provider.dart';

void main() {
  group('Monthly Report PDF Generator Tests', () {
    test('generateMonthlyReportBytes creates valid non-empty PDF file bytes', () async {
      final now = DateTime.now();
      final orders = [
        OrderEntity(
          id: 1,
          orderToken: '#1',
          customerId: 1,
          customerName: 'Test Customer',
          customerPhone: '0300-1111111',
          garmentType: 'Shalwar Kameez',
          bookingDate: now,
          targetDeadline: now.add(const Duration(days: 3)),
          stitchingRate: 2500.0,
          advancePaid: 1000.0,
          status: OrderStatus.active,
        ),
      ];

      final expenses = [
        ExpenseEntity(
          id: 1,
          title: 'Zari Thread',
          category: 'Materials',
          amount: 450.0,
          date: now,
          createdAt: now,
        ),
      ];

      final bytes = await MonthlyReportPdfGenerator.generateMonthlyReportBytes(
        year: now.year,
        month: now.month,
        allOrders: orders,
        allExpenses: expenses,
      );

      expect(bytes, isNotEmpty);
      final header = ascii.decode(bytes.sublist(0, 4));
      expect(header, '%PDF');
    });

    test('generateMonthlyReportBytes handles empty orders and expenses cleanly', () async {
      final now = DateTime.now();
      final bytes = await MonthlyReportPdfGenerator.generateMonthlyReportBytes(
        year: now.year,
        month: now.month,
        allOrders: const [],
        allExpenses: const [],
      );

      expect(bytes, isNotEmpty);
      final header = ascii.decode(bytes.sublist(0, 4));
      expect(header, '%PDF');
    });
  });

  group('MonthlyReportCard Widget Tests', () {
    testWidgets('renders month selector and download button without share button', (WidgetTester tester) async {
      final expenseRepo = ExpenseRepository();
      final orderRepo = OrderRepositoryImpl(localDataSource: OrderLocalDataSource());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<OrderListProvider>(
              create: (_) => OrderListProvider(repository: orderRepo),
            ),
            ChangeNotifierProvider<ExpenseProvider>(
              create: (_) => ExpenseProvider(repository: expenseRepo),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: MonthlyReportCard(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Monthly Report'), findsOneWidget);
      expect(find.text('ماہانہ رپورٹ'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);
      expect(find.text('Share'), findsNothing);
    });
  });

  group('FinancialOverviewCard Ledger Widget Tests', () {
    testWidgets('renders financial ledger list with English on left and Urdu on right',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FinancialOverviewCard(
              todayExpenses: 500.0,
              thisMonthExpenses: 2500.0,
              totalOrders: 10,
              totalRevenue: 25000.0,
              totalExpenses: 5000.0,
              netProfit: 20000.0,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Financial Overview'), findsOneWidget);
      expect(find.text('حساب کتاب'), findsOneWidget);

      // Verify English Labels
      expect(find.text("Today's Expense"), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.text('Total Revenue'), findsOneWidget);
      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Net Profit'), findsOneWidget);

      // Verify Urdu Labels without brackets
      expect(find.text('آج کا خرچہ'), findsOneWidget);
      expect(find.text('اس ماہ کا خرچہ'), findsOneWidget);
      expect(find.text('کل آرڈرز'), findsOneWidget);
      expect(find.text('کل آمدنی'), findsOneWidget);
      expect(find.text('کل اخراجات'), findsOneWidget);
      expect(find.text('خالص منافع'), findsOneWidget);

      // Verify numbers and down details have large font size (>= 22)
      final todayExpenseValue = tester.widget<Text>(find.text('Rs. 500'));
      expect(todayExpenseValue.style?.fontSize, greaterThanOrEqualTo(22.0));

      final netProfitValue = tester.widget<Text>(find.text('Rs. 20,000'));
      expect(netProfitValue.style?.fontSize, greaterThanOrEqualTo(22.0));
    });
  });
}
