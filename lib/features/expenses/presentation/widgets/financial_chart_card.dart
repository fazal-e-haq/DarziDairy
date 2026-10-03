import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/expense_entity.dart';

/// Interactive financial analytics chart card using fl_chart.
/// Provides visual comparison of Revenue vs Expenses (Bar Chart) and Category Distribution (Pie Chart).
class FinancialChartCard extends StatefulWidget {
  final List<OrderEntity> allOrders;
  final List<ExpenseEntity> allExpenses;

  const FinancialChartCard({
    super.key,
    required this.allOrders,
    required this.allExpenses,
  });

  @override
  State<FinancialChartCard> createState() => _FinancialChartCardState();
}

class _FinancialChartCardState extends State<FinancialChartCard> {
  int _selectedChartType = 0; // 0 = Bar Chart (Revenue vs Expense), 1 = Pie Chart (Categories)
  int _touchedPieIndex = -1;

  // Category palette
  static const List<Color> _categoryColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF16A34A), // Green
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red
    Color(0xFF7C3AED), // Purple
    Color(0xFF0D9488), // Teal
    Color(0xFFEA580C), // Orange
    Color(0xFF475569), // Slate
    Color(0xFFDB2777), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    final hasData = widget.allOrders.isNotEmpty || widget.allExpenses.isNotEmpty;

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
          // Header Row with Toggle (Wrapped for responsive screens)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 22, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Financial Analytics (چارٹ گراف)',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // Segmented Toggle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleButton(
                      label: 'Comparison',
                      icon: Icons.equalizer_rounded,
                      isSelected: _selectedChartType == 0,
                      onTap: () => setState(() => _selectedChartType = 0),
                    ),
                    _buildToggleButton(
                      label: 'Categories',
                      icon: Icons.pie_chart_outline_rounded,
                      isSelected: _selectedChartType == 1,
                      onTap: () => setState(() => _selectedChartType = 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          if (!hasData)
            _buildEmptyState()
          else if (_selectedChartType == 0)
            _buildBarChartSection()
          else
            _buildPieChartSection(),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.insert_chart_outlined_rounded, size: 36, color: AppColors.textDisabled),
            SizedBox(height: 8),
            Text(
              'No financial records to display',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            SizedBox(height: 2),
            Text(
              'Add orders or expenses to see analytical charts',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Bar Chart: Revenue vs Expenses across the last 4 months
  Widget _buildBarChartSection() {
    final now = DateTime.now();
    // 4 months data
    final months = List.generate(4, (i) {
      return DateTime(now.year, now.month - (3 - i));
    });

    final monthlyData = months.map((m) {
      final rev = widget.allOrders.where((o) {
        return o.bookingDate.year == m.year && o.bookingDate.month == m.month;
      }).fold(0.0, (sum, o) => sum + o.stitchingRate);

      final exp = widget.allExpenses.where((e) {
        return e.date.year == m.year && e.date.month == m.month;
      }).fold(0.0, (sum, e) => sum + e.amount);

      return {'month': m, 'revenue': rev, 'expense': exp};
    }).toList();

    // Determine max Y for scale
    double maxY = 1000;
    for (final item in monthlyData) {
      final r = item['revenue'] as double;
      final e = item['expense'] as double;
      if (r > maxY) maxY = r;
      if (e > maxY) maxY = e;
    }
    maxY = (maxY * 1.25).ceilToDouble();

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(color: const Color(0xFF16A34A), label: 'Revenue (آمدنی)'),
            const SizedBox(width: 18),
            _buildLegendItem(color: const Color(0xFFDC2626), label: 'Expenses (خرچہ)'),
          ],
        ),
        const SizedBox(height: 16),

        // Bar Chart
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF1E293B),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isRev = rodIndex == 0;
                    final title = isRev ? 'Revenue' : 'Expenses';
                    return BarTooltipItem(
                      '$title\n',
                      const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: CurrencyFormatter.format(rod.toY),
                          style: TextStyle(
                            color: isRev ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == maxY) return const SizedBox.shrink();
                      return Text(
                        '${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx >= 0 && idx < monthlyData.length) {
                        final m = monthlyData[idx]['month'] as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormat('MMM').format(m),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4 > 0 ? maxY / 4 : 250,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Color(0xFFF1F5F9),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: monthlyData.asMap().entries.map((entry) {
                final idx = entry.key;
                final r = entry.value['revenue'] as double;
                final e = entry.value['expense'] as double;

                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY: r,
                      color: const Color(0xFF16A34A),
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: e,
                      color: const Color(0xFFDC2626),
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// 2. Pie Chart: Expenses by Category breakdown
  Widget _buildPieChartSection() {
    if (widget.allExpenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No expense categories recorded yet',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      );
    }

    final categoryTotals = <String, double>{};
    for (final e in widget.allExpenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0.0) + e.amount;
    }

    final totalExp = categoryTotals.values.fold(0.0, (s, a) => s + a);
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedPieIndex = -1;
                      return;
                    }
                    _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: sortedCategories.asMap().entries.map((entry) {
                final idx = entry.key;
                final catEntry = entry.value;
                final isTouched = idx == _touchedPieIndex;
                final radius = isTouched ? 48.0 : 40.0;
                final pct = (catEntry.value / totalExp) * 100;
                final color = _categoryColors[idx % _categoryColors.length];

                return PieChartSectionData(
                  color: color,
                  value: catEntry.value,
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Category Legend Badges
        Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: sortedCategories.asMap().entries.map((entry) {
            final idx = entry.key;
            final catEntry = entry.value;
            final color = _categoryColors[idx % _categoryColors.length];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${catEntry.key}: ${CurrencyFormatter.format(catEntry.value)}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
