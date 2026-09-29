import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
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

    final isCompleted = order.isCompleted;
    final isUrgent = order.isUrgent && !isCompleted;

    // Card styling parameters based on status and urgency
    Color cardBgColor = AppColors.surface;
    Color borderColor = const Color(0xFFE2E8F0);
    double borderWidth = 1.0;
    Color shadowColor = const Color(0x06000000);
    double shadowBlur = 10;
    Color tagBgColor = const Color(0xFFF8FAFC);
    Color tagBorderColor = const Color(0xFFE2E8F0);
    Color dividerColor = const Color(0xFFF1F5F9);

    if (isCompleted) {
      cardBgColor = const Color(0xFFF0FDF4); // Soft subtle green tint
      borderColor = const Color(0xFF86EFAC); // Soft green border
      borderWidth = 1.5;
      shadowColor = const Color(0x1816A34A); // Soft green shadow
      shadowBlur = 12;
      tagBgColor = Colors.white;
      tagBorderColor = const Color(0xFFBBF7D0);
      dividerColor = const Color(0xFFDCFCE7);
    } else if (isUrgent) {
      cardBgColor = const Color(0xFFFFF1F1); // Soft subtle red tint
      borderColor = const Color(0xFFFCA5A5); // Soft red border
      borderWidth = 1.5;
      shadowColor = const Color(0x18DC2626); // Soft red shadow
      shadowBlur = 12;
      tagBgColor = Colors.white;
      tagBorderColor = const Color(0xFFFECACA);
      dividerColor = const Color(0xFFFEE2E2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowBlur,
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
                          fontFamily: 'Nunito',
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
                        fontFamily: 'Nunito',
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
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: tagBorderColor,
                    ),
                  ),
                  child: Text(
                    order.garmentType,
                    style: const TextStyle(
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
                  color: dividerColor,
                ),
                const SizedBox(height: 10),

                // Bottom Row: Booking Date & Time + Delivery / Completed Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Booking Date & Time
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              DateFormatter.formatDateTime(order.bookingDate),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delivery Date / Completed Status
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle_rounded
                                : Icons.event_available_outlined,
                            size: 14,
                            color: isCompleted
                                ? const Color(0xFF16A34A)
                                : (isOverdue
                                    ? const Color(0xFFDC2626)
                                    : AppColors.secondary),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              isCompleted
                                  ? 'Completed: ${DateFormatter.formatDate(order.targetDeadline)}'
                                  : 'Delivery: ${DateFormatter.formatDate(order.targetDeadline)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isCompleted
                                    ? const Color(0xFF15803D)
                                    : (isOverdue
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF1E293B)),
                              ),
                            ),
                          ),
                        ],
                      ),
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
