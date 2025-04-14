import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Step 1: Initialize time zones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Or your local time zone

    // Step 2: Initialize Android/iOS settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await _plugin.initialize(
      InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (_) {},
    );

    // Step 3: Request notification permission on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<void> scheduleInactivityReminder() async {
    await _plugin.cancel(0); // Cancel existing if any

    final when = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)); // For testing

    await _plugin.zonedSchedule(
      0,
      'We miss you! 👋',
      'It’s been 8 hours since your last visit. Come back to keep your streak going!',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'inactivity_channel',
          'Inactivity Reminders',
          channelDescription: 'Notifies when you haven’t opened the app for 8 hrs',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  requestPermission() {}
}


