import 'package:flutter/material.dart';
import 'package:flutter_login_signup/LearnPage.dart';
import 'package:flutter_login_signup/home_page.dart';

class InitialPage1 extends StatefulWidget {
  const InitialPage1({super.key});

  @override
  State<InitialPage1> createState() => _InitialPage1State();
}

class _InitialPage1State extends State<InitialPage1> {
  int _currentIndex = 0; // Track the selected index of the BottomNavigationBar
  PageController _pageController = PageController(); // Controller for PageView

  // Pages for each tab
  final List<Widget> _pages = [
    LearnPage(), // Replace with your actual HomePage
    HomePage(), // Replace with your ScorePage
    HomePage(), // Replace with your TestPage
    HomePage(), // Replace with your AboutPage
  ];

  // Method to handle navigation on bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected tab index
    });
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the bottom nav bar on swipe
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set the background color to white
        currentIndex: _currentIndex, // Set the current tab index
        onTap: _onItemTapped, // Navigate on bottom bar tap
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent, // Color for the selected icon
        unselectedItemColor: Colors.grey, // Color for the unselected icons
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
