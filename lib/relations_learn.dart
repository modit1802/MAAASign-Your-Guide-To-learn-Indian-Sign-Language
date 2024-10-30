import 'package:flutter/material.dart';
import 'package:SignEase/simplerelations.dart';
import 'package:SignEase/compoundrelations.dart';

class SentenceStartscreen extends StatefulWidget {
  const SentenceStartscreen({super.key});

  @override
  State<SentenceStartscreen> createState() => _SentenceStartscreenState();
}

class _SentenceStartscreenState extends State<SentenceStartscreen> {
  bool _showGif = true; // State variable to control GIF visibility

  @override
  void initState() {
    super.initState();
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
                  Color.fromARGB(255, 255, 150, 250),
                  Color.fromARGB(255, 159, 223, 252),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SimpleRelations()));
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
                              "Simple Relations",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CompoundRelations()));
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
                              "Compound Relations",
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
        ],
      ),
    );
  }
}
