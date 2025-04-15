import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle tap on notification here
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground, // Optional
    );

    // Step 3: Ask notification permission on Android 13+ and iOS
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleInactivityReminder() async {
    await _plugin.cancel(0); // Cancel existing notification if any

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
          channelDescription: 'Notifies when you haven’t opened the app for 8 hrs',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

// Optional background tap handler (for when the app is terminated)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification tap in the background (terminated app)
}
