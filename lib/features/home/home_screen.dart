import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:subtrack_pro/features/subscription_detail/subscription_detail_screen.dart';
import 'package:subtrack_pro/shared/widgets/custom_loader.dart';
import '../../controllers/analytics_controller.dart';
import '../../controllers/get_subscription_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_router.dart';
import '../../shared/widgets/app_widgets.dart';
import '../all_subscription/all_subscriptions_screen.dart';
import '../analytics/analytics_screen.dart';
import '../calendar/calendar_screen.dart';
import '../insights/insights_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final getSubController = Get.put(GetSubscriptionsController());
  final analyticsController = Get.put(AnalyticsController());

  @override
  void initState() {
    super.initState();
    getSubController.fetchSubscriptions();
    analyticsController.fetchAnalyticsData();
  }

  int _tabIndex = 0;

  final _screens = [
    null, // Home (this)
    const AnalyticsScreen(),
    const CalendarScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_tabIndex != 0) {
      return Scaffold(
        body: _screens[_tabIndex],
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
        ),
        floatingActionButton: _tabIndex == 0 ? _fab() : null,
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _HomeDashboard(
        onAddSub: () =>
            Navigator.pushNamed(context, AppRoutes.addSubscription).then((_) {
          setState(() {});
        }),
        onSubTap: (sub) =>
            Get.to((SubscriptionDetailScreen(subscription: sub))),
        onSubDelete: (sub) async {
          if (sub.id != null) {
            // Optimistic UI update
            getSubController.homeSubListModel.removeWhere((s) => s.id == sub.id);
            getSubController.upcomingSubListModel.removeWhere((s) => s.id == sub.id);
            
            try {
              await getSubController.deleteSubscription(sub.id!);
            } catch (e) {
              // Revert on error
              getSubController.fetchSubscriptions();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete subscription')),
                );
              }
            }
          }
        },
      ),
      floatingActionButton: _fab(),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.addSubscription),
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  final VoidCallback onAddSub;
  final void Function(SubscriptionDataModel) onSubTap;
  final void Function(SubscriptionDataModel) onSubDelete;

  const _HomeDashboard({
    required this.onAddSub,
    required this.onSubTap,
    required this.onSubDelete,
  });

  @override
  Widget build(BuildContext context) {
    final getSubController = Get.find<GetSubscriptionsController>();

    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 0,
          pinned: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Ismail 👋',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('I',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // ── Spend Cards ──────────────────────────────────────────
              const _SpendCard(),
              const SizedBox(height: 28),

              // ── Upcoming Renewals ─────────────────────────────────────
              Obx(() {
                if (getSubController.upcomingSubListModel.isNotEmpty) {
                  return Column(
                    children: [
                      SectionHeader(
                        title: 'Upcoming Renewals',
                        action: '',
                        onAction: () {},
                      ),
                      const SizedBox(height: 14),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: getSubController.upcomingSubListModel.length,
                        itemBuilder: (ctx, index) {
                          final sub =
                              getSubController.upcomingSubListModel[index];
                          return SubscriptionCard(
                            subscription: sub,
                            onTap: () => onSubTap(sub),
                            onDelete: () => onSubDelete(sub),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // ── All Subscriptions ─────────────────────────────────────
              SectionHeader(
                title: 'Recent Subscriptions',
                action: 'View All',
                onAction: () {
                  Get.to(() => AllSubscriptionsScreen());
                },
              ),
              const SizedBox(height: 14),
              Obx(() {
                if (getSubController.isFetchingHomeSub.value) {
                  return customLoader();
                } else if (getSubController.homeSubListModel.isEmpty) {
                  return Center(child: Text('Not Found'));
                } else {
                  // ✅ Return the ListView
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: getSubController.homeSubListModel.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return SubscriptionCard(
                        subscription: getSubController.homeSubListModel[index],
                        onTap: () => onSubTap(
                            getSubController.homeSubListModel[index]),
                        onDelete: () => onSubDelete(
                            getSubController.homeSubListModel[index]),
                      );
                    },
                  );
                }
              }),
              const SizedBox(height: 28),

              // ── Spending Trend ─────────────────────────────────────────
              ChartContainer(
                title: 'Spending Trend',
                subtitle: 'Last 6 months',
                trailing: const _TrendBadge(),
                chart: SizedBox(height: 120, child: _LineChart()),
              ),

              const SizedBox(height: 16),

              // ── Category Breakdown ─────────────────────────────────────
              ChartContainer(
                title: 'Category Breakdown',
                chart: SizedBox(height: 150, child: _DonutChart()),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning,';
    if (h < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}

class _SpendCard extends StatelessWidget {
  const _SpendCard();

  @override
  Widget build(BuildContext context) {
    final subsController = GetSubscriptionsController.to;

    return Obx(() {
      final monthly = subsController.totalMonthlySpend.value;
      final yearly = subsController.totalYearlySpend.value;
      final subsCount = subsController.totalActiveSubs.value;
      final avg = subsCount > 0 ? (monthly / subsCount) : 0.0;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly Spend',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75), fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              '\$${monthly.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.15),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _MiniStat(
                  label: 'Yearly',
                  value: '\$${yearly.toStringAsFixed(0)}',
                ),
                Container(
                    width: 1,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white.withOpacity(0.2)),
                _MiniStat(
                  label: 'Subscriptions',
                  value: '$subsCount',
                ),
                Container(
                    width: 1,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white.withOpacity(0.2)),
                _MiniStat(
                  label: 'Avg / Sub',
                  value: '\$${avg.toStringAsFixed(0)}',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge();
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: color, size: 14),
            const SizedBox(width: 4),
            Text(text,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    });
  }
}

class _LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AnalyticsController>();

    return Obx(() {
      final spots = controller.monthlySpendingSpots;
      if (spots.isEmpty) return const Center(child: Text('No data'));

      double maxY = spots.fold(0.0, (max, spot) => spot.y > max ? spot.y : max);
      maxY = maxY == 0 ? 100 : maxY * 1.2;

      return LineChart(
        LineChartData(
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
            leftTitles: const AxisTitles(),
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
                  if (v.toInt() < 0 || v.toInt() >= months.length) {
                    return const SizedBox();
                  }
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
                checkToShowDot: (spot, _) => spot.x == spots.last.x,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.0),
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
        ),
      );
    });
  }
}

class _DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AnalyticsController>();

    return Obx(() {
      final sections = controller.getCategorySections(true); // true for small
      final legend = controller.getCategoryLegend();

      if (sections.isEmpty) return const Center(child: Text('No data'));

      return Row(
        children: [
          SizedBox(
            width: 140,
            child: PieChart(
                PieChartData(
                    sections: sections, centerSpaceRadius: 36, sectionsSpace: 2)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: legend
                  .map((l) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LegendRow(color: l.$2, label: l.$1, pct: l.$3),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    });
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;
  const _LegendRow(
      {required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.labelMedium)),
        Text(pct,
            style: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
