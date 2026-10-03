import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/expense_entity.dart';

/// Handcrafted workshop expense register item tile (روزنامچہ اندراج).
/// Employs tailor-tailored iconography, bespoke color cues for fabric materials/rent,
/// and note previews to avoid generic AI-generated table styling.
class ExpenseListItem extends StatelessWidget {
  final ExpenseEntity item;
  final VoidCallback onDelete;

  const ExpenseListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  /// Category configuration returning icon, foreground color, and background tint.
  static ({IconData icon, Color fg, Color bg}) _getCategoryStyle(String category) {
    if (category.contains('Threads') || category.contains('دھاگہ')) {
      return (
        icon: Icons.linear_scale_rounded,
        fg: const Color(0xFF0D9488), // Teal
        bg: const Color(0xFFCCFBF1),
      );
    } else if (category.contains('Buttons') || category.contains('بٹن')) {
      return (
        icon: Icons.radio_button_checked_rounded,
        fg: const Color(0xFFD97706), // Amber
        bg: const Color(0xFFFEF3C7),
      );
    } else if (category.contains('Bukram') || category.contains('بکرم')) {
      return (
        icon: Icons.layers_rounded,
        fg: const Color(0xFF4F46E5), // Indigo
        bg: const Color(0xFFEEF2FF),
      );
    } else if (category.contains('Needles') || category.contains('سوئی')) {
      return (
        icon: Icons.colorize_rounded,
        fg: const Color(0xFF0891B2), // Cyan
        bg: const Color(0xFFCFFAFE),
      );
    } else if (category.contains('Rent') || category.contains('کرایہ')) {
      return (
        icon: Icons.storefront_rounded,
        fg: const Color(0xFF2563EB), // Blue
        bg: const Color(0xFFDBEAFE),
      );
    } else if (category.contains('Electricity') || category.contains('بجلی')) {
      return (
        icon: Icons.bolt_rounded,
        fg: const Color(0xFFEA580C), // Orange
        bg: const Color(0xFFFFEDD5),
      );
    } else if (category.contains('Tea') || category.contains('چائے')) {
      return (
        icon: Icons.coffee_rounded,
        fg: const Color(0xFFB45309), // Warm Brown
        bg: const Color(0xFFFEF3C7),
      );
    } else if (category.contains('Wages') || category.contains('اجرت')) {
      return (
        icon: Icons.badge_rounded,
        fg: const Color(0xFF7C3AED), // Violet
        bg: const Color(0xFFEDE9FE),
      );
    }

    return (
      icon: Icons.receipt_long_rounded,
      fg: const Color(0xFF475569), // Slate
      bg: const Color(0xFFF1F5F9),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(item.category);
    final hasNote = item.note.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tailor Material / Category Badge
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: style.fg.withValues(alpha: 0.2)),
            ),
            child: Icon(
              style.icon,
              size: 21,
              color: style.fg,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Detail Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title.isNotEmpty ? item.title : item.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: style.fg,
                        ),
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
                    Text(
                      DateFormatter.formatDate(item.date),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                if (hasNote) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.notes_rounded,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Outflow Amount Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '- ${CurrencyFormatter.format(item.amount)}',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Color(0xFFDC2626),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // Delete Action Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
