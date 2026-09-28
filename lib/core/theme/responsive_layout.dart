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

/// A responsive layout orchestrator that seamlessly toggles between
/// compact mobile (single column) and unfolded foldable / tablet (dual pane or multi-column grid).
class ResponsiveLayout extends StatelessWidget {
  /// Primary view rendered on compact mobile devices (< 600dp).
  final Widget mobile;

  /// Expanded view rendered on unfolded foldables and tablets (≥ 600dp).
  /// Falls back to [mobile] if omitted.
  final Widget? unfolded;

  /// Optional custom builder giving access to [BoxConstraints] and [ScreenType].
  final Widget Function(BuildContext context, BoxConstraints constraints, ScreenType screenType)? builder;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.unfolded,
  }) : builder = null;

  /// Builder constructor for programmatic responsive UI branching.
  const ResponsiveLayout.builder({
    super.key,
    required this.builder,
  })  : mobile = const SizedBox.shrink(),
        unfolded = null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = constraints.maxWidth >= AppDimensions.breakpointCompact
            ? ScreenType.unfolded
            : ScreenType.mobile;

        if (builder != null) {
          return builder!(context, constraints, screenType);
        }

        if (screenType == ScreenType.unfolded && unfolded != null) {
          return unfolded!;
        }

        return mobile;
      },
    );
  }
}

/// Dual-pane master-detail container specifically engineered for unfolded devices.
///
/// On mobile, it can display either the [masterPane] or [detailPane].
/// On unfolded screens, it lays out [masterPane] on the left and [detailPane] on the right.
class ResponsiveDualPane extends StatelessWidget {
  /// Left side master list / navigation pane (e.g. Order list or Customer register).
  final Widget masterPane;

  /// Right side detail pane (e.g. Measurement sheet, order workshop stepper, or Roznamcha).
  final Widget detailPane;

  /// Fixed width for the master pane when in unfolded mode. Defaults to 380dp.
  final double masterWidth;

  /// Divider color between panes. Defaults to subtle border.
  final Color? dividerColor;

  /// On mobile: whether to show the detail pane instead of the master pane.
  final bool showDetailOnMobile;

  const ResponsiveDualPane({
    super.key,
    required this.masterPane,
    required this.detailPane,
    this.masterWidth = 380.0,
    this.dividerColor,
    this.showDetailOnMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: showDetailOnMobile ? detailPane : masterPane,
      unfolded: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: masterWidth,
            child: masterPane,
          ),
          VerticalDivider(
            width: 1.0,
            thickness: 1.0,
            color: dividerColor ?? Theme.of(context).dividerColor,
          ),
          Expanded(
            child: detailPane,
          ),
        ],
      ),
    );
  }
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
