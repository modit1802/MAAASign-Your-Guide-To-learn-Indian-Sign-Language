
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Week 2/learnalphabet.dart';
import 'package:flutter_login_signup/Week 2/moveforward.dart';
import 'package:flutter_login_signup/Week 2/practiceassignment1.dart';
import 'package:flutter_login_signup/Week 2/thirdstep.dart';

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
  }

  // Method to check if the GIF has been shown before
 

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
              Color.fromARGB(255, 255, 150, 250),
              Color.fromARGB(255, 159, 223, 252),
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
                              "Learn Greetings",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MoveForward(score: 0)));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Thirdstep(score: 0,)));
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
                              "Challenger to pass Greetings",
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
