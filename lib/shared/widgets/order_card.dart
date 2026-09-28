import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/orders/domain/entities/order_entity.dart';

/// Clean, high-contrast workshop card displaying order token, customer,
/// garment, delivery deadline, balance due, and a direct status toggle.
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: BorderSide(
          color: order.isCompleted
              ? AppColors.statusReady.withValues(alpha: 0.3)
              : order.isUrgent
                  ? AppColors.statusError.withValues(alpha: 0.5)
                  : AppColors.border,
          width: order.isUrgent && !order.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Order Token + Urgent Tag + Status Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      order.orderToken,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (order.isUrgent && !order.isCompleted) ...[
                    const SizedBox(width: AppDimensions.space8),
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
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Active / Completed Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.isCompleted
                          ? AppColors.statusReady.withValues(alpha: 0.12)
                          : AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Text(
                      order.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: order.isCompleted ? AppColors.statusReady : AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space12),

              // Customer & Garment Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: order.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                            decoration: order.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              order.customerPhone,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      order.garmentType,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space12),

              const Divider(height: 1, thickness: 1, color: AppColors.border),
              const SizedBox(height: AppDimensions.space10),

              // Bottom Row: Target Date, Balance Due & Quick Action
              Row(
                children: [
                  // Target Delivery Date
                  Icon(
                    Icons.event_outlined,
                    size: 15,
                    color: isOverdue ? AppColors.statusError : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    deadlineText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOverdue ? AppColors.statusError : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),

                  // Balance Due
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        order.isFullyPaid ? 'PAID' : 'Balance Due',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: order.isFullyPaid ? AppColors.statusReady : AppColors.textMuted,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(order.balanceDue),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: order.isFullyPaid ? AppColors.statusReady : AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Quick Action Toggle Button
                  if (onToggleStatus != null) ...[
                    const SizedBox(width: AppDimensions.space12),
                    IconButton(
                      onPressed: onToggleStatus,
                      style: IconButton.styleFrom(
                        backgroundColor: order.isCompleted
                            ? AppColors.statusReady.withValues(alpha: 0.15)
                            : AppColors.secondary.withValues(alpha: 0.12),
                        foregroundColor: order.isCompleted ? AppColors.statusReady : AppColors.secondary,
                        minimumSize: const Size(40, 40),
                      ),
                      icon: Icon(
                        order.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                        size: 22,
                      ),
                      tooltip: order.isCompleted ? 'Mark as Active' : 'Mark as Completed',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
