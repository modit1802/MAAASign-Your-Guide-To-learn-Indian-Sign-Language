import 'dart:math';

import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%201/learnnumbers.dart';
import 'package:SignEase/Week%201/matchmaker_number_1.dart';
import 'package:SignEase/Week%201/matchmaker_number_2.dart';
import 'package:SignEase/Week%201/practiceassignment2.dart';
import 'package:flutter/material.dart';

class NumberStartscreen extends StatefulWidget {
  const NumberStartscreen({super.key});

  @override
  State<NumberStartscreen> createState() => _NumberStartscreenState();
}

class _NumberStartscreenState extends State<NumberStartscreen> {
  bool _showGif = false; // State variable to control GIF visibility
  int? _selectedCardIndex;
  @override
  void initState() {
    super.initState();
  }

  // Method to check if the GIF has been shown before
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
                        textAlign: TextAlign.left,
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

  Widget _buildCard2({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
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

  void _handleCardTap(int index, Widget nextPage) {
    setState(() {
      _selectedCardIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      ).then((_) => setState(() {
            _selectedCardIndex = null; // Reset after navigation
          }));
    });
  }
  void _handleCardTap2(int index, List<Widget> nextPages) {
    setState(() {
      _selectedCardIndex = index;
    });

    // Pick a random page
    final random = Random();
    Widget randomPage = nextPages[random.nextInt(nextPages.length)];

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => randomPage),
      ).then((_) => setState(() {
        _selectedCardIndex = null; // Reset after navigation
      }));
    });
  }
  int _currentIndex = 0; // This keeps track of the selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex =
          index; // Update the current index to highlight the selected tab
    });

    // You can add navigation or specific actions based on the selected index
    switch (index) {
      case 0:
        // Navigate to the Home screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 0),
          ),
        ); // Replace with your actual route
        break;
      case 1:
        // Navigate to the Test screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 1),
          ),
        ); // Replace with your actual route
        break;
      case 2:
        // Navigate to the Score screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 2),
          ),
        ); // Replace with your actual route
        break;
      case 3:
        // Navigate to the About screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 3),
          ),
        ); // Replace with your actual route
        break;
      default:
        break;
    }
  } // Track the selected card index

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                      size: 30, // Adjust size here (default is 24)
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.fact_check,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30, // Adjust size here
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.score,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30, // Adjust size here
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 165, 74, 17),
                      size: 30, // Adjust size here
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
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/ladder.png'),
                fit: BoxFit.cover, // Adjust the image to cover the whole area
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth *
                      0.04), // Adjust padding based on screen width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight *0.14), // Adjust space between widgets
                      _buildCard2(
                        onTap: () => _handleCardTap(0, const LearnNumbers()),
                        imagePath: 'images/numbersicon.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Review Signing Numbers',
                        index: 0,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.02), // Adjust space between widgets
                      _buildCard(
                        onTap: () => _handleCardTap(1, PracticeAssignment2()),
                        imagePath: 'images/quiz.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Pop Quiz !',
                        description:
                            "Identify the correct number!",
                        index: 1,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildCard(
                        onTap: () => _handleCardTap2(
                            2, [const Match_maker_numbers1(score: 0),const Match_maker_numbers2(score: 0)]),
                        imagePath: 'images/match.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Match It Up !',
                        description:
                            "Pair the numbers with items",
                        index: 2,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showGif)
            Container(
              width: screenWidth,
              height: screenHeight,
              color: const Color.fromARGB(255, 34, 34, 34)
                  .withOpacity(0.92), // Black overlay with opacity
            ),
          if (_showGif)
            Center(
              child: Image.asset(
                'images/week1screenbeg.gif',
                height: screenHeight *
                    0.45, // Adjust height of GIF based on screen height
                fit: BoxFit.contain, // Adjust how the GIF is displayed
              ),
            ),
          if (_showGif)
            Positioned(
              top: screenHeight *
                  0.08, // Adjust top position based on screen height
              right: screenWidth *
                  0.05, // Adjust right position based on screen width
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showGif =
                        false; // Hide the GIF when the close button is pressed
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 50,
                  color: Colors.white, // White cross icon for the close button
                ),
              ),
            ),
          Positioned(
            top: screenHeight * 0.055,
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

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
