// lib/main.dart

import 'package:SignEase/sabse_jyada_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'login_page.dart';
// 1️⃣ Import the notification service
import 'package:SignEase/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2️⃣ Initialize notification service
  await NotificationService().init();

  // 3️⃣ Request permission for Android 13+ (API 33+)
  await requestAndroidNotificationPermission();

  // 4️⃣ Schedule notification
  NotificationService().scheduleInactivityReminder();

  // System UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(255, 250, 233, 215),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Force portrait orientation
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(const MyApp());
  });
}

// ✅ Ask permission for Android 13+ using plugin method
Future<void> requestAndroidNotificationPermission() async {
  final plugin = FlutterLocalNotificationsPlugin();
  final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (android != null) {
    final granted = await android.requestPermission();
    debugPrint("🔔 Notification permission granted: $granted");
  }
}

extension on AndroidFlutterLocalNotificationsPlugin {
  requestPermission() {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep navbar color consistent on hot reload
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 250, 233, 215),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAAASign: Your Guide to Learn ISL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const InitialPage1();
        } else {
          return const Sabse_Jyada_Main_page();
        }
      },
    );
  }
}
