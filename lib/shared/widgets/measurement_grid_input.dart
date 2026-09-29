import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Clean and responsive grid of measurement input fields for tailoring specifications.
class MeasurementGridInput extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const MeasurementGridInput({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final keys = controllers.keys.toList();

    return GridView.builder(
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
        final controller = controllers[key]!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppDimensions.roundedMedium,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.0,
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
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
                        fontFamily: 'Nunito',
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
                          fontFamily: 'Nunito',
                          color: AppColors.textDisabled,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'in',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
