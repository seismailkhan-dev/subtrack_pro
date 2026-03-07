import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';

class AnalyticsController extends GetxController {
  final DriftService _service = DriftService();

  static AnalyticsController get to => Get.find();

  final RxList<SubscriptionDataModel> allSubscriptions = <SubscriptionDataModel>[].obs;
  final RxList<SubscriptionDataModel> expensiveSubscriptions = <SubscriptionDataModel>[].obs;
  
  final RxDouble totalMonthlySpend = 0.0.obs;
  final RxDouble totalYearlySpend = 0.0.obs;
  final RxDouble averagePerSub = 0.0.obs;
  final RxDouble potentialSavings = 42.0.obs; // This could be calculated based on unused subs if tracked
  
  final RxBool isLoading = true.obs;
  final RxInt periodIndex = 0.obs; // 0: Monthly, 1: Yearly
  final RxList<FlSpot> monthlySpendingSpots = <FlSpot>[].obs;
  final RxList<double> currentYearMonthlyTotals = <double>[].obs;
  final RxList<double> previousYearMonthlyTotals = <double>[].obs;
  final RxDouble spendingTrend = 0.0.obs;
  final RxInt activeTrials = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalyticsData(); // Initial fetch handles loading state
    allSubscriptions.bindStream(_service.watchSubscriptions());
    // Update all calculations whenever allSubscriptions changes
    ever(allSubscriptions, (_) {
      _calculateStats();
      _calculateExpensive();
      _calculateMonthlySpending();
      _calculateYearlyComparison();
      _calculateTrend();
    });
  }

  Future<void> fetchAnalyticsData() async {
    // This method is now mostly for the initial loading state
    isLoading(true);
    try {
      final subs = await _service.getSubscriptions();
      allSubscriptions.assignAll(subs);
    } catch (e) {
      print('Error fetching analytics data: $e');
    } finally {
      isLoading(false);
    }
  }

  void _calculateTrend() {
    if (monthlySpendingSpots.length < 2) {
      spendingTrend.value = 0;
      return;
    }
    
    final lastMonth = monthlySpendingSpots.last.y;
    final prevMonth = monthlySpendingSpots[monthlySpendingSpots.length - 2].y;
    
    if (prevMonth == 0) {
      spendingTrend.value = lastMonth > 0 ? 100 : 0;
    } else {
      spendingTrend.value = ((lastMonth - prevMonth) / prevMonth) * 100;
    }
  }

  void setPeriod(int index) {
    periodIndex.value = index;
  }

  void _calculateStats() {
    if (allSubscriptions.isEmpty) {
      totalMonthlySpend.value = 0;
      totalYearlySpend.value = 0;
      averagePerSub.value = 0;
      return;
    }

    double monthly = allSubscriptions.fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
    totalMonthlySpend.value = monthly;
    totalYearlySpend.value = monthly * 12;
    averagePerSub.value = monthly / allSubscriptions.length;
    activeTrials.value = allSubscriptions.where((sub) => sub.isTrialActive).length;
  }

  void _calculateExpensive() {
    final sorted = List<SubscriptionDataModel>.from(allSubscriptions)
      ..sort((a, b) => b.price.compareTo(a.price));
    expensiveSubscriptions.assignAll(sorted.take(3).toList());
  }

  void _calculateMonthlySpending() {
    // Generate last 6 months labels and calculate spending for each
    final List<FlSpot> spots = [];
    final now = DateTime.now();
    
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      double monthlyTotal = 0;
      
      for (var sub in allSubscriptions) {
        // Simple logic: if subscription started on or before this month, it counts
        // In a real app, we'd check if it was active during this month
        if (sub.startDate.isBefore(DateTime(monthDate.year, monthDate.month + 1, 1))) {
          monthlyTotal += sub.monthlyEquivalent;
        }
      }
      spots.add(FlSpot((5 - i).toDouble(), monthlyTotal));
    }
    monthlySpendingSpots.assignAll(spots);
  }

  void _calculateYearlyComparison() {
    final now = DateTime.now();
    final List<double> currentYear = List.filled(12, 0.0);
    final List<double> previousYear = List.filled(12, 0.0);

    for (var sub in allSubscriptions) {
      for (int m = 1; m <= 12; m++) {
        // Current Year
        final currentMonthDate = DateTime(now.year, m, 1);
        if (sub.startDate.isBefore(DateTime(currentMonthDate.year, currentMonthDate.month + 1, 1))) {
           currentYear[m-1] += sub.monthlyEquivalent;
        }

        // Previous Year
        final previousMonthDate = DateTime(now.year - 1, m, 1);
        if (sub.startDate.isBefore(DateTime(previousMonthDate.year, previousMonthDate.month + 1, 1))) {
           previousYear[m-1] += sub.monthlyEquivalent;
        }
      }
    }
    currentYearMonthlyTotals.assignAll(currentYear);
    previousYearMonthlyTotals.assignAll(previousYear);
  }

  // Data for Category Breakdown Donut Chart
  List<PieChartSectionData> getCategorySections(bool isDark) {
    final Map<String, double> categoryTotals = {};
    for (var sub in allSubscriptions) {
      categoryTotals[sub.category] = (categoryTotals[sub.category] ?? 0) + sub.monthlyEquivalent;
    }

    if (categoryTotals.isEmpty) return [];

    final total = totalMonthlySpend.value;
    final List<PieChartSectionData> sections = [];
    
    // Define a map of category colors for consistency if possible, or use random/indexed ones
    // Relying on AppColors categories from analytics_screen.dart logic
    
    categoryTotals.forEach((cat, value) {
      final percentage = (value / total) * 100;
      sections.add(PieChartSectionData(
        value: percentage,
        title: '', // Hide titles on donut for cleaner look as in mock
        radius: 44,
        color: _getCategoryColor(cat),
      ));
    });

    return sections;
  }

  Color _getCategoryColor(String category) {
    // This should ideally be moved to a service or constants, but for now matching the UI
    switch (category.toLowerCase()) {
      case 'entertainment': return const Color(0xFFFF5252);
      case 'music': return const Color(0xFFFF4081);
      case 'health': return const Color(0xFF4CAF50);
      case 'productivity': return const Color(0xFF2196F3);
      case 'storage': return const Color(0xFF9C27B0);
      default: return Colors.grey;
    }
  }

  List<(String, Color, String)> getCategoryLegend() {
    final Map<String, double> categoryTotals = {};
    for (var sub in allSubscriptions) {
      categoryTotals[sub.category] = (categoryTotals[sub.category] ?? 0) + sub.monthlyEquivalent;
    }

    if (categoryTotals.isEmpty) return [];

    final total = totalMonthlySpend.value;
    final List<(String, Color, String)> legend = [];

    categoryTotals.forEach((cat, value) {
      final percentage = (value / total) * 100;
      legend.add((cat, _getCategoryColor(cat), '${percentage.toStringAsFixed(0)}%'));
    });

    return legend;
  }
}
