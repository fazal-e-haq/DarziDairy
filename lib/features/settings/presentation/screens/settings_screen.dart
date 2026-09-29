import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

/// Clean, modern settings screen tailored for tailoring workshop management.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isUnfolded = context.isUnfolded;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: AppFonts.heading,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isUnfolded ? 28 : 16,
              vertical: 20,
            ),
            children: [
              // Section 1: Workshop Profile
              _buildSectionHeader('Workshop Profile'),
              _buildCardGroup([
                _buildSettingsTile(
                  icon: Icons.storefront_rounded,
                  title: 'Shop Name',
                  subtitle: 'Darzi Dairy Workshop',
                  onTap: () => _showComingSoon(context, 'Shop profile editing'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.phone_outlined,
                  title: 'Master Tailor Phone',
                  subtitle: '+92 300 1234567',
                  onTap: () => _showComingSoon(context, 'Phone number update'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Workshop Location',
                  subtitle: 'Main Bazar, Tailors Market',
                  onTap: () => _showComingSoon(context, 'Location settings'),
                ),
              ]),

              const SizedBox(height: 24),

              // Section 2: Tailoring Preferences
              _buildSectionHeader('Preferences'),
              _buildCardGroup([
                _buildSettingsTile(
                  icon: Icons.currency_exchange_rounded,
                  title: 'Currency Symbol',
                  subtitle: 'Rs (Pakistani Rupee)',
                  trailing: const Text(
                    'Rs',
                    style: TextStyle(
                      fontFamily: AppFonts.heading,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.straighten_rounded,
                  title: 'Measurement Unit',
                  subtitle: 'Inches (In)',
                  trailing: const Text(
                    'Inches',
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.flash_on_outlined,
                  title: 'Default Urgent Surcharge',
                  subtitle: 'Rs 500 per urgent garment',
                  onTap: () => _showComingSoon(context, 'Urgent rate configuration'),
                ),
              ]),

              const SizedBox(height: 24),

              // Section 3: Data Management & Backup
              _buildSectionHeader('Data & Backup'),
              _buildCardGroup([
                _buildSettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Backup Workshop Data',
                  subtitle: 'Save a local backup of all orders and customers',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Workshop backup saved successfully to local device storage.',
                          style: TextStyle(fontFamily: AppFonts.body),
                        ),
                        backgroundColor: Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.cloud_download_outlined,
                  title: 'Restore Workshop Data',
                  subtitle: 'Restore previous database backup file',
                  onTap: () => _showComingSoon(context, 'Data restore'),
                ),
              ]),

              const SizedBox(height: 24),

              // Section 4: App Information
              _buildSectionHeader('About'),
              _buildCardGroup([
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: 'Darzi Dairy v1.0.0 (Production Release)',
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Privacy & Storage',
                  subtitle: '100% Offline & Private on this device',
                ),
              ]),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: AppFonts.heading,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: AppFonts.body,
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      color: Color(0xFFF1F5F9),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature can be configured in workshop settings.',
          style: const TextStyle(fontFamily: AppFonts.body),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
