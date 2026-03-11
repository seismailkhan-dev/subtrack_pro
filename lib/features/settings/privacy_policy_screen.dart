import 'package:flutter/material.dart';
import 'package:subtrack_pro/core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy',
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
              title: '1. Information We Collect',
              content:
                  'SubTrack Pro collects information you provide directly to us when you create an account, add subscriptions, or communicate with us. This may include your email address, subscription details, and cost information. We do not collect or store your payment credentials.',
              isDark: isDark,
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content:
                  'We use the information we collect to operate and maintain the SubTrack Pro app, provide you with tracking and budget insights, send you notification reminders about upcoming renewals, and improve our services over time.',
              isDark: isDark,
            ),
            _buildSection(
              title: '3. Data Storage and Security',
              content:
                  'Your basic subscription data is stored locally on your device using an embedded database. If you use our cloud sync feature, data is securely encrypted and stored on our servers. Biometric authentication data remains exclusively on your device and is never transmitted.',
              isDark: isDark,
            ),
            _buildSection(
              title: '4. Third-Party Services',
              content:
                  'We may use third-party services for authentication (e.g., Firebase Auth) and analytics. These services have their own privacy policies governing how they use your information.',
              isDark: isDark,
            ),
            _buildSection(
              title: '5. Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at privacy@subtrackpro.example.com.',
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
