import 'package:SignEase/learnnoun.dart';
import 'package:SignEase/noun_quiz.dart';
import 'package:flutter/material.dart';
import 'package:SignEase/noun_practice2.dart';
class NounStartScreen extends StatefulWidget {
  const NounStartScreen({super.key});

  @override
  State<NounStartScreen> createState() => _NounStartScreenState();
}

class _NounStartScreenState extends State<NounStartScreen> {
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
          height: screenWidth < 600 ? 120 : 140, // Adjust height for smaller screens
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
                        fontSize: screenWidth < 600 ? 16 : 18, // Adjust title size
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 12 : 14, // Adjust description size
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
                        onTap: () => _handleCardTap(0, const LearnNouns()),
                        imagePath: 'images/verbs.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Learn Nouns',
                        description: 'Learn Nouns with the help of interactive learning material!',
                        index: 0,
                      ),
                      const SizedBox(height: 12), // Space between the cards
                      _buildCard(
                        onTap: () => _handleCardTap(1, NounQuiz()),
                        imagePath: 'images/quiz.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Play Quiz',
                        description: "Let's Play a simple Quiz consisting of one image question with 4 options Test your knowledge of nouns!",
                        index: 1,
                      ),
                      const SizedBox(height: 12), // Space between the cards
                      _buildCard(
                        onTap: () => _handleCardTap(2, VideoBingoGame()),
                        imagePath: 'images/bingo.png',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Bingo Bonanza!',
                        description: "Get ready for a video-packed bingo adventure! Watch the clips, guess the word, and mark your card. It's a visual feast of fun and a test of your word-guessing skills.",
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
