import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/orders/domain/entities/order_entity.dart';

/// Modern, clean, and simple workshop order card displaying customer name in big text,
/// tailoring job description, booking date & time, delivery date, and price.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final deadlineText = DateFormatter.formatDeadline(order.targetDeadline);
    final isOverdue = deadlineText.contains('Overdue') && !order.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: order.isCompleted
              ? AppColors.statusReady.withValues(alpha: 0.3)
              : order.isUrgent
                  ? AppColors.statusError.withValues(alpha: 0.4)
                  : AppColors.border,
          width: order.isUrgent && !order.isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Customer Name (BIG text) & Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        order.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: order.isCompleted ? AppColors.textMuted : AppColors.primary,
                          letterSpacing: -0.3,
                          decoration: order.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Text(
                        CurrencyFormatter.format(order.stitchingRate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space10),

                // 2. What Job for Him (e.g. Silai Shalwar Kameez) & Urgent Tag
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.content_cut,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            order.garmentType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (order.isUrgent && !order.isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusError,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt, size: 12, color: Colors.white),
                            SizedBox(width: 2),
                            Text(
                              'URGENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (order.orderToken.isNotEmpty)
                      Text(
                        order.orderToken,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppDimensions.space12),
                const Divider(height: 1, thickness: 1, color: AppColors.surfaceVariant),
                const SizedBox(height: AppDimensions.space12),

                // 3. Booking Date & Time + Delivery Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Booking Date & Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormatter.formatDateTime(order.bookingDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Delivery Date
                          Row(
                            children: [
                              Icon(
                                Icons.event_available_outlined,
                                size: 14,
                                color: isOverdue ? AppColors.statusError : AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Delivery: ${DateFormatter.formatDate(order.targetDeadline)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isOverdue ? AppColors.statusError : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Quick Complete/Active Toggle
                    if (onToggleStatus != null)
                      IconButton(
                        onPressed: onToggleStatus,
                        style: IconButton.styleFrom(
                          backgroundColor: order.isCompleted
                              ? AppColors.statusReady.withValues(alpha: 0.15)
                              : AppColors.surfaceVariant,
                          foregroundColor: order.isCompleted
                              ? AppColors.statusReady
                              : AppColors.textSecondary,
                          minimumSize: const Size(40, 40),
                        ),
                        icon: Icon(
                          order.isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 22,
                        ),
                        tooltip: order.isCompleted ? 'Completed' : 'Mark as Done',
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
