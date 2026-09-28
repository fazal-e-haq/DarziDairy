import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../features/orders/domain/entities/order_entity.dart';

/// One-tap visual workflow slider/stepper for tailoring jobs.
///
/// Progresses from Pending -> Cutting -> Stitching -> Trial Ready -> Completed -> Delivered.
class StatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;
  final ValueChanged<OrderStatus> onStatusChanged;
  final bool isInteractive;

  const StatusStepper({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
    this.isInteractive = true,
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
    const statuses = OrderStatus.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(statuses.length, (index) {
          final status = statuses[index];
          final isSelected = status == currentStatus;
          final isCompleted = status.index < currentStatus.index;
          final color = _getStatusColor(status);

          return Row(
            children: [
              InkWell(
                onTap: isInteractive ? () => onStatusChanged(status) : null,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : (isCompleted ? color.withValues(alpha: 0.12) : AppColors.surfaceVariant),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                    border: Border.all(
                      color: isSelected ? color : (isCompleted ? color : AppColors.border),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                        size: 14,
                        color: isSelected ? Colors.white : (isCompleted ? color : AppColors.textMuted),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : (isCompleted ? color : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < statuses.length - 1)
                Container(
                  width: 18,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: isCompleted ? color : AppColors.border,
                ),
            ],
          );
        }),
      ),
    );
  }
}
