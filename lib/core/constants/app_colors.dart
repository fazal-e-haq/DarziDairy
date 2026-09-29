import 'package:flutter/material.dart';

/// Production color tokens for Tailor Master Craft & Workshop Theme.
///
/// Designed with high contrast for busy workshop environments and fabric chalk legibility.
class AppColors {
  AppColors._();

  // --- Core Brand Tokens ---
  /// Deep Indigo - Dominant brand color for AppBars, primary actions, and firm structure.
  static const Color primary = Color(0xFF1B365D);
  static const Color deepIndigo = primary;

  /// Measuring Tape Amber - Vibrant accent for urgent delivery flags, pending highlights, and FABs.
  static const Color secondary = Color(0xFFD97706);
  static const Color accent = secondary;
  static const Color amberUrgent = secondary;

  /// Soft Linen - Gentle, non-glare off-white background that eases eye strain in dim shops.
  static const Color background = Color(0xFFF8FAFC);
  static const Color softLinen = background;

  /// Clean White - High clarity surface color for order cards, dialogs, and inputs.
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cleanWhite = surface;
  static const Color pureWhite = surface;

  /// Subtle gray container background for badges, chips, and inactive item fills.
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // --- Workshop Lifecycle Status Pipeline Tokens ---
  /// Order placed, fabric in queue (#E08A00).
  static const Color statusPending = Color(0xFFE08A00);

  /// Fabric marked with chalk and actively being cut (#2563EB).
  static const Color statusCutting = Color(0xFF2563EB);

  /// Machine assembly, collar/pocket stitching in progress (#7C3AED).
  static const Color statusStitching = Color(0xFF7C3AED);

  /// Trial fit prepped or complete, ready for customer pickup (#16A34A).
  static const Color statusReady = Color(0xFF16A34A);
  static const Color statusCompleted = statusReady;
  static const Color statusTrialReady = Color(0xFF7C3AED);

  /// Customer collected garment, full payment reconciled (#475569).
  static const Color statusDelivered = Color(0xFF475569);

  /// Overdue delivery alert, balance deficiency, or destructive action (#DC2626).
  static const Color statusError = Color(0xFFDC2626);
  static const Color urgentRed = statusError;

  // --- Neutral Borders & Dividers ---
  /// Crisp, subtle outline border for cards and unselected inputs.
  static const Color border = Color(0xFFE2E8F0);

  /// Focused input border highlighting active numeric entry.
  static const Color borderFocused = Color(0xFF1B365D);

  /// Hairline separator for Roznamcha transaction lines.
  static const Color divider = Color(0xFFCBD5E1);

  // --- High-Contrast Typography Hierarchy ---
  /// Highest contrast text for Customer Names, Order Numbers (#1), and primary numbers.
  static const Color textPrimary = Color(0xFF0F172A);

  /// Medium contrast text for phone numbers, garment specifications, and measurement labels.
  static const Color textSecondary = Color(0xFF334155);

  /// Subdued text for timestamps, non-critical metadata, and relative dates.
  static const Color textMuted = Color(0xFF64748B);

  /// Inactive placeholders and disabled button text.
  static const Color textDisabled = Color(0xFF94A3B8);
}
