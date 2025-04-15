// lib/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize time zones (required for scheduling)
    tzData.initializeTimeZones();

    // Android initialization settings.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showInstantNotification() async {
    await _notificationsPlugin.show(
      1,
      '👋 Hello!',
      'Welcome back!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          channelDescription: 'Instant alerts for testing',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // ✅ Start a repeating notification every 6 hours
  static Future<void> startRepeatingNotification() async {
    await _notificationsPlugin.zonedSchedule(
      2,
      '⏰ Time to Learn ISL!',
      'It’s time for your scheduled ISL practice reminder.',
      _nextInstanceInSixHours(), // Set to 6 hours later
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'repeat_channel',
          'Scheduled Reminders',
          channelDescription: 'Reminders to practice ISL every 6 hours',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Triggers daily at the same time
    );
  }

  // Function to calculate the next time in 6 hours
  static tz.TZDateTime _nextInstanceInSixHours() {
    final now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(hours: 6)); // 6 hours from now
  }

  // Optional stop function if you want to cancel the repeating notification
  static Future<void> stopRepeatingNotification() async {
    await _notificationsPlugin.cancel(2);
  }
}
