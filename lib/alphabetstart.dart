import 'package:flutter/material.dart';
import 'package:flutter_login_signup/learnalphabet.dart';
import 'package:flutter_login_signup/practiceassignment1.dart';

class AlphabetStartscreen extends StatefulWidget {
  const AlphabetStartscreen({super.key});

  @override
  State<AlphabetStartscreen> createState() => _AlphabetStartscreenState();
}

class _AlphabetStartscreenState extends State<AlphabetStartscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  width: 250,  // Set fixed width
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
              const SizedBox(height: 16),  // Space between the cards
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeAssignment1()));
                },
                child: const SizedBox(
                  width: 250,
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
                  width: 250,
                  height: 100,
                  child: Card(
                    color: Colors.redAccent,
                    elevation: 4,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Practice assignment 2",
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
                  width: 250,
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
            ],
          ),
        ),
      ),
    );
  }
}
