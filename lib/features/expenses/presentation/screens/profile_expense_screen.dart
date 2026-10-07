import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/financial_overview_card.dart';
import '../widgets/monthly_report_card.dart';

/// Screen combining Daily Expense Tracker (Roznamcha) on top and Financial Overview (Bahi-Khata).
/// 100% offline with zero external dependencies.
class ProfileExpenseScreen extends StatelessWidget {
  const ProfileExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderListProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();

    final totalRevenue = orderProvider.allOrders.fold(
      0.0,
      (sum, o) => sum + o.stitchingRate,
    );
    final totalExpenses = expenseProvider.totalExpenses;
    final netProfit = totalRevenue - totalExpenses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile & Expenses',
          style: TextStyle(
            fontFamily: 'Nunito',
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
              // 1. Top: Workshop Daily Expense Card (روزنامچہ)
              _buildExpenseTopCard(context, expenseProvider),
              const SizedBox(height: 12),

              // 2. Expenses List
              _buildExpensesList(context, expenseProvider),
              const SizedBox(height: 20),

              // 3. Financial Summary Card (حساب کتاب)
              FinancialOverviewCard(
                totalRevenue: totalRevenue,
                totalExpenses: totalExpenses,
                netProfit: netProfit,
              ),
              const SizedBox(height: 16),

              // 4. Monthly PDF Report & Download Card
              const MonthlyReportCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Expense Card with live daily/monthly stats and "+ Add Expense" button
  Widget _buildExpenseTopCard(BuildContext context, ExpenseProvider expenseProvider) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Expenses (روزنامچہ)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Threads, buttons, rent & workshop costs',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => AddExpenseModal.show(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // Expense Quick Metrics
          Row(
            children: [
              Expanded(
                child: _buildStatBlock(
                  label: "Today's Expense (آج)",
                  value: CurrencyFormatter.format(expenseProvider.todayExpenses),
                  color: AppColors.primary,
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildStatBlock(
                  label: 'This Month (اس ماہ)',
                  value: CurrencyFormatter.format(expenseProvider.thisMonthExpenses),
                  color: const Color(0xFFD97706),
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildStatBlock(
                  label: 'Total Entries (اندراج)',
                  value: '${expenseProvider.expenses.length}',
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBlock({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  /// List of expense items with empty state and delete action
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
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 44, color: AppColors.textDisabled),
            SizedBox(height: 12),
            Text(
              'No expenses recorded yet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Tap "+ Add Expense" to track threads, buttons, rent, etc.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
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
                  content: Text('Expense removed'),
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
