import 'package:flutter/material.dart';
import 'package:subtrack_pro/core/theme/app_theme.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: October 2026',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Acceptance of Terms',
              content:
                  'By downloading, accessing, or using SubTrack Pro, you agree to be bound by these Terms & Conditions. If you disagree with any part of these terms, you may not use our service.',
              isDark: isDark,
            ),
            _buildSection(
              title: '2. Description of Service',
              content:
                  'SubTrack Pro is a personal finance tool designed to help users track their recurring subscriptions and manage their digital expenses. The accuracy of the tracking relies on the data provided by the user.',
              isDark: isDark,
            ),
            _buildSection(
              title: '3. User Responsibilities',
              content:
                  'You are responsible for maintaining the confidentiality of your account credentials and biometrics. You agree to provide accurate, current, and complete information when adding subscriptions to the app.',
              isDark: isDark,
            ),
            _buildSection(
              title: '4. Premium Subscription',
              content:
                  'Certain features may require a Premium subscription. Premium fees are billed in advance on a recurring basis as determined by your selection. All payments are non-refundable unless required by applicable law.',
              isDark: isDark,
            ),
            _buildSection(
              title: '5. Limitation of Liability',
              content:
                  'SubTrack Pro shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service. We do not guarantee that the app will prevent you from being charged for services you forgot to cancel.',
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'If you have any questions about these Terms, please contact us at legal@subtrackpro.example.com.',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
