import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:subtrack_pro/features/subscription_detail/subscription_detail_screen.dart';
import 'package:subtrack_pro/shared/widgets/custom_loader.dart';
import '../../controllers/get_subscription_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
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


  @override
  void initState() {
    super.initState();
    getSubController.fetchSubscriptions();
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
        floatingActionButton: _tabIndex == 0
            ? _fab()
            : null,
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
            Get.to((SubscriptionDetailScreen(subscription: sub,))),
        onSubDelete: (sub) {},
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
      onPressed: () =>
          Navigator.pushNamed(context, AppRoutes.addSubscription),
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
              // if (upcoming.isNotEmpty) ...[
              //   SectionHeader(
              //     title: 'Upcoming Renewals',
              //     action: 'See All',
              //     onAction: () {},
              //   ),
              //   const SizedBox(height: 14),
              //   ...upcoming.map((sub) => SubscriptionCard(
              //         subscription: sub,
              //         onTap: () => onSubTap(sub),
              //         onDelete: () => onSubDelete(sub),
              //       )),
              //   const SizedBox(height: 28),
              // ],

              // ── All Subscriptions ─────────────────────────────────────
              SectionHeader(
                title: 'Recent Subscriptions',
                action: 'View All',
                onAction: () {
                  Get.to(()=>AllSubscriptionsScreen());
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
                        onTap: () => onSubTap(getSubController.homeSubListModel[index]),
                        onDelete: () => onSubDelete(getSubController.homeSubListModel[index]),
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
    final theme = Theme.of(context);
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
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.trending_up_rounded, color: AppColors.danger, size: 14),
          SizedBox(width: 4),
          Text('+12%',
              style: TextStyle(
                  color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
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
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (_) => FlLine(
            color: isDark
                ? AppColors.borderDark
                : AppColors.borderLight,
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
                const months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
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
              checkToShowDot: (spot, _) =>
                  spot.x == spots.last.x,
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
        minY: 80,
        maxY: 140,
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sections = [
      PieChartSectionData(
          value: 30, color: AppColors.catEntertainment, title: 'Ent', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          value: 15, color: AppColors.catMusic, title: 'Music', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          value: 25, color: AppColors.catHealth, title: 'Health', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          value: 20, color: AppColors.catProductivity, title: 'Prod', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          value: 10, color: AppColors.catStorage, title: 'Other', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
    ];
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 36, sectionsSpace: 2)),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendRow(color: AppColors.catEntertainment, label: 'Entertainment', pct: '30%'),
              const SizedBox(height: 8),
              _LegendRow(color: AppColors.catMusic, label: 'Music', pct: '15%'),
              const SizedBox(height: 8),
              _LegendRow(color: AppColors.catHealth, label: 'Health', pct: '25%'),
              const SizedBox(height: 8),
              _LegendRow(color: AppColors.catProductivity, label: 'Productivity', pct: '20%'),
              const SizedBox(height: 8),
              _LegendRow(color: AppColors.catStorage, label: 'Other', pct: '10%'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;
  const _LegendRow({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.labelMedium)),
        Text(pct, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
