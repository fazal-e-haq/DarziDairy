import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/financial_overview_card.dart';
import '../widgets/monthly_report_card.dart';

/// Clean, card-less Expenses screen aligned into 3 unified sections:
/// 1. Financial Overview (with today, month, total orders, profit & expenses list)
/// 2. Daily Expenses (header with words on left, add icon on right, and list of expenses)
/// 3. Monthly Report Download
class ProfileExpenseScreen extends StatelessWidget {
  const ProfileExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderListProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();

    final totalRevenue = orderProvider.allOrders.fold(
      0.0,
      (sum, o) => sum + o.totalBill,
    );
    final totalExpenses = expenseProvider.totalExpenses;
    final netProfit = totalRevenue - totalExpenses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Expenses',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // 1. Financial Overview: today, month, total orders, revenue, expenses & profit
              FinancialOverviewCard(
                todayExpenses: expenseProvider.todayExpenses,
                thisMonthExpenses: expenseProvider.thisMonthExpenses,
                totalOrders: orderProvider.allOrders.length,
                totalRevenue: totalRevenue,
                totalExpenses: totalExpenses,
                netProfit: netProfit,
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 14),

              // 2. Daily Expenses: words on left, add icon on right, followed by expenses list
              _buildDailyExpensesSection(context, expenseProvider),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 14),

              // 3. Monthly Report Download
              const MonthlyReportCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 2: Daily Expenses header with words on left, add icon button on right, and list
  Widget _buildDailyExpensesSection(BuildContext context, ExpenseProvider expenseProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long_outlined, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Daily Expenses',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'روزنامچہ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => AddExpenseModal.show(context),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              tooltip: 'Add Expense',
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildExpensesList(context, expenseProvider),
      ],
    );
  }

  /// List of expense items with card-less empty state and delete action
  Widget _buildExpensesList(BuildContext context, ExpenseProvider expenseProvider) {
    if (expenseProvider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final expenses = expenseProvider.expenses;
    if (expenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined, size: 40, color: AppColors.textDisabled),
              SizedBox(height: 8),
              Text(
                'No expenses recorded yet',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = expenses[index];
        return ExpenseListItem(
          item: item,
          onDelete: () async {
            await expenseProvider.deleteExpense(item.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('خرچہ حذف ہو گیا (Expense removed)'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }
}
