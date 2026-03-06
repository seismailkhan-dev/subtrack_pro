import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';
import '../add_subscription/add_subscription_screen.dart';
import '../../controllers/get_subscription_controller.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  final SubscriptionDataModel subscription;

  const SubscriptionDetailScreen({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header SliverAppBar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(subscription.brandColor),
                      Color.lerp(Color(subscription.brandColor), Colors.black, 0.4)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Logo
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            FormatService.getLogoName(subscription.name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(subscription.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(subscription.category,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () => _showOptions(context),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Price Card ──────────────────────────────────────────
                _PriceCard(subscription: subscription),
                const SizedBox(height: 20),

                // ── Details ─────────────────────────────────────────────
                _DetailCard(subscription: subscription, isDark: isDark),
                const SizedBox(height: 20),

                // ── Spending Chart ──────────────────────────────────────
                ChartContainer(
                  title: 'Spending History',
                  subtitle: 'Last 6 months',
                  chart: SizedBox(
                    height: 100,
                    child: _SubBarChart(color: Color(subscription.brandColor)),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Payment History ─────────────────────────────────────
                Text('Payment History', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                ..._paymentHistory(subscription).map(
                  (p) => _PaymentTile(
                    date: p['date'] as String,
                    amount: p['amount'] as double,
                    status: p['status'] as String,
                    isDark: isDark,
                  ),
                ),

                if (subscription.notes != null &&
                    subscription.notes!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Notes', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Text(subscription.notes!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(height: 1.5)),
                  ),
                ],

                const SizedBox(height: 28),

                // Delete Button
                AppButton(
                  label: 'Delete Subscription',
                  color: AppColors.danger,
                  onTap: () => _showDeleteDialog(context),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _paymentHistory(SubscriptionDataModel sub) {
    final now = DateTime.now();
    return List.generate(4, (i) {
      final date = DateTime(now.year, now.month - i, 15);
      return {
        'date': '${date.day}/${date.month}/${date.year}',
        'amount': sub.price,
        'status': 'Paid',
      };
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            SettingsTile(
              icon: Icons.edit_outlined,
              title: 'Edit Subscription',
              onTap: () {
                Navigator.pop(context); // close sheet
                // Navigate to AddSubscriptionScreen passing the model as argument
                Get.to(() => const AddSubscriptionScreen(), arguments: subscription);
              },
            ),
            SettingsTile(
              icon: Icons.share_outlined,
              title: 'Share',
              onTap: () => Navigator.pop(context),
            ),
            SettingsTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context); // close bottom sheet
                _showDeleteDialog(context); // show confirmation before deleting
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: const Text('Delete Subscription?'),
        content: Text(
            'Are you sure you want to delete ${subscription.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep It'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              if (subscription.id != null) {
                await GetSubscriptionsController.to.deleteSubscription(subscription.id!);
                await GetSubscriptionsController.to.fetchSubscriptions(); // Refresh home screen
              }
              Get.back(); // navigate back to previous screen
            },
            child: const Text('Delete Sub',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final SubscriptionDataModel subscription;
  const _PriceCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final billingDate = DateTime(subscription.nextBillingDate.year, subscription.nextBillingDate.month, subscription.nextBillingDate.day);
    final days = billingDate.difference(todayDate).inDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: isDark ? null : AppShadows.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price', style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  '\$${subscription.price.toStringAsFixed(2)}',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(color: Color(subscription.brandColor)),
                ),
                Text('/ ${subscription.billingCycle.toLowerCase()}',
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Container(width: 1, height: 60, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Next Renewal', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(subscription.nextBillingDate),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  _DaysBadge2(days: days),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_month(d.month)} ${d.year}';
  String _month(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m - 1];
  }
}

class _DaysBadge2 extends StatelessWidget {
  final int days;
  const _DaysBadge2({required this.days});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    if (days < 0) { color = AppColors.danger; label = 'Overdue by ${days.abs()}d'; }
    else if (days <= 1) { color = AppColors.danger; label = days == 0 ? 'Due Today' : 'Tomorrow'; }
    else if (days <= 3) { color = AppColors.warning; label = 'in $days days'; }
    else { color = AppColors.accent; label = 'in $days days'; }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final SubscriptionDataModel subscription;
  final bool isDark;
  const _DetailCard({required this.subscription, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          _Row(label: 'Category', value: subscription.category, isDark: isDark),
          Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
          _Row(label: 'Billing Cycle', value: subscription.billingCycle, isDark: isDark),
          Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
          _Row(
            label: 'Start Date',
            value: '${subscription.startDate.day}/${subscription.startDate.month}/${subscription.startDate.year}',
            isDark: isDark,
          ),
          Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
          _Row(label: 'Auto Renew', value: subscription.autoRenew ? 'On' : 'Off', isDark: isDark),
          Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
          _Row(label: 'Reminder', value: '${subscription.reminderDays} days before', isDark: isDark),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _Row({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _SubBarChart extends StatelessWidget {
  final Color color;
  const _SubBarChart({required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
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
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(months[v.toInt()],
                      style: const TextStyle(fontSize: 9, color: AppColors.textTertiaryLight)),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(6, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: i == 5 ? 15.99 : 15.99,
                color: i == 5 ? color : color.withOpacity(0.3),
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
        maxY: 20,
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String date;
  final double amount;
  final String status;
  final bool isDark;
  const _PaymentTile({required this.date, required this.amount, required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.receipt_long_outlined, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment', style: theme.textTheme.titleSmall),
              Text(date, style: theme.textTheme.bodySmall),
            ],
          )),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${amount.toStringAsFixed(2)}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
              child: const Text('Paid', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ]),
        ],
      ),
    );
  }
}
