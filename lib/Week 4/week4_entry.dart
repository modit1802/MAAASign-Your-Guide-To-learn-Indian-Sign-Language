import 'package:SignEase/Challengers_All_Weeks/challenger_week3/challenger3.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%203/pronounstart.dart';
import 'package:SignEase/Week%203/verbstart.dart';
import 'package:SignEase/Week%204/tutorial_screen_week4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SignEase/Week%203/nounstart.dart';

import 'Basic_Sentence_Structure.dart';

class Week4Entry extends StatefulWidget {
  const Week4Entry({super.key});

  @override
  _Week4EntryState createState() => _Week4EntryState();
}

class _Week4EntryState extends State<Week4Entry> {
  bool _showGif = false;
  int? _selectedCardIndex;
  int _currentIndex = 0; // This keeps track of the selected tab index

  @override
  void initState() {
    super.initState();
    _showTutorialScreen(); // Show tutorial screen on page entry
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex =
          index; // Update the current index to highlight the selected tab
    });

    // Navigation actions based on the selected index
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InitialPage1(index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 233, 215),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.home,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30,
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.fact_check,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30,
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.score,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30,
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30,
                    ),
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.14),

                  // Verb Card
                  _buildCard(
                    onTap: () => _handleCardTap(0, const Basic_Sentence_Structure()),
                    imagePath: 'images/sentence_struct.png',
                    color: const Color.fromARGB(255, 255, 255, 255),
                    title: 'Basic Sentence Structure',
                    description: 'Learn and practice Basic Sentence Structure in ISL',
                    index: 0,
                  ),

                  const SizedBox(height: 10),

                  // Noun Card
                  _buildCard(
                    onTap: () => _handleCardTap(1, const NounStartScreen()),
                    imagePath: 'images/sentence_formation.jpg',
                    color: Colors.white,
                    title: 'Simple Sentence Formation',
                    description: 'Learn and practice Simple Sentence Formation in ISL',
                    index: 1,
                  ),

                  const SizedBox(height: 10),

                  // Challenger Card
                  _buildCard(
                    onTap: () => _handleCardTap(3, Challenger3(score: 0)),
                    imagePath: 'images/challenger.png',
                    color: Colors.white,
                    title: 'Challenger',
                    description: 'Challenge yourself to unlock Week 4!',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.065,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show tutorial screen at entry
  void _showTutorialScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Tutorial_screen_for_challenger_Week4(
                onBackPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
      );
    });
  }

  // Handle Card Tap with index and navigation
  void _handleCardTap(int index, Widget nextPage) {
    setState(() {
      _selectedCardIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      ).then((_) =>
          setState(() {
            _selectedCardIndex = null;
          }));
    });
  }

  // Card Builder for consistency
  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 140,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}