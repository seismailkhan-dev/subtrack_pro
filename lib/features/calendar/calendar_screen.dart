import 'package:flutter/material.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<SubscriptionDataModel> _eventsForDay(DateTime day) {
    return AppConstants.mockSubscriptions.where((sub) {
      final nb = sub.nextBillingDate;
      return nb.day == day.day && nb.month == day.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selected = _selectedDay ?? DateTime.now();
    final dayEvents = _eventsForDay(selected);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            onPressed: () => setState(() {
              _focusedDay = DateTime.now();
              _selectedDay = DateTime.now();
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _eventsForDay,
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                onPageChanged: (focused) {
                  setState(() => _focusedDay = focused);
                },
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
                    ...dayEvents.map((sub) => _CalendarSubCard(sub: sub, isDark: isDark)),

                  // Upcoming this month
                  const SizedBox(height: 24),
                  Text('This Month', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ..._thisMonthEvents().map(
                    (sub) => _MonthRow(sub: sub, isDark: isDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SubscriptionDataModel> _thisMonthEvents() {
    return AppConstants.mockSubscriptions
        .where((s) => s.nextBillingDate.month == _focusedDay.month)
        .toList()
      ..sort((a, b) => a.nextBillingDate.day.compareTo(b.nextBillingDate.day));
  }

  String _formatDate(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _CalendarSubCard extends StatelessWidget {
  final SubscriptionDataModel sub;
  final bool isDark;
  const _CalendarSubCard({required this.sub, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(sub.brandColor).withValues(alpha: 0.1), Color(sub.brandColor).withValues(alpha: 0.04)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Color(sub.brandColor).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Color(sub.brandColor).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(FormatService.getLogoName(sub.name), style: TextStyle(color: Color(sub.brandColor), fontWeight: FontWeight.w900, fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(sub.name, style: theme.textTheme.titleSmall),
              Text(sub.category, style: theme.textTheme.bodySmall),
            ]),
          ),
          Text('\$${sub.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _MonthRow extends StatelessWidget {
  final SubscriptionDataModel sub;
  final bool isDark;
  const _MonthRow({required this.sub, required this.isDark});

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
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('${sub.nextBillingDate.day}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14))),
          ),
          const SizedBox(width: 12),
          Container(width: 32, height: 32,
            decoration: BoxDecoration(color: Color(sub.brandColor).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(FormatService.getLogoName(sub.name), style: TextStyle(color: Color(sub.brandColor), fontWeight: FontWeight.w800, fontSize: 12))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(sub.name, style: theme.textTheme.titleSmall)),
          Text('\$${sub.price.toStringAsFixed(2)}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
