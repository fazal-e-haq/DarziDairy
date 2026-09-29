import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Font family constants for Tailor Master
class AppFonts {
  AppFonts._();

  /// Primary font for large text, headings, names, and titles
  static const String heading = 'Nunito';

  /// Primary font for body text, subtitles, inputs, captions, and smaller UI elements
  static const String body = 'Poppins';
}

/// App-wide typography hierarchy tailored for fast reading in workshop lighting
class AppTextStyles {
  AppTextStyles._();

  // Order Token Monospace/Heading Display
  static const TextStyle tokenDisplay = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );

  // Large Headlines (Nunito)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Body Styles (Poppins)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Numeric Keypad / Price Style (Nunito for strong legibility)
  static const TextStyle numericInput = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.deepIndigo,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}
