import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _periodIndex = 0; // Monthly / Yearly

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subs = AppConstants.mockSubscriptions;
    final totalMonthly = 234;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Toggle
            AppSegmentedControl(
              options: const ['Monthly', 'Yearly'],
              selectedIndex: _periodIndex,
              onChanged: (i) => setState(() => _periodIndex = i),
            ),
            const SizedBox(height: 20),

            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total Spend',
                    value: '\$${(_periodIndex == 0 ? totalMonthly : totalMonthly * 12).toStringAsFixed(2)}',
                    subtitle: _periodIndex == 0 ? 'this month' : 'this year',
                    icon: Icons.account_balance_wallet_outlined,
                    isGradient: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Subscriptions',
                    value: '${subs.length}',
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
                    value: '\$${(totalMonthly / subs.length).toStringAsFixed(2)}',
                    subtitle: 'per month',
                    icon: Icons.calculate_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Potential Savings',
                    value: '\$42',
                    subtitle: 'cancel unused',
                    icon: Icons.savings_outlined,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
              chart: SizedBox(height: 160, child: _CategoryDonut()),
            ),
            const SizedBox(height: 16),

            // Most Expensive
            Text('Most Expensive', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            // ...subs
            //     .sorted((a, b) => double.tryParse(b?.price??'').compareTo(a.price))
            //     .take(3)
            //     .map((sub) => _ExpensiveRow(sub: sub, isDark: isDark)),
            const SizedBox(height: 16),

            // Savings Insight Card
            _SavingsCard(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

extension _SortExt<T> on List<T> {
  List<T> sorted(int Function(T, T) compare) => [...this]..sort(compare);
}

class _TrendChip extends StatelessWidget {
  const _TrendChip();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.trending_up_rounded, color: AppColors.danger, size: 13),
        SizedBox(width: 4),
        Text('+12%', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MonthlyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spots = [
      const FlSpot(0, 98),
      const FlSpot(1, 112),
      const FlSpot(2, 105),
      const FlSpot(3, 125),
      const FlSpot(4, 118),
      const FlSpot(5, 126),
    ];
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
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
                style: const TextStyle(fontSize: 9, color: AppColors.textTertiaryLight)),
          ),
        ),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              const months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(months[v.toInt()],
                    style: const TextStyle(fontSize: 10, color: AppColors.textTertiaryLight)),
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
            checkToShowDot: (s, _) => s.x == 5,
            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
              radius: 5, color: AppColors.primary, strokeColor: Colors.white, strokeWidth: 2,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.15), AppColors.primary.withOpacity(0)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      minX: 0, maxX: 5, minY: 80, maxY: 140,
    ));
  }
}

class _YearlyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    const v24 = [95.0, 98.0, 102.0, 99.0, 105.0, 108.0, 110.0, 108.0, 112.0, 115.0, 118.0, 120.0];
    const v25 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 115.0, 120.0, 124.0, 125.0, 126.0];

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
                style: const TextStyle(fontSize: 9, color: AppColors.textTertiaryLight)),
          ),
        ),
      ),
      barGroups: List.generate(12, (i) => BarChartGroupData(
        x: i,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
            toY: v24[i], width: 6,
            color: isDark ? AppColors.primary.withOpacity(0.35) : AppColors.primary.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: v25[i], width: 6,
            color: AppColors.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        ],
      )),
      maxY: 150,
    ));
  }
}

class _CategoryDonut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(value: 30, color: AppColors.catEntertainment, title: '', radius: 44),
      PieChartSectionData(value: 15, color: AppColors.catMusic, title: '', radius: 44),
      PieChartSectionData(value: 25, color: AppColors.catHealth, title: '', radius: 44),
      PieChartSectionData(value: 20, color: AppColors.catProductivity, title: '', radius: 44),
      PieChartSectionData(value: 10, color: AppColors.catStorage, title: '', radius: 44),
    ];
    final legend = [
      ('Entertainment', AppColors.catEntertainment, '30%'),
      ('Music', AppColors.catMusic, '15%'),
      ('Health', AppColors.catHealth, '25%'),
      ('Productivity', AppColors.catProductivity, '20%'),
      ('Storage', AppColors.catStorage, '10%'),
    ];

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
            children: legend.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: l.$2, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 8),
                Expanded(child: Text(l.$1, style: const TextStyle(fontSize: 12))),
                Text(l.$3, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            )).toList(),
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
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Color(sub.brandColor).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(FormatService.getLogoName(sub.name), style: TextStyle(color: Color(sub.brandColor), fontWeight: FontWeight.w800, fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(sub.name, style: theme.textTheme.titleSmall)),
          Text('\$${sub.price.toStringAsFixed(2)}/mo',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
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
          const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Potential Savings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                SizedBox(height: 4),
                Text('Cancel Netflix & Gym to save \$45.98/month', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: const Text('Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
