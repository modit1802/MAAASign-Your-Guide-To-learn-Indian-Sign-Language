import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/Initial_page_1.dart';
import 'package:flutter_login_signup/alphabetstart.dart';
import 'package:flutter_login_signup/numberstartscreen.dart'; // Import the number screen// Import the quiz screen
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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
    _checkFirstLaunch(); // Check if this is the first launch

    // Timer to hide the teacher image
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        showTeacherImage = false;
      });
    });

    // Timer to hide the GIF after 10 seconds
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _showGif = false; // Hide the GIF after 10 seconds
      });
    });
  }

  // Check if the GIF should be shown
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');

    if (isFirstLaunch == null || isFirstLaunch) {
      // This is the first launch or the value is null
      setState(() {
        _showGif = true;
      });
      // Set the preference to false so that GIF is not shown next time
      await prefs.setBool('isFirstLaunch', false);
    } else {
      // Not the first launch, hide the GIF
      setState(() {
        _showGif = false;
      });
    }
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 219, 69, 249),
            Color.fromARGB(255, 135, 205, 238),
          ],
        ),
      ),
    );
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
              color: Colors.black.withOpacity(0.5),
              // Black overlay with opacity
            ),
          if (_showGif)
            Positioned(
              bottom: 20, // Position it at the bottom of the screen
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'images/teacher2.gif', // Update the image path here
                  height: 300, // Set the height of the GIF
                  fit: BoxFit.contain, // Adjust how the GIF is displayed
                ),
              ),
            ),
          if (_showGif)
            Positioned(
              bottom: 320, // Position close button at the top of the screen
              right: 20, // Align to the right side
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showGif = false; // Hide the GIF when the close button is pressed
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white, // White cross icon for the close button
                ),
              ),
            ),
        ],
      ),
    );
  }
}
