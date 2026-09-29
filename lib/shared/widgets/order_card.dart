import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/orders/domain/entities/order_entity.dart';

/// Senior-designed, minimalist order card with zero inner buttons.
/// The entire card is a single clean touch target that navigates to order details.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deadlineText = DateFormatter.formatDeadline(order.targetDeadline);
    final isOverdue = deadlineText.contains('Overdue') && !order.isCompleted;

    final isUrgent = order.isUrgent;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFFF1F1) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: isUrgent
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
          width: isUrgent ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isUrgent
                ? const Color(0x18DC2626)
                : const Color(0x06000000),
            blurRadius: isUrgent ? 12 : 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Big Customer Name + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Big Customer Name
                    Expanded(
                      child: Text(
                        order.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Price (Right-aligned, prominent, elegant)
                    Text(
                      CurrencyFormatter.format(order.stitchingRate),
                      style: const TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Middle: Type of Cutting / Job (Neutral, NO COLOR added)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUrgent ? Colors.white : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isUrgent ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    order.garmentType,
                    style: const TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isUrgent ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                ),
                const SizedBox(height: 10),

                // Bottom Row: Booking Date & Time + Delivery Date
                Row(
                  children: [
                    // Booking Date & Time
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatDateTime(order.bookingDate),
                          style: const TextStyle(
                            fontFamily: AppFonts.body,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Delivery Date
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_available_outlined,
                          size: 14,
                          color: isOverdue
                              ? const Color(0xFFDC2626)
                              : AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Delivery: ${DateFormatter.formatDate(order.targetDeadline)}',
                          style: TextStyle(
                            fontFamily: AppFonts.body,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isOverdue
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
