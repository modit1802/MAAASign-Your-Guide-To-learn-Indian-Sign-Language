import 'package:flutter/material.dart';
import 'dart:async'; // for Future.delayed
import 'challenger2.dart';
import 'package:collection/collection.dart';

class Thirdstep extends StatelessWidget {
  final int score;

  Thirdstep({required this.score});

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
  List<String?> solution = ["wooden", "wooden", "wooden"]; // Initialize with placeholders
  final Map<String, String> cloudinaryUrls = {
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
    'R': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/W_bkgjob.png',
    'cow': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/cow_acsn7t.png',
    'correct': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
    'wrong': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
    'wooden': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
  };

  List<String> availableLetters = ["O", "C", "R", "W"];
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  bool showMoveToNextButton = false;
  late int score;
  final ScrollController _scrollController = ScrollController(); // Add ScrollController

  @override
  void initState() {
    super.initState();
    score = widget.score;
  }

  void checkSolution() {
    if (ListEquality().equals(solution, ["C", "O", "W"])) {
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
    } else {
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          solution = ["C", "O", "W"];
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
          controller: _scrollController, // Assign ScrollController to the scroll view
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    cloudinaryUrls['correct']!, // Correct gif from Cloudinary
                    width: 100,
                    height: 100,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    cloudinaryUrls['wrong']!, // Wrong gif from Cloudinary
                    width: 100,
                    height: 100,
                  ),
                ),
              Image.network(
                "https://res.cloudinary.com/dfph32nsq/image/upload/v1727363979/Challenger_1_nmp9hp.png",
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
                        cloudinaryUrls['cow']!,
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
                        availableLetters.remove(data); // Remove the newly placed letter from options
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
                        builder: (context) =>
                            Challenger2(score: score), // Navigate to next challenge
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
