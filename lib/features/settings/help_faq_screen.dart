import 'package:flutter/material.dart';
import 'package:subtrack_pro/core/theme/app_theme.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildFaqItem(
            context: context,
            isDark: isDark,
            question: 'How do I add a subscription?',
            answer:
                'To add a subscription, tap the "+" icon on the bottom navigation bar. You can choose from popular services or enter a custom one.',
          ),
          _buildFaqItem(
            context: context,
            isDark: isDark,
            question: 'How do I enable biometric authentication?',
            answer:
                'Go to Settings > General > Biometric Lock and toggle the switch. You will be prompted to authenticate with your device PIN or biometrics to enable this security feature.',
          ),
          _buildFaqItem(
            context: context,
            isDark: isDark,
            question: 'Can I export my data?',
            answer:
                'Currently, the export functionality is in development. In a future update, you will be able to export your subscription data as a PDF or CSV file.',
          ),
          _buildFaqItem(
            context: context,
            isDark: isDark,
            question: 'How do notifications work?',
            answer:
                'You can enable notifications in the Settings screen. When enabled, SubTrack Pro will send you reminders before your subscription renewal dates, helping you manage your budget and avoid unwanted auto-renewals.',
          ),
          _buildFaqItem(
            context: context,
            isDark: isDark,
            question: 'What is the Monthly Budget feature?',
            answer:
                'The Monthly Budget feature allows you to set a spending limit for your subscriptions. The Home screen will track your expenses against this budget and show you how much you have left.',
          ),
          const SizedBox(height: 32),
          const Text(
            'Need more help?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'If you need further assistance, please contact our support team at support@subtrackpro.example.com.',
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required BuildContext context,
    required bool isDark,
    required String question,
    required String answer,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: isDark ? null : AppShadows.sm,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                answer,
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
