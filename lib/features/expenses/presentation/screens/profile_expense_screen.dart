import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/financial_overview_card.dart';
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
              // 1. Workshop Profile Card
              WorkshopProfileCard(orderProvider: orderProvider),
              const SizedBox(height: 16),

              // 2. Financial Summary Card (حساب کتاب)
              FinancialOverviewCard(
                totalRevenue: totalRevenue,
                totalExpenses: totalExpenses,
                netProfit: netProfit,
              ),
              const SizedBox(height: 16),

              // 3. Expense Register Header with Add Button
              _buildExpenseRegisterHeader(context),
              const SizedBox(height: 12),

              // 4. Expenses List
              _buildExpensesList(context, expenseProvider),
              const SizedBox(height: 32),
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
      children: [
        const Text(
          'Daily Expenses (روزنامچہ)',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => AddExpenseModal.show(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
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
