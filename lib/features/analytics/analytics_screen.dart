import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import '../../controllers/analytics_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../controllers/app_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Toggle
              AppSegmentedControl(
                options: const ['Monthly', 'Yearly'],
                selectedIndex: controller.periodIndex.value,
                onChanged: (i) => controller.setPeriod(i),
              ),
              const SizedBox(height: 20),

              // Top Stats Row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Total Spend',
                      value:
                          '\$${(controller.periodIndex.value == 0 ? controller.totalMonthlySpend.value : controller.totalYearlySpend.value).toStringAsFixed(2)}',
                      subtitle: controller.periodIndex.value == 0
                          ? 'this month'
                          : 'this year',
                      icon: Icons.account_balance_wallet_outlined,
                      isGradient: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Subscriptions',
                      value: '${controller.allSubscriptions.length}',
                      subtitle: 'active',
                      icon: Icons.apps_rounded,
                      color: AppColors.accent,
                      isGradient: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Avg / Sub',
                      value:
                          '\$${controller.averagePerSub.value.toStringAsFixed(2)}',
                      subtitle: 'per month',
                      icon: Icons.calculate_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Potential Savings',
                      value:
                          '\$${controller.potentialSavings.value.toStringAsFixed(0)}',
                      subtitle: 'cancel unused',
                      icon: Icons.savings_outlined,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Budget Progress Card
              if (AppController.to.monthlyBudget.value > 0) ...[
                _BudgetProgressCard(
                  totalSpend: controller.totalMonthlySpend.value,
                  budget: AppController.to.monthlyBudget.value,
                ),
                const SizedBox(height: 24),
              ],

              // Monthly Spend Chart
              ChartContainer(
                title: 'Monthly Spending',
                subtitle: 'Last 6 months',
                trailing: const _TrendChip(),
                chart: SizedBox(height: 140, child: _MonthlyLineChart()),
              ),
              const SizedBox(height: 16),

              // Yearly Comparison
              ChartContainer(
                title: 'Yearly Comparison',
                subtitle: '2024 vs 2025',
                chart: SizedBox(height: 140, child: _YearlyBarChart()),
              ),
              const SizedBox(height: 16),

              // Category Donut
              ChartContainer(
                title: 'Category Breakdown',
                chart: SizedBox(
                    height: 160, child: _CategoryDonut(controller: controller)),
              ),
              const SizedBox(height: 16),

              // Most Expensive
              if (controller.expensiveSubscriptions.isNotEmpty) ...[
                Text('Most Expensive', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                ...controller.expensiveSubscriptions
                    .map((sub) => _ExpensiveRow(sub: sub, isDark: isDark)),
                const SizedBox(height: 16),
              ],

              // Savings Insight Card
              _SavingsCard(isDark: isDark),
            ],
          ),
        );
      }),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();
    return Obx(() {
      final trend = controller.spendingTrend.value;
      final isUp = trend > 0;
      final color = isUp ? AppColors.danger : AppColors.accent;
      final text = '${isUp ? '+' : ''}${trend.toStringAsFixed(1)}%';
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded, 
              color: color, size: 13),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ]),
      );
    });
  }
}

class _MonthlyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AnalyticsController>();
    
    return Obx(() {
      final spots = controller.monthlySpendingSpots;
      if (spots.isEmpty) return const Center(child: Text('No data'));

      // Calculate max Y for better scaling
      double maxY = spots.fold(0.0, (max, spot) => spot.y > max ? spot.y : max);
      maxY = maxY == 0 ? 100 : maxY * 1.2;

      return LineChart(LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (_) => FlLine(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, _) => Text('\$${v.toInt()}',
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textTertiaryLight)),
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final now = DateTime.now();
                final months = List.generate(6, (i) {
                  final date = DateTime(now.year, now.month - (5 - i), 1);
                  return FormatService.formatMMMM(date).substring(0, 3);
                });
                if (v.toInt() < 0 || v.toInt() >= months.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(months[v.toInt()],
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textTertiaryLight)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (s, _) => s.x == spots.length - 1,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 5,
                color: AppColors.primary,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: maxY,
      ));
    });
  }
}

class _YearlyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AnalyticsController>();
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

    return Obx(() {
      final v24 = controller.previousYearMonthlyTotals;
      final v25 = controller.currentYearMonthlyTotals;

      if (v24.isEmpty || v25.isEmpty) return const Center(child: Text('No data'));

      // Calculate Max Y
      double maxY = 0;
      for (var v in v24) if (v > maxY) maxY = v;
      for (var v in v25) if (v > maxY) maxY = v;
      maxY = maxY == 0 ? 100 : maxY * 1.2;

      return BarChart(BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(months[v.toInt()],
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textTertiaryLight)),
            ),
          ),
        ),
        barGroups: List.generate(
            12,
            (i) => BarChartGroupData(
                  x: i,
                  barsSpace: 2,
                  barRods: [
                    BarChartRodData(
                      toY: v24[i],
                      width: 6,
                      color: isDark
                          ? AppColors.primary.withOpacity(0.35)
                          : AppColors.primary.withOpacity(0.25),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                    BarChartRodData(
                      toY: v25[i],
                      width: 6,
                      color: AppColors.primary,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ],
                )),
        maxY: maxY,
      ));
    });
  }
}

class _CategoryDonut extends StatelessWidget {
  final AnalyticsController controller;
  const _CategoryDonut({required this.controller});

  @override
  Widget build(BuildContext context) {
    final sections = controller.getCategorySections(false);
    final legend = controller.getCategoryLegend();

    if (sections.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return Row(
      children: [
        SizedBox(
          width: 150,
          child: PieChart(PieChartData(
            sections: sections,
            centerSpaceRadius: 38,
            sectionsSpace: 2,
          )),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: legend
                .map((l) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: l.$2,
                                borderRadius: BorderRadius.circular(3))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(l.$1,
                                style: const TextStyle(fontSize: 12))),
                        Text(l.$3,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ExpensiveRow extends StatelessWidget {
  final SubscriptionDataModel sub;
  final bool isDark;
  const _ExpensiveRow({required this.sub, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Color(sub.brandColor).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(FormatService.getLogoName(sub.name),
                    style: TextStyle(
                        color: Color(sub.brandColor),
                        fontWeight: FontWeight.w800,
                        fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(sub.name, style: theme.textTheme.titleSmall)),
          Text('\$${sub.price.toStringAsFixed(2)}/mo',
              style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  final bool isDark;
  const _SavingsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.accent,
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Potential Savings',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 4),
                Text('Cancel subscriptions you don\'t use to save money.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: const Text('Review',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _BudgetProgressCard extends StatelessWidget {
  final double totalSpend;
  final double budget;

  const _BudgetProgressCard({
    required this.totalSpend,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (totalSpend / budget).clamp(0.0, 1.0);
    final isOverBudget = totalSpend > budget;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isOverBudget ? AppColors.danger.withOpacity(0.5) : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isOverBudget ? 2 : 1,
        ),
        boxShadow: isDark ? null : AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Budget', style: theme.textTheme.titleMedium),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isOverBudget ? AppColors.danger : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? AppColors.danger : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${totalSpend.toStringAsFixed(2)} spent / \$${budget.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall,
              ),
              if (isOverBudget)
                 Text(
                  'Over by \$${(totalSpend - budget).toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w600),
                )
              else
                Text(
                  '\$${(budget - totalSpend).toStringAsFixed(2)} left',
                  style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
