import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';
import '../providers/expense_provider.dart';
import '../../utils/monthly_report_pdf_generator.dart';

/// Clean, card-less widget to select a month and download/print the monthly PDF report.
class MonthlyReportCard extends StatefulWidget {
  const MonthlyReportCard({super.key});

  @override
  State<MonthlyReportCard> createState() => _MonthlyReportCardState();
}

class _MonthlyReportCardState extends State<MonthlyReportCard> {
  late DateTime _selectedMonth;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  /// Generates a list of the last 12 months for easy selection
  List<DateTime> _getAvailableMonths() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      return DateTime(now.year, now.month - index);
    });
  }

  Future<void> _handleDownload() async {
    final messenger = ScaffoldMessenger.of(context);
    final orders = context.read<OrderListProvider>().allOrders;
    final expenses = context.read<ExpenseProvider>().expenses;

    setState(() => _isGenerating = true);
    try {
      await MonthlyReportPdfGenerator.printOrDownloadReport(
        year: _selectedMonth.year,
        month: _selectedMonth.month,
        allOrders: orders,
        allExpenses: expenses,
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.statusError,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMonths = _getAvailableMonths();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header without subtitle: English on left, Urdu on right
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.picture_as_pdf_rounded, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Monthly Report',
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
              'ماہانہ رپورٹ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Full-width Month Selection Dropdown (0 order and 0 expense badge removed)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DateTime>(
              value: _selectedMonth,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
              items: availableMonths.map((m) {
                final label = DateFormat('MMMM yyyy').format(m);
                return DropdownMenuItem<DateTime>(
                  value: m,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newMonth) {
                if (newMonth != null) {
                  setState(() => _selectedMonth = newMonth);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Download Action Button: purely English, no Urdu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isGenerating ? null : _handleDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
            ),
            icon: _isGenerating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.download_rounded, size: 18),
            label: Text(
              _isGenerating ? 'Generating...' : 'Download PDF',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
