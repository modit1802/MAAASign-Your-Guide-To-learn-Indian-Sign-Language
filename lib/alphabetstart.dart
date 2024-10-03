import 'dart:async'; // Import the async package for Timer
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/learnalphabet.dart';
import 'package:flutter_login_signup/practiceassignment1.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class AlphabetStartscreen extends StatefulWidget {
  const AlphabetStartscreen({super.key});

  @override
  State<AlphabetStartscreen> createState() => _AlphabetStartscreenState();
}

class _AlphabetStartscreenState extends State<AlphabetStartscreen> {
  bool _showGif = true; // State variable to control GIF visibility

  @override
  void initState() {
    super.initState();
    _checkGifVisibility(); // Check if the GIF should be shown
    // Start a timer for 10 seconds to hide the GIF automatically
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _showGif = false; // Hide the GIF after 10 seconds
      });
    });
  }

  // Method to check if the GIF has been shown before
  Future<void> _checkGifVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasShownGif = prefs.getBool('hasShownGif'); // Retrieve the value

    // If it has not been shown before, show it and update the value
    if (hasShownGif == null || !hasShownGif) {
      setState(() {
        _showGif = true; // Show the GIF
      });
      await prefs.setBool('hasShownGif', true); // Mark as shown
    } else {
      setState(() {
        _showGif = false; // Do not show the GIF
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 135, 205, 238),
                  Color.fromARGB(255, 250, 163, 213),
                  Colors.white
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              image: DecorationImage(
                image: AssetImage('images/ladder.png'), // Update the image path here
                fit: BoxFit.cover, // Adjust the image to cover the whole area
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnAlphabet()));
                    },
                    child: const SizedBox(
                      width: 300, // Set fixed width
                      height: 100, // Set fixed height
                      child: Card(
                        color: Colors.blueAccent,
                        elevation: 4,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Learn the Alphabets",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Space between the cards
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeAssignment1()));
                    },
                    child: const SizedBox(
                      width: 300,
                      height: 100,
                      child: Card(
                        color: Colors.greenAccent,
                        elevation: 4,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Practice Assignment 1",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnAlphabet()));
                    },
                    child: const SizedBox(
                      width: 300,
                      height: 100,
                      child: Card(
                        color: Colors.redAccent,
                        elevation: 4,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Practice Assignment 2",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnAlphabet()));
                    },
                    child: const SizedBox(
                      width: 300,
                      height: 100,
                      child: Card(
                        color: Colors.orangeAccent,
                        elevation: 4,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Challenger to pass Week 1",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Add the GIF at the center bottom with a close button
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
                  'images/week1screenbeg.gif', // Update the image path here
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
