import 'package:SignEase/Week%202/challenger3.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // for Future.delayed
import 'package:collection/collection.dart';
class Challenger2 extends StatelessWidget {
  final int score;

  Challenger2({required this.score});

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
              Color.fromARGB(255, 255, 150, 250),
              Color.fromARGB(255, 159, 223, 252),
              Colors.white
            ],
          ),
        ),
        child: ThirdGame(score: score),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score;

  ThirdGame({required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  List<String?> solution = [
    "wooden",
    "wooden",
    "wooden"
  ]; // Initialize with placeholders
  final Map<String, String> cloudinaryUrls = {
    "B":
        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png",
    "T":
        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png",
    "A":
        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png",
    "R":
        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
    'bat':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969908/bat_hhcjp7.png',
    'correct':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
    'wrong':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
    'wooden':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
  };

  List<String> availableLetters = ["B", "T", "A", "R"];
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  bool showMoveToNextButton = false;
  late int score;
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  @override
  void initState() {
    super.initState();
    score = widget.score;
  }

  void checkSolution() {
    if (ListEquality().equals(solution, ["B", "A", "T"])) {
      setState(() {
        isCorrectSolution = true;
        showMoveToNextButton = true;
        if (attempts == 0) {
          score += 100;
        } else if (attempts == 1) {
          score += 50;
        } else if (attempts == 2) {
          score += 25;
        }
      });
      _scrollToGif();
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Challenger3(score: score),
          ),
        );
      });
    } else {
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          solution = ["B", "A", "T"];
          isCorrectSolution = false;
          showMoveToNextButton = false;
          score = 0;
        } else {
          isCorrectSolution = false;
          showMoveToNextButton = false;
        }
      });
      _scrollToGif(); // Trigger scrolling to wrong.gif
    }
  }

  // Function to handle scrolling up to the wrong.gif and then back down
  void _scrollToGif() async {
    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent, // Scroll to top
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );

    // Wait for 2 seconds while showing the wrong.gif
    await Future.delayed(const Duration(seconds: 1));

    // Scroll back down
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller:
              _scrollController, // Assign ScrollController to the scroll view
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    cloudinaryUrls['correct']!, // Correct gif from Cloudinary
                    width: 300,
                    height: 200,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    cloudinaryUrls['wrong']!, // Wrong gif from Cloudinary
                    width: 300,
                    height: 200,
                  ),
                ),
              Image.network(
                "https://res.cloudinary.com/dfph32nsq/image/upload/v1727363980/Challenger_2_jrppoz.png",
                width: 300,
                height: 200,
              ),
              // First Image with Card
              Stack(
                alignment: Alignment.center,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        cloudinaryUrls['bat']!,
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != "wooden" &&
                                solution[index] != null) {
                              availableLetters.add(solution[index]!);
                              solution[index] = "wooden"; // Clear letter
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: solution[index] != null
                                ? Image.network(
                                    cloudinaryUrls[solution[index]!]!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        if (solution[index] != "wooden" &&
                            solution[index] != null) {
                          // If the target already has a letter, move it back to availableLetters
                          availableLetters.add(solution[index]!);
                        }
                        solution[index] = data;
                        availableLetters.remove(
                            data); // Remove the newly placed letter from options
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter,
                    child: Image.network(
                      cloudinaryUrls[letter]!, // Cloudinary URL for the letter
                      width: 80,
                      height: 80,
                    ),
                    feedback: Material(
                      child: Image.network(
                        cloudinaryUrls[letter]!,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    childWhenDragging: Container(),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (!showMoveToNextButton)
                ElevatedButton(
                  onPressed: checkSolution,
                  child: const Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Challenger3(
                            score: score), // Navigate to next challenge
                      ),
                    );
                  },
                  child: const Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance Left",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
