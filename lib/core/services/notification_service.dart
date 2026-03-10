import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:subtrack_pro/data/models/subcription_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;

    // Request Android 13+ permission
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleNotification(SubscriptionDataModel subscription) async {
    // Check if notifications are enabled globally
    if (!SharedPrefService.getIsNotificationsEnabled()) return;

    if (subscription.id == null) return;

    // Calculate trigger date
    final triggerDate = subscription.nextBillingDate.subtract(
      Duration(days: subscription.reminderDays),
    );

    // If trigger date has already passed, we don't alert retroactively
    if (triggerDate.isBefore(DateTime.now())) return;

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      triggerDate,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'subscription_reminders', // channel id
          'Subscription Reminders', // channel name
          channelDescription:
              'Notifications for upcoming subscription renewals',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );
    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    final title = 'Upcoming Renewal: ${subscription.name}';
    final body =
        'Your ${subscription.billingCycle} subscription for ${subscription.name} (\$${subscription.price.toStringAsFixed(2)}) is due on ${subscription.nextBillingDate.month}/${subscription.nextBillingDate.day}.';

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: subscription.id!,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
          subscription.billingCycle.toLowerCase() == 'monthly'
          ? DateTimeComponents.dayOfMonthAndTime
          : (subscription.billingCycle.toLowerCase() == 'yearly'
                ? DateTimeComponents.dateAndTime
                : DateTimeComponents.dayOfWeekAndTime),
    );

    // Trial Expiration Notification (1 day before)
    if (subscription.freeTrial) {
      final trialExpiryTrigger = subscription.nextBillingDate.subtract(
        const Duration(days: 1),
      );

      // Only schedule if it's in the future
      if (trialExpiryTrigger.isAfter(DateTime.now())) {
        final tz.TZDateTime trialScheduledDate = tz.TZDateTime.from(
          trialExpiryTrigger,
          tz.local,
        );

        final trialTitle = 'Trial Ending: ${subscription.name}';
        final trialBody =
            'Your free trial for ${subscription.name} ends tomorrow. A charge of \$${subscription.price.toStringAsFixed(2)} will be applied on ${subscription.nextBillingDate.month}/${subscription.nextBillingDate.day}.';

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: subscription.id! + 20000, // Unique ID for trial reminder
          title: trialTitle,
          body: trialBody,
          scheduledDate: trialScheduledDate,
          notificationDetails: platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // TEST FUNCTION: Schedule notification 10 minutes from now
  Future<void> testScheduleNotification(
    SubscriptionDataModel subscription,
  ) async {
    if (subscription.id == null) return;

    // Test: exactly 10 minutes from now
    final triggerDate = DateTime.now().add(const Duration(minutes: 1));

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      triggerDate,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'subscription_reminders_test', // channel id
          'Subscription Reminders Test', // channel name
          channelDescription: 'Test notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );
    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    final title = 'TEST: Renewal for ${subscription.name}';
    final body =
        'This is a test notification for ${subscription.name} scheduled 10 minutes from creation.';

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: subscription.id! + 10000,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
