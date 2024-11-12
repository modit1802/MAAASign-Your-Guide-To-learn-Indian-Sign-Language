import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%203/learnpronoun.dart';
import 'package:SignEase/Week%203/pronoun_quiz.dart';
import 'package:flutter/material.dart';

import 'pronoun_practice2.dart';

class PronounStartScreen extends StatefulWidget {
  const PronounStartScreen({super.key});

  @override
  State<PronounStartScreen> createState() => _PronounStartScreenState();
}

class _PronounStartScreenState extends State<PronounStartScreen> {
  bool _showGif = true; // State variable to control GIF visibility
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
    // Get the screen width and height
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            // Set height based on screen height
            height: screenWidth < 600
                ? 120
                : 140, // Adjust height for smaller screens
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    // Adjust image size for smaller screens
                    width: screenWidth < 600 ? 60 : 80,
                    height: screenWidth < 600 ? 60 : 80,
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
                          fontSize:
                              screenWidth < 600 ? 16 : 18, // Adjust title size
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: screenWidth < 600
                              ? 12
                              : 14, // Adjust description size
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 233, 215),
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
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/ladder.png'),
                fit: BoxFit.cover, // Adjust the image to cover the whole area
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.14),
                      _buildCard(
                        onTap: () => _handleCardTap(0, const LearnPronouns()),
                        imagePath: 'images/verbs.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Learn Pronouns',
                        description:
                            'Learn Pronouns with the help of interactive learning material!',
                        index: 0,
                      ),
                      const SizedBox(height: 12), // Space between the cards
                      _buildCard(
                        onTap: () => _handleCardTap(1, PronounQuiz()),
                        imagePath: 'images/quiz.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Play Quiz',
                        description:
                            "Let's Play a simple Quiz consisting of one image question with 4 options Test your knowledge of pronouns!",
                        index: 1,
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        onTap: () => _handleCardTap(2, VideoBingoGame()),
                        imagePath: 'images/bingo.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Bingo Bonanza!',
                        description:
                            "Get ready for a video-packed bingo adventure! Watch the clips, guess the word, and mark your card.",
                        index: 2,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Add the GIF at the center bottom with a close button
          if (_showGif)
            Container(
              color: const Color.fromARGB(255, 34, 34, 34).withOpacity(0.92),
              // Black overlay with opacity
            ),
          if (_showGif)
            Center(
              child: Positioned(
                child: Center(
                  child: Image.asset(
                    'images/week1screenbeg.gif', // Update the image path here
                    height: 350, // Set the height of the GIF
                    fit: BoxFit.contain, // Adjust how the GIF is displayed
                  ),
                ),
              ),
            ),
          if (_showGif)
            Positioned(
              top: 60, // Position close button at the top of the screen
              right: 20, // Align to the right side
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
}
