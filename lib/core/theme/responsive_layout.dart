import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Form-factor classifications for Tailor Master responsive viewport adaptation.
enum ScreenType {
  /// Standard compact mobile phones (< 600dp width)
  mobile,

  /// Unfolded foldables (Galaxy Z Fold, Pixel Fold) and Tablets (≥ 600dp width)
  unfolded;

  bool get isMobile => this == ScreenType.mobile;
  bool get isUnfolded => this == ScreenType.unfolded;
}


/// Extension on [BuildContext] for ergonomic, high-performance responsive queries.
extension ResponsiveContextExtensions on BuildContext {
  /// Screen width derived from the active MediaQuery.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height derived from the active MediaQuery.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Active [ScreenType] (mobile vs unfolded).
  ScreenType get screenType => screenWidth >= AppDimensions.breakpointCompact
      ? ScreenType.unfolded
      : ScreenType.mobile;

  /// True if the current device window is a compact mobile (< 600dp).
  bool get isMobile => screenWidth < AppDimensions.breakpointCompact;

  /// True if the current device window is unfolded or a tablet (≥ 600dp).
  bool get isUnfolded => screenWidth >= AppDimensions.breakpointCompact;

  /// Dynamic horizontal padding scale: 16dp on mobile, 24dp on unfolded.
  EdgeInsets get responsiveScreenPadding => isUnfolded
      ? AppDimensions.paddingScreenUnfolded
      : AppDimensions.paddingScreen;

  /// Cross axis count for grids (e.g., 2 columns on mobile, 4 columns on unfolded).
  int get responsiveMeasurementColumns => isUnfolded ? 4 : 2;
}
