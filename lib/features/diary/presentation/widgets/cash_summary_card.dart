import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/daily_summary.dart';

/// Card showing Net Profit/Loss and Cash-in-hand tiles
class CashSummaryCard extends StatelessWidget {
  final DailySummaryEntity summary;

  const CashSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppDimensions.p16),
      color: AppColors.deepIndigo,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Net Daily Cash Flow',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(summary.netCash),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.p16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Cash In', summary.totalCashIn, Colors.greenAccent),
                _buildStatItem('Cash Out', summary.totalCashOut, Colors.amberAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
