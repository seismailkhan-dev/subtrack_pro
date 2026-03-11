import 'package:get/get.dart';
import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_controller.dart';

class InsightsController extends GetxController {
  final DriftService _service = DriftService();
  static InsightsController get to => Get.find();

  final RxList<SubscriptionDataModel> allSubscriptions = <SubscriptionDataModel>[].obs;
  final RxInt spendScore = 72.obs;
  final RxString scoreLabel = "Good — a few improvements possible".obs;
  final RxList<Map<String, dynamic>> dynamicInsights = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    _service.watchSubscriptions().listen((subs) {
      allSubscriptions.assignAll(subs);
      _generateInsights();
      _calculateScore();
      isLoading.value = false;
    });
  }

  void _calculateScore() {
    if (allSubscriptions.isEmpty) {
      spendScore.value = 100;
      scoreLabel.value = "Excellent — no subscriptions found";
      return;
    }

    int score = 100;

    // 1. Subscription Count (-5 for each above 5)
    if (allSubscriptions.length > 5) {
      score -= (allSubscriptions.length - 5) * 5;
    }

    // 2. Category Overlaps (-10 for each overlapping sub)
    final categories = allSubscriptions.map((s) => s.category).toList();
    final uniqueCategories = categories.toSet();
    if (categories.length > uniqueCategories.length) {
      score -= (categories.length - uniqueCategories.length) * 10;
    }

    // 3. Budget Check (-20 if over budget)
    final totalMonthly = allSubscriptions.fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
    final budget = Get.find<AppController>().monthlyBudget.value;
    if (budget > 0 && totalMonthly > budget) {
      score -= 20;
    }

    // 4. Trial Count (-5 for each active trial, encourage review)
    final activeTrials = allSubscriptions.where((s) => s.isTrialActive).length;
    score -= (activeTrials * 5);

    spendScore.value = score.clamp(0, 100);
    
    if (spendScore.value >= 90) scoreLabel.value = "Excellent — your spending is optimized";
    else if (spendScore.value >= 70) scoreLabel.value = "Good — a few improvements possible";
    else if (spendScore.value >= 50) scoreLabel.value = "Fair — consider reviewing your services";
    else scoreLabel.value = "Needs Attention — your score is low";
  }

  void _generateInsights() {
    final List<Map<String, dynamic>> insights = [];

    // 1. Trial Ending Alert
    final trialsEnding = allSubscriptions.where((s) => s.isTrialActive && s.daysUntilRenewal <= 3).toList();
    for (var trial in trialsEnding) {
      insights.add({
        'title': 'Trial Ending',
        'body': '${trial.name} trial ends in ${trial.daysUntilRenewal} days',
        'icon': Icons.timer_outlined,
        'color': AppColors.warning,
        'action': 'Cancel Now',
        'type': 'Alerts',
      });
    }

    // 2. Unused Services (No usage for 30 days OR never used and older than 30 days)
    final unused = allSubscriptions.where((s) {
      final relevantDate = s.lastUsedDate ?? s.startDate;
      return DateTime.now().difference(relevantDate).inDays >= 30;
    }).toList();
    
    for (var sub in unused) {
      insights.add({
        'title': sub.lastUsedDate == null ? 'Never Used' : 'Unused Service',
        'body': sub.lastUsedDate == null 
            ? "You haven't logged any usage for ${sub.name} yet."
            : "You haven't used ${sub.name} in over 30 days.",
        'icon': Icons.visibility_off_outlined,
        'color': AppColors.danger,
        'action': 'Review',
        'type': 'Savings',
      });
    }

    // 3. Category Overlap
    final categoryCounts = <String, int>{};
    for (var sub in allSubscriptions) {
      categoryCounts[sub.category] = (categoryCounts[sub.category] ?? 0) + 1;
    }
    
    categoryCounts.forEach((cat, count) {
      if (count >= 2) {
        insights.add({
          'title': '$cat Overlap',
          'body': 'You have $count $cat subscriptions. Consider consolidating.',
          'icon': Icons.copy_rounded,
          'color': AppColors.info,
          'action': 'Details',
          'type': 'Trends',
        });
      }
    });

    // 4. Over Budget Alert
    final totalMonthly = allSubscriptions.fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
    final budget = Get.find<AppController>().monthlyBudget.value;
    if (budget > 0 && totalMonthly > budget) {
      insights.add({
        'title': 'Over Budget',
        'body': 'You are \$${(totalMonthly - budget).toStringAsFixed(0)} over your monthly limit.',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.danger,
        'action': 'Adjust',
        'type': 'Alerts',
      });
    }

    dynamicInsights.assignAll(insights);
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<Map<String, dynamic>> get filteredInsights {
    if (selectedFilter.value == 'All') return dynamicInsights;
    
    String typeFilter = 'Trends';
    if (selectedFilter.value.contains('Alerts')) typeFilter = 'Alerts';
    if (selectedFilter.value.contains('Savings')) typeFilter = 'Savings';
    if (selectedFilter.value.contains('Trends')) typeFilter = 'Trends';

    return dynamicInsights.where((insight) => insight['type'] == typeFilter).toList();
  }
}
