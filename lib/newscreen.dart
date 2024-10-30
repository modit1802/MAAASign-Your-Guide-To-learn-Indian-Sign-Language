
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/alphabetstart.dart';
import 'package:SignEase/numberstartscreen.dart'; // Import the number screen// Import the quiz screen// Import SharedPreferences

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool showTeacherImage = true;
  bool _showGif = true;

  @override
  void initState() {
    super.initState();

  }
 

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 255, 86, 247),
              Color.fromARGB(255, 105, 207, 255),
              Colors.white
                ],
                stops: [0.0, 0.5, 1.0]
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column for alphabet and number circle widgets
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      // Alphabet Circle widget
                      GestureDetector(
                        onTap: () {
                          // Navigate to the AlphabetScreen when the alphabet image is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AlphabetStartscreen()), // Correct way to navigate to AlphabetStartscreen
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: 250.0,
                          width: 250.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/alphabet.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Number Circle widget
                      GestureDetector(
                        onTap: () {
                          // Navigate to the NumberScreen when the number image is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NumberStartScreen()), // Change to your number screen
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: 250,
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/number.jpeg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  // Column for teacher2.gif image
                ],
              ),
            ),
          ),
          // Custom buttons at the top center (Home, Score, Test, About)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                        Icons.home,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                        Icons.score,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                        Icons.assignment,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                        Icons.info,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showGif)
            Container(
              color: Colors.black.withOpacity(0.92),
              // Black overlay with opacity
            ),
          if (_showGif)
            Center(
              child: Positioned(
                child: Center(
                  child: Image.asset(
                    'images/teacher2.gif', // Update the image path here
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
