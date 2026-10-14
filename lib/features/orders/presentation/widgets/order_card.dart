import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/order_entity.dart';

/// Clean, card-less order card with low opacity order number,
/// big customer name on top, phone number subtitle, plain garment text,
/// and left-right aligned financial and date metrics.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.margin,
  });

  String _formatOrderTitle(String token, int id) {
    final clean = token.replaceAll('#', '').trim();
    if (clean.toLowerCase().startsWith('order')) return clean;
    if (clean.isEmpty) return 'Order $id';
    return 'Order $clean';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.isCompleted;
    final isUrgent = order.isUrgent && !isCompleted;

    return RepaintBoundary(
      child: Padding(
        padding: margin ?? const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFF0FDF4)
                  : (isUrgent ? const Color(0xFFFFF1F1) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFF86EFAC)
                    : (isUrgent ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0)),
                width: isCompleted || isUrgent ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Row: Name on top in big text, and "Order 1" in low opacity on right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (order.customerPhone.isNotEmpty) ...[
                            const SizedBox(height: 1),
                            Text(
                              order.customerPhone,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Order 1 in low opacity with no card or background
                    Text(
                      _formatOrderTitle(order.orderToken, order.id),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Divider between name/number and type
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 5),

                // 2. Type of garment (urgent & completed text removed completely)
                Text(
                  order.garmentType,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),

                // Divider between type and calculations
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 5),

              // 3. Compact metric rows: Total & Advance, Remain & Due Date, Order Date
              _buildMetricPair(
                label1: 'Total',
                value1: CurrencyFormatter.format(order.totalBill),
                label2: 'Advance',
                value2: CurrencyFormatter.format(order.advancePaid),
              ),
              const SizedBox(height: 3),
              _buildMetricPair(
                label1: 'Remain',
                value1: order.isFullyPaid ? 'Rs 0 (PAID)' : CurrencyFormatter.format(order.balanceDue),
                value1Color: order.isFullyPaid ? const Color(0xFF16A34A) : AppColors.primary,
                isBold1: true,
                label2: 'Due Date',
                value2: DateFormatter.formatDate(order.targetDeadline),
              ),
              const SizedBox(height: 3),
              _buildMetricPair(
                label1: 'Order Date',
                value1: DateFormatter.formatDate(order.bookingDate),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildMetricPair({
    required String label1,
    required String value1,
    String? label2,
    String? value2,
    Color? value1Color,
    Color? value2Color,
    bool isBold1 = false,
    bool isBold2 = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.5,
                  fontWeight: isBold1 ? FontWeight.w700 : FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12.5,
                    fontWeight: isBold1 ? FontWeight.w800 : FontWeight.w700,
                    color: value1Color ?? AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label2 != null && value2 != null) ...[
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12.5,
                    fontWeight: isBold2 ? FontWeight.w700 : FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    value2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12.5,
                      fontWeight: isBold2 ? FontWeight.w800 : FontWeight.w700,
                      color: value2Color ?? AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          const Spacer(),
        ],
      ],
    );
  }
}
