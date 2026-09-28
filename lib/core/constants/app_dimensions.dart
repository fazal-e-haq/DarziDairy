import 'package:flutter/material.dart';

/// Centralized dimensions, responsive breakpoints, and workshop touch targets.
class AppDimensions {
  AppDimensions._();

  // --- Responsive Breakpoints (Material 3 Adaptive Layout) ---
  /// Mobile compact breakpoint: Standard vertical smartphones (< 600dp).
  static const double breakpointCompact = 600.0;

  /// Medium / Unfolded Foldable breakpoint: Dual-pane master-detail screens (600dp - 840dp).
  static const double breakpointMedium = 840.0;

  /// Expanded / Large Tablet / Desktop breakpoint: Multi-column canvas (≥ 840dp).
  static const double breakpointExpanded = 1200.0;

  /// Helper to determine if the display is in compact mobile mode (< 600dp).
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < breakpointCompact;

  /// Helper to determine if the display is an unfolded foldable or tablet (≥ 600dp).
  static bool isUnfolded(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= breakpointCompact;

  // --- Standardized 8-Point Modular Spacing Scale ---
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Aliases for short padding notations
  static const double p4 = space4;
  static const double p8 = space8;
  static const double p12 = space12;
  static const double p16 = space16;
  static const double p20 = space20;
  static const double p24 = space24;
  static const double p32 = space32;

  // Common Edge Insets
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingAll4 = EdgeInsets.all(space4);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(space8);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(space12);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(space16);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(space20);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(space24);

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space12,
  );
  static const EdgeInsets paddingScreenUnfolded = EdgeInsets.symmetric(
    horizontal: space24,
    vertical: space20,
  );

  // --- Card & Surface Border Radii ---
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusCircular = 999.0;

  static const BorderRadius roundedSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius roundedMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius roundedLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius roundedCircular = BorderRadius.all(Radius.circular(radiusCircular));

  // --- Workshop Touch Target Constraints ---
  /// Minimum button height (52dp) allowing rapid, confident taps with fabric chalk dust on hands.
  static const double buttonHeight = 52.0;

  /// Standard input field height (56dp) for spacious numeric keypad entry.
  static const double inputFieldHeight = 56.0;

  /// Universal touch target minimum bounding box.
  static const double minTouchTarget = 52.0;

  // --- Icon Sizes ---
  static const double iconSmall = 18.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}
