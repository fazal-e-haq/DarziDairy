import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import 'status_chip.dart';

/// High-density workshop card displaying Token ID, Customer Name, Garment,
/// Deadline countdown, Balance due, and rapid status advancement actions.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final VoidCallback? onAdvanceStatus;
  final VoidCallback? onCallCustomer;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onAdvanceStatus,
    this.onCallCustomer,
  });

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.statusPending;
      case OrderStatus.cutting:
        return AppColors.statusCutting;
      case OrderStatus.stitching:
        return AppColors.statusStitching;
      case OrderStatus.trialReady:
        return AppColors.statusTrialReady;
      case OrderStatus.completed:
        return AppColors.statusReady;
      case OrderStatus.delivered:
        return AppColors.statusDelivered;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final deadlineText = DateFormatter.formatDeadline(order.targetDeadline);
    final isOverdue = deadlineText.contains('Overdue');

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.roundedMedium,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Token ID + Urgent Flag + Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: AppDimensions.space4,
                    ),
                    decoration: BoxDecoration(
                      color: order.isUrgent
                          ? AppColors.statusError.withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(
                        color: order.isUrgent ? AppColors.statusError : AppColors.primary,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      order.orderToken,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: order.isUrgent ? AppColors.statusError : AppColors.primary,
                      ),
                    ),
                  ),
                  if (order.isUrgent) ...[
                    const SizedBox(width: AppDimensions.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.statusError,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt, size: 12, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            'URGENT',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  StatusChip(
                    label: order.status.displayName,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space12),

              // Customer Details & Garment Badge
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.customerPhone,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

              const Divider(),
              const SizedBox(height: AppDimensions.space8),

              // Bottom Row: Deadline Countdown & Balance Due
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 15,
                    color: isOverdue ? AppColors.statusError : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    deadlineText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isOverdue ? AppColors.statusError : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
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
                  if (onAdvanceStatus != null && order.status != OrderStatus.delivered) ...[
                    const SizedBox(width: AppDimensions.space12),
                    IconButton.filledTonal(
                      onPressed: onAdvanceStatus,
                      style: IconButton.styleFrom(
                        backgroundColor: statusColor.withValues(alpha: 0.15),
                        foregroundColor: statusColor,
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      tooltip: 'Advance to next stage',
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
