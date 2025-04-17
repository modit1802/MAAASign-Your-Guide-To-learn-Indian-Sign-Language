import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import 'package:SignEase/Learning_zone.dart';
import 'package:SignEase/ScorePage.dart';
import 'package:SignEase/about_page.dart';
import 'package:SignEase/schedule_session_page.dart';
import 'package:SignEase/sabse_jyada_main_page.dart';
import 'package:SignEase/challenge_page.dart';
import 'package:SignEase/chatbot_screen.dart'; // <-- NEW
import 'package:SignEase/notification_service.dart';


class InitialPage1 extends StatefulWidget {
  final int index;
  const InitialPage1({Key? key, this.index = 0}) : super(key: key);

  @override
  State<InitialPage1> createState() => _InitialPage1State();
}

class _InitialPage1State extends State<InitialPage1> with WidgetsBindingObserver {
  late int _currentIndex;
  late PageController _pageController;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
    _fetchUserPhoto();
  // NotificationService.init().then((_) {
  //   NotificationService.showInstantNotification(); // Immediate test notification.
  //   NotificationService.scheduleRepeatingNotification(); // Repeating notification every 2 minutes.
  // });
  // ✅ Initialize Notifications and start repeating every 1 min
    NotificationService.init().then((_) {
      NotificationService.showInstantNotification(); // One-time notification on app start
      NotificationService.startRepeatingNotification(); // Repeats every 1 minute
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // ✅ Stop the notifications if you want them to end when user leaves this page
    NotificationService.stopRepeatingNotification();
    super.dispose();
  }

  Future<void> _fetchUserPhoto() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() => _photoUrl = userDoc['photoUrl']);
      }
    } catch (e) {
      print('Error fetching user photo: $e');
    }
  }

  final List<Widget> _pages = [
    LearningZone(),
    ChallengePage(),
    ChatBot(), // <-- Updated
    ScheduleSessionPage(),
    ScorePage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  Future<void> _logout() async {
    try {
      setState(() => _isLoading = true);
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Sabse_Jyada_Main_page()),
      );
    } catch (e) {
      print('Logout error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildLoadingOverlay() => Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset(
            'assets/loading.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      );

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Are you sure?',
          style: TextStyle(
            color: Color.fromARGB(255, 238, 126, 34),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color.fromARGB(255, 238, 126, 34)),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text(
              'Yes',
              style: TextStyle(color: Color.fromARGB(255, 238, 126, 34)),
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MAAASign: Your Guide to Learning ISL',
            style: TextStyle(fontSize: 18),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 250, 233, 215),
          actions: [
            if (_photoUrl != null)
              GestureDetector(
                onTap: _showProfileDialog,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_photoUrl!),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
              onPageChanged: (i) => setState(() => _currentIndex = i),
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 233, 215),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 250, 233, 215),
            buttonBackgroundColor: const Color.fromARGB(255, 255, 249, 242),
            height: 60,
            index: _currentIndex,
            onTap: _onItemTapped,
            items: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.fact_check, 1),
              _buildNavItem(Icons.touch_app_outlined, 2),
              _buildNavItem(Icons.schedule, 3),
              _buildNavItem(Icons.score, 4),
              _buildNavItem(Icons.info, 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Material(
      elevation: _currentIndex == index ? 8 : 0,
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          size: 25,
          color: _currentIndex == index
              ? const Color.fromARGB(255, 238, 126, 34)
              : Colors.grey,
        ),
      ),
    );
  }
}
