import 'package:flutter/material.dart';
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

class SubscriptionModel {
  final String id;
  final String name;
  final double price;
  final String currency;
  final BillingCycle cycle;
  final SubscriptionCategory category;
  final DateTime startDate;
  final DateTime nextBilling;
  final bool autoRenew;
  final int reminderDays;
  final String? notes;
  final Color brandColor;
  final String logoLetter;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    this.currency = 'USD',
    required this.cycle,
    required this.category,
    required this.startDate,
    required this.nextBilling,
    this.autoRenew = true,
    this.reminderDays = 3,
    this.notes,
    required this.brandColor,
    required this.logoLetter,
  });

  String get cycleLabel {
    switch (cycle) {
      case BillingCycle.weekly:
        return 'Weekly';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }

  String get categoryLabel {
    switch (category) {
      case SubscriptionCategory.entertainment:
        return 'Entertainment';
      case SubscriptionCategory.music:
        return 'Music';
      case SubscriptionCategory.health:
        return 'Health';
      case SubscriptionCategory.productivity:
        return 'Productivity';
      case SubscriptionCategory.storage:
        return 'Storage';
      case SubscriptionCategory.dev:
        return 'Dev Tools';
      case SubscriptionCategory.finance:
        return 'Finance';
      case SubscriptionCategory.other:
        return 'Other';
    }
  }

  Color get categoryColor {
    switch (category) {
      case SubscriptionCategory.entertainment:
        return AppColors.catEntertainment;
      case SubscriptionCategory.music:
        return AppColors.catMusic;
      case SubscriptionCategory.health:
        return AppColors.catHealth;
      case SubscriptionCategory.productivity:
        return AppColors.catProductivity;
      case SubscriptionCategory.storage:
        return AppColors.catStorage;
      case SubscriptionCategory.dev:
        return AppColors.catDev;
      case SubscriptionCategory.finance:
        return AppColors.catFinance;
      case SubscriptionCategory.other:
        return AppColors.catOther;
    }
  }

  int get daysUntilRenewal {
    return nextBilling.difference(DateTime.now()).inDays;
  }

  double get monthlyEquivalent {
    switch (cycle) {
      case BillingCycle.weekly:
        return price * 4.33;
      case BillingCycle.monthly:
        return price;
      case BillingCycle.yearly:
        return price / 12;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  static final List<SubscriptionModel> mockSubscriptions = [
    SubscriptionModel(
      id: '1',
      name: 'Netflix',
      price: 15.99,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.entertainment,
      startDate: DateTime(2023, 1, 15),
      nextBilling: DateTime.now().add(const Duration(days: 3)),
      brandColor: const Color(0xFFE50914),
      logoLetter: 'N',
      notes: 'Family plan - shared with 4 members',
    ),
    SubscriptionModel(
      id: '2',
      name: 'Spotify',
      price: 9.99,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.music,
      startDate: DateTime(2022, 6, 1),
      nextBilling: DateTime.now().add(const Duration(days: 1)),
      brandColor: const Color(0xFF1DB954),
      logoLetter: 'S',
    ),
    SubscriptionModel(
      id: '3',
      name: 'Gym',
      price: 29.99,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.health,
      startDate: DateTime(2023, 3, 10),
      nextBilling: DateTime.now().add(const Duration(days: 5)),
      brandColor: const Color(0xFFF59E0B),
      logoLetter: 'G',
    ),
    SubscriptionModel(
      id: '4',
      name: 'Adobe CC',
      price: 54.99,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.productivity,
      startDate: DateTime(2022, 11, 20),
      nextBilling: DateTime.now().add(const Duration(days: 8)),
      brandColor: const Color(0xFFFF0000),
      logoLetter: 'A',
      notes: 'All Apps plan',
    ),
    SubscriptionModel(
      id: '5',
      name: 'iCloud',
      price: 2.99,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.storage,
      startDate: DateTime(2021, 9, 5),
      nextBilling: DateTime.now().add(const Duration(days: 12)),
      brandColor: const Color(0xFF007AFF),
      logoLetter: 'i',
    ),
    SubscriptionModel(
      id: '6',
      name: 'GitHub Pro',
      price: 4.00,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.dev,
      startDate: DateTime(2023, 2, 28),
      nextBilling: DateTime.now().add(const Duration(days: 17)),
      brandColor: const Color(0xFF24292E),
      logoLetter: 'G',
    ),
    SubscriptionModel(
      id: '7',
      name: 'Notion',
      price: 8.00,
      cycle: BillingCycle.monthly,
      category: SubscriptionCategory.productivity,
      startDate: DateTime(2023, 4, 12),
      nextBilling: DateTime.now().add(const Duration(days: 22)),
      brandColor: const Color(0xFF000000),
      logoLetter: 'N',
    ),
  ];

  static final List<String> categories = [
    'All',
    'Entertainment',
    'Music',
    'Health',
    'Productivity',
    'Storage',
    'Dev Tools',
    'Finance',
    'Other',
  ];

  static final List<String> currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'PKR', 'CAD', 'AUD', 'INR',
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
