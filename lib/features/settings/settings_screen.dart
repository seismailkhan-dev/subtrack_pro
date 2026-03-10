import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/controllers/app_controller.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/features/auth/auth_screen.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_toggle_row.dart';
import '../../shared/widgets/app_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _biometric = true;
  String _currency = 'USD';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _ProfileCard(isDark: isDark),
            const SizedBox(height: 24),

            // Appearance
            _SectionLabel(label: 'Appearance'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                AppToggleRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // General
            _SectionLabel(label: 'General'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Currency',
                  subtitle: _currency,
                  onTap: () => _showCurrencyPicker(),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Monthly Budget',
                    subtitle:
                        '\$${AppController.to.monthlyBudget.value.toStringAsFixed(0)}',
                    onTap: () => _showBudgetPicker(),
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: AppController.to.notificationsEnabled.value,
                      onChanged: (v) => AppController.to.toggleNotifications(v),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric Lock',
                  trailing: Switch(
                    value: _biometric,
                    onChanged: (v) => setState(() => _biometric = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Premium
            _SectionLabel(label: 'Premium'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                SettingsTile(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Upgrade to Pro',
                  subtitle: 'Unlock all features',
                  iconColor: AppColors.warning,
                  onTap: () => Navigator.pushNamed(context, '/premium'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data
            _SectionLabel(label: 'Data'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                SettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Backup to Cloud',
                  iconColor: AppColors.info,
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.file_download_outlined,
                  title: 'Export to PDF',
                  iconColor: AppColors.accent,
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.restore_rounded,
                  title: 'Restore Data',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support
            _SectionLabel(label: 'Support'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate the App',
                  iconColor: AppColors.warning,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danger Zone
            _SectionLabel(label: 'Account'),
            _SettingsGroup(
              isDark: isDark,
              children: [
                SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  isDestructive: false,
                  iconColor: AppColors.textSecondaryLight,
                  onTap: () => AppController.to.signOutUser(),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  subtitle: 'This action is irreversible',
                  isDestructive: true,
                  onTap: () => _showDeleteDialog(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // App version
            Center(
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('SubTrack Pro', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 (Build 1)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              Text(
                'Select Currency',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...AppConstants.currencies.map(
                (c) => GestureDetector(
                  onTap: () {
                    setState(() => _currency = c);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Text(c, style: Theme.of(context).textTheme.titleSmall),
                        const Spacer(),
                        if (_currency == c)
                          const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: const Text('Delete Account?'),
        content: const Text(
          'All your data will be permanently deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  void _showBudgetPicker() {
    final controller = TextEditingController(
      text: AppController.to.monthlyBudget.value.toStringAsFixed(0),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SheetHandle(),
                    const SizedBox(height: 8),
                    Text(
                      'Set Monthly Budget',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: controller,
                      label: 'Budget Amount',
                      hint: 'Enter your monthly limit',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money_rounded,
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Save Budget',
                      onTap: () {
                        final amount = double.tryParse(controller.text) ?? 0.0;
                        AppController.to.updateMonthlyBudget(amount);
                        Navigator.pop(context);
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final bool isDark;
  const _ProfileCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final userData = AppController.to.userData.value;
    final isPremium = AppController.to.isPremium.value;
    return GestureDetector(
      onTap: () {
        if (userData == null) {
          Get.offAll(() => AuthScreen());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.primary,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  userData == null
                      ? 'G'
                      : FormatService.getLogoName(userData.name),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData == null ? 'Guest User' : userData.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (userData != null) ...[
                    const Text(
                      'ismail@example.com',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      userData == null
                          ? 'Login/Register'
                          : isPremium
                          ? 'Premium User'
                          : 'Free Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                userData == null
                    ? Icons.arrow_forward_ios
                    : Icons.edit_outlined,
                color: Colors.white70,
                size: 20,
              ),
              onPressed: () {
                if (userData == null) {
                  Get.offAll(() => AuthScreen());
                } else {
                  // will navigate to profile edit
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiaryLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsGroup({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? null : AppShadows.sm,
      ),
      child: Column(children: children),
    );
  }
}
