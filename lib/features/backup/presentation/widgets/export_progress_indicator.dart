import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Progress and status indicator during backup export/restore
class ExportProgressIndicator extends StatelessWidget {
  final String statusText;
  final bool isIndeterminate;

  const ExportProgressIndicator({
    super.key,
    required this.statusText,
    this.isIndeterminate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: AppDimensions.roundedMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.deepIndigo,
            ),
          ),
          const SizedBox(width: AppDimensions.p16),
          Expanded(
            child: Text(
              statusText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
