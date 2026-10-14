import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Clean, card-less Financial Overview ledger.
/// Shows English label on top and Rs value underneath (in down),
/// with Urdu translation on the right side without brackets.
class FinancialOverviewCard extends StatelessWidget {
  final double todayExpenses;
  final double thisMonthExpenses;
  final int totalOrders;
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;

  const FinancialOverviewCard({
    super.key,
    required this.todayExpenses,
    required this.thisMonthExpenses,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: English on left, Urdu on right without brackets
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Financial Overview',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Text(
              'حساب کتاب',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List of entries: left side label on top & value in down, right side Urdu
        _buildLedgerRow(
          english: "Today's Expense",
          value: CurrencyFormatter.format(todayExpenses),
          urdu: 'آج کا خرچہ',
          valueColor: AppColors.primary,
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),

        _buildLedgerRow(
          english: 'This Month',
          value: CurrencyFormatter.format(thisMonthExpenses),
          urdu: 'اس ماہ کا خرچہ',
          valueColor: const Color(0xFFD97706),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),

        _buildLedgerRow(
          english: 'Total Orders',
          value: '$totalOrders',
          urdu: 'کل آرڈرز',
          valueColor: const Color(0xFF0284C7),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),

        _buildLedgerRow(
          english: 'Total Revenue',
          value: CurrencyFormatter.format(totalRevenue),
          urdu: 'کل آمدنی',
          valueColor: const Color(0xFF16A34A),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),

        _buildLedgerRow(
          english: 'Total Expenses',
          value: CurrencyFormatter.format(totalExpenses),
          urdu: 'کل اخراجات',
          valueColor: const Color(0xFFDC2626),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),

        // Net Profit / Balance
        _buildLedgerRow(
          english: 'Net Profit',
          value: CurrencyFormatter.format(netProfit),
          urdu: 'خالص منافع',
          valueColor: netProfit >= 0 ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
          isBold: true,
          highlight: true,
        ),
      ],
    );
  }

  Widget _buildLedgerRow({
    required String english,
    required String value,
    required String urdu,
    required Color valueColor,
    bool isBold = false,
    bool highlight = false,
  }) {
    final rowContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Same row for English and Urdu with space between
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                english,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                urdu,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                  color: isBold ? valueColor : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Down details: numbers in big text font size
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: isBold ? 24 : 22,
              fontWeight: FontWeight.w900,
              color: valueColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );

    if (highlight) {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: valueColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: rowContent,
      );
    }

    return rowContent;
  }
}
