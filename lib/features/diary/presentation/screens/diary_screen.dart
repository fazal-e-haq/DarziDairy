import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/diary_provider.dart';
import '../widgets/add_expense_bottom_sheet.dart';
import '../widgets/cash_summary_card.dart';

/// Tailor's Daily Diary & Roznamcha Cash Register screen
class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.menu_book, size: 20, color: AppColors.secondary),
            SizedBox(width: AppDimensions.space8),
            Text(AppStrings.navDiary),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: "Today's Ledger",
            onPressed: () => context.read<DiaryProvider>().loadDailySummary(DateTime.now()),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Select Date',
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: context.read<DiaryProvider>().selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && context.mounted) {
                context.read<DiaryProvider>().loadDailySummary(picked);
              }
            },
          ),
        ],
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = provider.dailySummary;
          if (summary == null) {
            return const Center(child: Text('No ledger data available'));
          }

          return ResponsiveLayout.builder(
            builder: (context, constraints, screenType) {
              final isUnfolded = screenType == ScreenType.unfolded;

              final summaryWidget = Column(
                children: [
                  CashSummaryCard(summary: summary),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            title: 'Jobs Booked',
                            value: '${summary.ordersBooked}',
                            icon: Icons.add_shopping_cart,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: _buildMetricTile(
                            title: 'Jobs Delivered',
                            value: '${summary.ordersDelivered}',
                            icon: Icons.check_circle_outline,
                            color: AppColors.statusReady,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: _buildMetricTile(
                            title: 'Urgent Pending',
                            value: '${provider.urgentDueCount}',
                            icon: Icons.warning_amber_rounded,
                            color: AppColors.statusError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final expensesWidget = Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Workshop Expenses (${DateFormatter.formatShortDate(provider.selectedDate)})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Total: ${CurrencyFormatter.format(summary.totalCashOut)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.statusError),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    if (summary.expenses.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'No expenses logged for this date.\nTap "+ Log Expense" below to record purchases.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summary.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = summary.expenses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppDimensions.space8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.statusError.withValues(alpha: 0.1),
                                foregroundColor: AppColors.statusError,
                                child: const Icon(Icons.shopping_bag_outlined, size: 20),
                              ),
                              title: Text(
                                expense.category,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: expense.note != null && expense.note!.isNotEmpty
                                  ? Text(expense.note!, style: const TextStyle(fontSize: 12))
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '- ${CurrencyFormatter.format(expense.amount)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.statusError,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                                    onPressed: () => provider.deleteExpense(expense.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );

              if (isUnfolded) {
                return SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: summaryWidget),
                      Expanded(flex: 6, child: expensesWidget),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    summaryWidget,
                    const SizedBox(height: AppDimensions.space16),
                    expensesWidget,
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        onPressed: () => AddExpenseBottomSheet.show(context),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Log Expense'),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.roundedMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
