import 'package:SignEase/learnnumbers.dart';
import 'package:SignEase/matchmaker_alphabet.dart';
import 'package:SignEase/practiceassignment2.dart';
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
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 250, 233, 215),
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
                      const SizedBox(height: 12),
                      _buildCard(
                      onTap: () => _handleCardTap(0, const LearnNumbers()),
                      imagePath: 'images/alphabetsicon.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Learn Numbers',
                      description: 'Learn Numbers with the help of interactive learning material!',
                      index: 0,
                    ),
                      const SizedBox(height: 12), // Space between the cards
                      _buildCard(
                      onTap: () => _handleCardTap(1, PracticeAssignment2()),
                      imagePath: 'images/quiz.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Play Quiz',
                      description: "Let's Play a simple Quiz consist of one image question with 4 options Test your knowledge of alphabets!",
                      index: 1,
                    ),
                      const SizedBox(height: 12),
                      _buildCard(
                      onTap: () => _handleCardTap(2, const Match_maker_alphabet(score: 0,)),
                      imagePath: 'images/match.png',
                      color: const Color.fromARGB(255, 255, 255, 255),
                      title: 'Guess the Perfect Pairs',
                      description: "Matchmaker's Challenge: Test your memory by pairing items before time runs out in this fun and engaging game!",
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
        ],
      ),
    );
  }
}
