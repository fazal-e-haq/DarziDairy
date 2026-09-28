import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

enum ButtonVariant { primary, secondary, destructive }

/// Common action button supporting primary, secondary, and destructive variants
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.deepIndigo;
        foregroundColor = AppColors.pureWhite;
        break;
      case ButtonVariant.secondary:
        backgroundColor = AppColors.amberUrgent;
        foregroundColor = AppColors.pureWhite;
        break;
      case ButtonVariant.destructive:
        backgroundColor = AppColors.urgentRed;
        foregroundColor = AppColors.pureWhite;
        break;
    }

    return SizedBox(
      height: AppDimensions.minTouchTarget,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.roundedMedium,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppDimensions.iconSmall),
                    const SizedBox(width: AppDimensions.p8),
                  ],
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}
