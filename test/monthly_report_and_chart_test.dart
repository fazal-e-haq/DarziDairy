import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:darzi_dairy/features/expenses/data/repositories/expense_repository.dart';
import 'package:darzi_dairy/features/expenses/domain/entities/expense_entity.dart';
import 'package:darzi_dairy/features/expenses/presentation/providers/expense_provider.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/monthly_report_card.dart';
import 'package:darzi_dairy/features/expenses/presentation/widgets/workshop_profile_card.dart';
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

      expect(find.text('Monthly PDF Report (ماہانہ رپورٹ)'), findsOneWidget);
      expect(find.textContaining('Download PDF'), findsOneWidget);
      expect(find.text('Share'), findsNothing);
    });
  });

  group('WorkshopProfileCard Expense-Only Widget Tests', () {
    testWidgets('renders expense ledger header and metrics without shop name or online elements',
        (WidgetTester tester) async {
      final expenseRepo = ExpenseRepository();
      final provider = ExpenseProvider(repository: expenseRepo);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkshopProfileCard(expenseProvider: provider),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Expense Header & Offline Badge
      expect(find.text('Expense Ledger (روزنامچہ کھاتہ)'), findsOneWidget);
      expect(find.text('100% Offline'), findsOneWidget);
      expect(find.text('Daily Workshop Outflows & Petty Cash (اخراجات کا ریکارڈ)'), findsOneWidget);

      // Verify Expense Metric Labels
      expect(find.text("Today's Expense (آج)"), findsOneWidget);
      expect(find.text('This Month (اس ماہ)'), findsOneWidget);
      expect(find.text('Total Entries (اندراج)'), findsOneWidget);

      // Verify previous shop name and subtitle are completely removed
      expect(find.text('DarziDairy Tailors'), findsNothing);
      expect(find.text('Master Tailoring & Stitching Workshop'), findsNothing);
    });
  });
}
