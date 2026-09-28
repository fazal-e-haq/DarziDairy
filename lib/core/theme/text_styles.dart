import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App-wide typography hierarchy tailored for fast reading in workshop lighting
class AppTextStyles {
  AppTextStyles._();

  // Order Token Monospace Display
  static const TextStyle tokenDisplay = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );

  // Large Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Numeric Keypad Input Style
  static const TextStyle numericInput = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.deepIndigo,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}
