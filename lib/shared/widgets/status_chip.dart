import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

/// Color-coded workflow chips (Cutting, Stitching, Trial Ready, Completed, Delivered)
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.p12,
          vertical: AppDimensions.p4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isSelected ? 0.25 : 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          border: Border.all(
            color: color,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
