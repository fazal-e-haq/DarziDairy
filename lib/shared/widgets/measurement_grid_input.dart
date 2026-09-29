import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/text_styles.dart';

/// Numeric keypad-friendly grid of measurement inputs with quick fractional decimal selectors (.25, .5, .75)
class MeasurementGridInput extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final ValueChanged<String>? onFieldSelected;

  const MeasurementGridInput({
    super.key,
    required this.controllers,
    this.onFieldSelected,
  });

  @override
  State<MeasurementGridInput> createState() => _MeasurementGridInputState();
}

class _MeasurementGridInputState extends State<MeasurementGridInput> {
  String? _activeField;

  void _applyFraction(double fraction) {
    if (_activeField == null) return;
    final controller = widget.controllers[_activeField];
    if (controller == null) return;

    final currentVal = double.tryParse(controller.text) ?? 0.0;
    final wholePart = currentVal.floorToDouble();
    final newVal = wholePart + fraction;
    controller.text = newVal == newVal.toInt() ? newVal.toInt().toString() : newVal.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final keys = widget.controllers.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Decimal Fraction Selector Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppDimensions.roundedMedium,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.straighten, size: 18, color: AppColors.secondary),
              const SizedBox(width: AppDimensions.space8),
              Text(
                _activeField != null ? 'Quick Add to "$_activeField":' : 'Select field to add fraction:',
                style: const TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _buildFractionChip('.25', () => _applyFraction(0.25)),
              const SizedBox(width: AppDimensions.space4),
              _buildFractionChip('.50', () => _applyFraction(0.50)),
              const SizedBox(width: AppDimensions.space4),
              _buildFractionChip('.75', () => _applyFraction(0.75)),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        // Responsive Measurement Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 80,
            crossAxisSpacing: AppDimensions.space12,
            mainAxisSpacing: AppDimensions.space12,
          ),
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            final controller = widget.controllers[key]!;
            final isActive = _activeField == key;

            return GestureDetector(
              onTap: () {
                setState(() => _activeField = key);
                widget.onFieldSelected?.call(key);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppDimensions.roundedMedium,
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border,
                    width: isActive ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(
                              fontFamily: AppFonts.heading,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: '0.0',
                              hintStyle: TextStyle(
                                fontFamily: AppFonts.heading,
                                color: AppColors.textDisabled,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              setState(() => _activeField = key);
                              widget.onFieldSelected?.call(key);
                            },
                          ),
                        ),
                        const Text(
                          'in',
                          style: TextStyle(
                            fontFamily: AppFonts.body,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFractionChip(String label, VoidCallback onTap) {
    final isEnabled = _activeField != null;
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.body,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isEnabled ? Colors.white : AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}
