import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:darzi_dairy/features/expenses/data/repositories/expense_repository.dart';
import 'package:darzi_dairy/features/expenses/domain/entities/expense_entity.dart';
import 'package:darzi_dairy/features/expenses/presentation/providers/expense_provider.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/financial_chart_card.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/monthly_report_card.dart';
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
          customerName: 'Muhammad Ali',
          customerPhone: '0300-1234567',
          garmentType: 'Gentlemen Suit (شلوار قمیض)',
          bookingDate: now,
          targetDeadline: now.add(const Duration(days: 3)),
          isUrgent: false,
          status: OrderStatus.active,
          stitchingRate: 2000.0,
          advancePaid: 2000.0,
        ),
      ];

      final expenses = [
        ExpenseEntity(
          id: 1,
          title: 'White Thread Spools',
          category: 'Threads (دھاگہ)',
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
      // Valid PDF files begin with '%PDF'
      final header = ascii.decode(bytes.sublist(0, 4));
      expect(header, '%PDF');
    });

    test('generateMonthlyReportBytes handles empty orders and expenses cleanly', () async {
      final now = DateTime.now();
      final bytes = await MonthlyReportPdfGenerator.generateMonthlyReportBytes(
        year: now.year,
        month: now.month,
        allOrders: [],
        allExpenses: [],
      );

      expect(bytes, isNotEmpty);
      final header = ascii.decode(bytes.sublist(0, 4));
      expect(header, '%PDF');
    });
  });

  group('FinancialChartCard Widget Tests', () {
    testWidgets('renders empty state when no orders or expenses exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FinancialChartCard(
              allOrders: [],
              allExpenses: [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Financial Analytics (چارٹ گراف)'), findsOneWidget);
      expect(find.text('No financial records to display'), findsOneWidget);
    });

    testWidgets('renders bar chart and switches to pie chart on category tap', (WidgetTester tester) async {
      final now = DateTime.now();
      final orders = [
        OrderEntity(
          id: 1,
          orderToken: '#1',
          customerId: 1,
          customerName: 'Ahmed Raza',
          customerPhone: '0301-7654321',
          garmentType: 'Kurta Pajama',
          bookingDate: now,
          targetDeadline: now.add(const Duration(days: 2)),
          isUrgent: true,
          status: OrderStatus.active,
          stitchingRate: 2500.0,
          advancePaid: 1500.0,
        ),
      ];

      final expenses = [
        ExpenseEntity(
          id: 1,
          title: 'Suit Buttons Box',
          category: 'Buttons (بٹن)',
          amount: 600.0,
          date: now,
          createdAt: now,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FinancialChartCard(
                allOrders: orders,
                allExpenses: expenses,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify header and default Comparison view
      expect(find.text('Financial Analytics (چارٹ گراف)'), findsOneWidget);
      expect(find.text('Revenue (آمدنی)'), findsOneWidget);
      expect(find.text('Expenses (خرچہ)'), findsOneWidget);

      // Switch to Categories Pie Chart
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      // Verify category legend appears
      expect(find.textContaining('Buttons (بٹن)'), findsOneWidget);
    });
  });

  group('MonthlyReportCard Widget Tests', () {
    testWidgets('renders month selector and download/share buttons', (WidgetTester tester) async {
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

      expect(find.text('Monthly PDF Report (ماہانہ رپورٹ)'), findsOneWidget);
      expect(find.text('Download / Print PDF'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });
  });
}
