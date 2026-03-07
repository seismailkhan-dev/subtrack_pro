import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:subtrack_pro/features/subscription_detail/subscription_detail_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/calendar_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            onPressed: () => controller.selectToday(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final selected = controller.selectedDay.value ?? DateTime.now();
        final dayEvents = controller.selectedDayEvents;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Widget
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  boxShadow: isDark ? null : AppShadows.sm,
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2026, 12, 31),
                  focusedDay: controller.focusedDay.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(controller.selectedDay.value, day),
                  eventLoader: controller.getEventsForDay,
                  onDaySelected: controller.onDaySelected,
                  onPageChanged: controller.onPageChanged,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    selectedDecoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700),
                    markerDecoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                    defaultTextStyle: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                    weekendTextStyle: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: theme.textTheme.titleLarge!,
                    leftChevronIcon: Icon(Icons.chevron_left_rounded,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                    rightChevronIcon: Icon(Icons.chevron_right_rounded,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: theme.textTheme.labelSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                    weekendStyle: theme.textTheme.labelSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Day Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(selected),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayEvents.isEmpty
                          ? 'No charges on this day'
                          : '${dayEvents.length} charge${dayEvents.length > 1 ? 's' : ''} due',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    if (dayEvents.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(Icons.event_available_rounded,
                                  size: 48,
                                  color: AppColors.accent.withOpacity(0.5)),
                              const SizedBox(height: 12),
                              Text('Free Day!',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: AppColors.accent)),
                              const SizedBox(height: 4),
                              Text('No subscriptions renew today',
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      )
                    else
                      ...dayEvents.map((sub) => _CalendarSubCard(
                          sub: sub,
                          isDark: isDark,
                          onTap: () => Get.to(SubscriptionDetailScreen(
                                subscription: sub,
                              )))),

                    // Upcoming this month
                    const SizedBox(height: 24),
                    Text('This Month', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    if (controller.currentMonthEvents.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text('No subscriptions this month',
                                style: theme.textTheme.bodySmall)),
                      )
                    else
                      ...controller.currentMonthEvents.map(
                        (sub) => _MonthRow(
                            sub: sub,
                            isDark: isDark,
                            onTap: () => Get.to(SubscriptionDetailScreen(
                                  subscription: sub,
                                ))),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _CalendarSubCard extends StatelessWidget {
  final SubscriptionDataModel sub;
  final bool isDark;
  final VoidCallback onTap;
  const _CalendarSubCard(
      {required this.sub, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(sub.brandColor).withValues(alpha: 0.1),
              Color(sub.brandColor).withValues(alpha: 0.04)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border:
              Border.all(color: Color(sub.brandColor).withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: Color(sub.brandColor).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                  child: Text(FormatService.getLogoName(sub.name),
                      style: TextStyle(
                          color: Color(sub.brandColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sub.name, style: theme.textTheme.titleSmall),
                    Text(sub.category, style: theme.textTheme.bodySmall),
                  ]),
            ),
            Text('\$${sub.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _MonthRow extends StatelessWidget {
  final SubscriptionDataModel sub;
  final bool isDark;
  final VoidCallback onTap;
  const _MonthRow(
      {required this.sub, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text('${sub.nextBillingDate.day}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14))),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Color(sub.brandColor).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(FormatService.getLogoName(sub.name),
                      style: TextStyle(
                          color: Color(sub.brandColor),
                          fontWeight: FontWeight.w800,
                          fontSize: 12))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(sub.name, style: theme.textTheme.titleSmall)),
            Text('\$${sub.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
