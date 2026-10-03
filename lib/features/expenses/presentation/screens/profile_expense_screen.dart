import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/financial_chart_card.dart';
import '../widgets/financial_overview_card.dart';
import '../widgets/monthly_report_card.dart';
import '../widgets/workshop_profile_card.dart';

/// Screen combining Workshop Profile overview and the Daily Expense Tracker (Roznamcha).
/// Displays live workshop stats, net financial balance, and daily expense logging.
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
              // 1. Handcrafted Workshop Atelier Identity Banner
              WorkshopProfileCard(orderProvider: orderProvider),
              const SizedBox(height: 16),

              // 2. Artisanal Bahi-Khata Financial Ledger Card (حساب کتاب)
              FinancialOverviewCard(
                totalRevenue: totalRevenue,
                totalExpenses: totalExpenses,
                netProfit: netProfit,
              ),
              const SizedBox(height: 16),

              // 3. Financial Analytics Visualizer (fl_chart)
              FinancialChartCard(
                allOrders: orderProvider.allOrders,
                allExpenses: expenseProvider.expenses,
              ),
              const SizedBox(height: 16),

              // 4. Monthly PDF Report & Export Card
              const MonthlyReportCard(),
              const SizedBox(height: 20),

              // 5. Daily Expenses Ledger Header with Add Action
              _buildExpenseRegisterHeader(context),
              const SizedBox(height: 12),

              // 6. Workshop Expenses Register Items
              _buildExpensesList(context, expenseProvider),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  /// Header with "+ Add Expense" trigger button
  Widget _buildExpenseRegisterHeader(BuildContext context) {
    return Row(
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
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Log materials, workshop rent, electricity & tailor wages',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => AddExpenseModal.show(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            elevation: 1,
            shadowColor: AppColors.primary.withValues(alpha: 0.25),
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
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
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
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 28,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No expenses recorded yet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap "+ Add Expense" to log threads, buttons, rent, or daily wages.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
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
