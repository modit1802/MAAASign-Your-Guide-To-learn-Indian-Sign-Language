import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/relations_learn.dart';
import 'package:SignEase/Week 2/matchmaker_number.dart';
import 'package:SignEase/Week 2/practiceassignment2.dart';
import 'package:flutter/material.dart';
class NumberStartscreen extends StatefulWidget {
  const NumberStartscreen({super.key});

  @override
  State<NumberStartscreen> createState() => _NumberStartscreenState();
}

class _NumberStartscreenState extends State<NumberStartscreen> {
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77): color,
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
                        textAlign: TextAlign.justify,
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

@override
Widget build(BuildContext context) {
  // Get screen width and height using MediaQuery
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 250, 233, 215),
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
                padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding based on screen width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.02), // Adjust space between widgets
                    _buildCard(
                      onTap: () => _handleCardTap(0, const SentenceStartscreen()),
                      imagePath: 'images/Relation.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Learn Relation',
                      description: 'Learn Relations with the help of interactive learning material!',
                      index: 0,
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjust space between widgets
                    _buildCard(
                      onTap: () => _handleCardTap(1, PracticeAssignment2()),
                      imagePath: 'images/quiz.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Play Quiz',
                      description: "Let's Play a simple Quiz consisting of one image question with 4 options. Test your knowledge of alphabets!",
                      index: 1,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildCard(
                      onTap: () => _handleCardTap(2, Match_maker_numbers()),
                      imagePath: 'images/true_false.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Guess whether True or False',
                      description: "True/False Challenge: Test your memory by guessing true false in this fun and engaging game!",
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
            color: const Color.fromARGB(255, 34, 34, 34).withOpacity(0.92), // Black overlay with opacity
          ),
        if (_showGif)
          Center(
            child: Image.asset(
              'images/week1screenbeg.gif',
              height: screenHeight * 0.45, // Adjust height of GIF based on screen height
              fit: BoxFit.contain, // Adjust how the GIF is displayed
            ),
          ),
        if (_showGif)
          Positioned(
            top: screenHeight * 0.08, // Adjust top position based on screen height
            right: screenWidth * 0.05, // Adjust right position based on screen width
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showGif = false; // Hide the GIF when the close button is pressed
                });
              },
              child: const Icon(
                Icons.close,
                size: 50,
                color: Colors.white, // White cross icon for the close button
              ),
            ),
          ),
          _buildBottomButtons(screenWidth, screenHeight),
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

Widget _buildBottomButtons(double screenWidth, double screenHeight) {
  return Positioned(
    bottom: screenHeight * 0.03,
    left: 0,
    right: 0,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBottomButton(icon: Icons.home, onTap: () => _navigateToPage(const InitialPage1())),
          SizedBox(width: screenWidth * 0.05),
          _buildBottomButton(icon: Icons.score, onTap: () => _navigateToPage(const InitialPage1())),
          SizedBox(width: screenWidth * 0.05),
          _buildBottomButton(icon: Icons.assignment, onTap: () => _navigateToPage(const InitialPage1())),
          SizedBox(width: screenWidth * 0.05),
          _buildBottomButton(icon: Icons.info, onTap: () => _navigateToPage(const InitialPage1())),
        ],
      ),
    ),
  );
}

// Bottom Button Builder for consistency
Widget _buildBottomButton({required IconData icon, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
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
      child: Icon(
        icon,
        size: 30,
        color: const Color.fromARGB(255, 165, 74, 17),
      ),
    ),
  );
}

// Navigation Helper
void _navigateToPage(Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}


}
