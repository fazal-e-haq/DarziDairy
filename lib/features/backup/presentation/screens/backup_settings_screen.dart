import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Screen for 1-tap database export/restore and PDF invoice generator
class BackupSettingsScreen extends StatelessWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navBackup),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offline Data Protection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All data is stored 100% locally on your phone. Create regular backups to keep your measurements and orders safe even if you switch devices.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Export Backup to Storage',
              icon: Icons.upload_file,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Restore Backup File',
              variant: ButtonVariant.secondary,
              icon: Icons.download_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
