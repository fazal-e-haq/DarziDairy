import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/expense_provider.dart';

/// Workshop expense overview card displaying daily and monthly expense metrics.
/// Strictly 100% offline with zero online dependencies.
class WorkshopProfileCard extends StatelessWidget {
  final ExpenseProvider expenseProvider;

  const WorkshopProfileCard({
    super.key,
    required this.expenseProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Expense Ledger (روزنامچہ کھاتہ)',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shield_outlined, size: 11, color: Color(0xFF059669)),
                                SizedBox(width: 3),
                                Text(
                                  '100% Offline',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Daily Workshop Outflows & Petty Cash (اخراجات کا ریکارڈ)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: Color(0xFFF1F5F9)),

            // Expense metrics row: Today's Expense, This Month's Expense, Total Entries
            Row(
              children: [
                _buildStatItem(
                  label: "Today's Expense (آج)",
                  value: CurrencyFormatter.format(expenseProvider.todayExpenses),
                  color: AppColors.primary,
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                _buildStatItem(
                  label: 'This Month (اس ماہ)',
                  value: CurrencyFormatter.format(expenseProvider.thisMonthExpenses),
                  color: const Color(0xFFD97706),
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                _buildStatItem(
                  label: 'Total Entries (اندراج)',
                  value: '${expenseProvider.expenses.length}',
                  color: const Color(0xFF16A34A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 17,
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
      ),
    );
  }
}
