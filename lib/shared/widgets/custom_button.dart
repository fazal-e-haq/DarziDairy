import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

enum ButtonVariant { primary, secondary, destructive }

/// Common action button supporting primary, secondary, and destructive variants
class CustomButton extends StatelessWidget {
  final String? label;
  final String? text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.label,
    this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  }) : assert(label != null || text != null, 'Either label or text must be provided');

  String get _buttonText => text ?? label ?? '';

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.surface;
        break;
      case ButtonVariant.secondary:
        backgroundColor = AppColors.secondary;
        foregroundColor = AppColors.surface;
        break;
      case ButtonVariant.destructive:
        backgroundColor = AppColors.statusError;
        foregroundColor = AppColors.surface;
        break;
    }

    return SizedBox(
      height: AppDimensions.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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
                    Icon(icon, size: 20),
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  Flexible(
                    child: Text(
                      _buttonText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
