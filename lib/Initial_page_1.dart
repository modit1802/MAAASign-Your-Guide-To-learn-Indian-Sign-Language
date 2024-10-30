import 'package:flutter/material.dart';
import 'package:flutter_login_signup/LearnPage.dart';
import 'package:flutter_login_signup/home_page.dart';
import 'package:flutter_login_signup/about_page.dart';

class InitialPage1 extends StatefulWidget {
  const InitialPage1({Key? key}) : super(key: key);

  @override
  State<InitialPage1> createState() => _InitialPage1State();
}

class _InitialPage1State extends State<InitialPage1> {
  int _currentIndex = 0; // Track the selected index of the BottomNavigationBar
  final PageController _pageController = PageController(); // Controller for PageView

  // List of pages for the BottomNavigationBar items
  final List<Widget> _pages = [
    LearnPage(),
    HomePage(),
    HomePage(),
    AboutPage(),
  ];

  // Method to handle navigation on bottom nav bar
  void _onItemTapped(int index) {
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the bottom nav bar on page swipe
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update index and navigate to page
          });
          _onItemTapped(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
