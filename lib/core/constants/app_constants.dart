import 'package:flutter/material.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum BillingCycle { weekly, monthly, yearly }

enum SubscriptionCategory {
  entertainment,
  music,
  health,
  productivity,
  storage,
  dev,
  finance,
  other
}

// ─────────────────────────────────────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  static const Map<String, Color> categoryColors = {
    'Entertainment': AppColors.catEntertainment,
    'AI': Color(0xFF06B6D4),
    'Education': Color(0xFF22C55E),
    'Music': AppColors.catMusic,
    'Health': AppColors.catHealth,
    'Productivity': AppColors.catProductivity,
    'Storage': AppColors.catStorage,
    'Dev Tools': AppColors.catDev,
    'Finance': AppColors.catFinance,
    'Other': AppColors.catOther,
  };

  static Color categoryColorFor(String category) {
    return categoryColors[category] ?? AppColors.catOther;
  }

  static final List<SubscriptionDataModel> mockSubscriptions = [
    SubscriptionDataModel(
      id: 1,
      name: 'Netflix',
      price: 15.99,
      billingCycle: 'Monthly',
      category: 'Entertainment',
      startDate: DateTime(2023, 1, 15),
      nextBillingDate: DateTime.now().add(const Duration(days: 3)),
      brandColor:  0xFFE50914,
      notes: 'Family plan - shared with 4 members',
      subscriptionId: '', currency: '',
      categoryColor: 0xFFE50914, autoRenew: false,
      freeTrial: false, reminderDays: 2, createdAt: DateTime.now(), updatedAt: DateTime.now(),
      isSynced: false,
    ),
  ];

  static final List<String> categories = [
    'All',
    'Entertainment',
    'AI',
    'Education',
    'Music',
    'Health',
    'Productivity',
    'Storage',
    'Dev Tools',
    'Finance',
    'Other',
  ];

  static final List<String> currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'PKR', 'CAD', 'AUD', 'INR','PKR'
  ];

  static final List<String> billingCycles = ['Weekly', 'Monthly', 'Yearly'];

  static const List<Map<String, dynamic>> insightCards = [
    {
      'title': 'Unused Subscription',
      'body': "You haven't used Netflix in 30 days",
      'icon': Icons.movie_outlined,
      'color': AppColors.danger,
      'action': 'Review',
    },
    {
      'title': 'Spending Alert',
      'body': 'Your spending increased 12% this month',
      'icon': Icons.trending_up_rounded,
      'color': AppColors.warning,
      'action': 'See Details',
    },
    {
      'title': 'Savings Opportunity',
      'body': 'Cancel unused services to save \$50/year',
      'icon': Icons.savings_outlined,
      'color': AppColors.accent,
      'action': 'Save Now',
    },
    {
      'title': 'Price Increase',
      'body': 'Adobe CC is raising prices by \$5 next month',
      'icon': Icons.info_outline_rounded,
      'color': AppColors.info,
      'action': 'Learn More',
    },
  ];

  static const List<Map<String, dynamic>> premiumFeatures = [
    {
      'icon': Icons.all_inclusive_rounded,
      'title': 'Unlimited Subscriptions',
      'free': false,
      'pro': true,
    },
    {
      'icon': Icons.analytics_rounded,
      'title': 'Advanced Analytics',
      'free': false,
      'pro': true,
    },
    {
      'icon': Icons.cloud_sync_rounded,
      'title': 'Cloud Sync',
      'free': false,
      'pro': true,
    },
    {
      'icon': Icons.picture_as_pdf_rounded,
      'title': 'Export to PDF',
      'free': false,
      'pro': true,
    },
    {
      'icon': Icons.group_rounded,
      'title': 'Family Sharing',
      'free': false,
      'pro': true,
    },
    {
      'icon': Icons.notifications_active_rounded,
      'title': 'Smart Reminders',
      'free': true,
      'pro': true,
    },
    {
      'icon': Icons.track_changes_rounded,
      'title': 'Up to 5 Subscriptions',
      'free': true,
      'pro': true,
    },
  ];
}
