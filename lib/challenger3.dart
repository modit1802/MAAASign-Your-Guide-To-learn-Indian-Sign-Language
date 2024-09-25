import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'challenger4.dart';

class Challenger3 extends StatelessWidget {
  final int score;
  const Challenger3({super.key, required this.score});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Move Forward'),
        backgroundColor: const Color.fromARGB(255, 207, 238, 252),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
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
  const ThirdGame({super.key, required this.score});
  
  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  List<String?> solution = [
    "wooden",
    "wooden",
    "wooden",
    "wooden"
  ]; // Initialize with null
  List<String> availableLetters = [
    "F",
    "I",
    "S",
    "H"
  ]; // Four alphabets to choose from
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  bool showMoveToNextButton = false;
  late int score;
  
  @override
  void initState() {
    super.initState();
    score = widget.score;
  }
  
  void checkSolution() {
    if (const ListEquality().equals(solution, ["F", "I", "S", "H"])) {
      // Correct solution
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
      // Incorrect solution
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          // If the maximum attempts are reached, place F, I, S, H automatically
          solution[0] = "F";
          solution[1] = "I";
          solution[2] = "S";
          solution[3] = "H";
          isCorrectSolution = false;
          showMoveToNextButton = false;
        } else {
          isCorrectSolution = false;
          showMoveToNextButton = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    "images/correct.gif", // Path to correct.gif
                    width: 100,
                    height: 100,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    "images/wrong.gif", // Path to wrong.gif
                    width: 100,
                    height: 100,
                  ),
                ),
              Image.asset("images/Challenger_3.png", width: 300, height: 200),
              // Display the fish image
              Stack(
                alignment: Alignment.center,
                children: [
                  // Elevated glass-like card containing the fish image
                  Material(
                    elevation: 4, // Adjust elevation as needed
                    borderRadius: BorderRadius.circular(
                        20), // Adjust border radius as needed
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors
                            .transparent, // Increased opacity for a more transparent effect
                        borderRadius: BorderRadius.circular(
                            20), // Same border radius as the Material widget
                      ),
                      child: Image.asset("images/fish.png",
                          width: 180, height: 180),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Display the boxes for F, I, S, and H
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != null) {
                              availableLetters.add(solution[
                                  index]!); // Add the alphabet back to options list
                              solution[index] =
                                  "wooden"; // Set the solution box back to null
                            }
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            // ClipRRect to ensure rounded corners
                            borderRadius: BorderRadius.circular(12),
                            child: solution[index] != null
                                ? Image.asset(
                                    "images/${solution[index]}.png",
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ) // Render the image if available
                                : const SizedBox(), // Render nothing if no image is set
                          ),
                        ),
                      );
                    },
                    onWillAcceptWithDetails: (data) => true,
                    onAcceptWithDetails: (data) {
                      setState(() {
                        if (index >= 0 && index < solution.length) {
                          solution[index] =
                              data; // Set the alphabet in the solution
                          availableLetters
                              .remove(data); // Remove the alphabet from options
                        }
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Display the draggable alphabet images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter, // Adjusted path and size
                    feedback: Material(
                      child: Image.asset("images/$letter.png",
                          width: 60, height: 60), // Adjusted path and size
                    ),
                    childWhenDragging: Container(),
                    child: Image.asset("images/$letter.png",
                        width: 60, height: 60),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Display the "Check Now" or "Move to Next Challenge" button
              if (!showMoveToNextButton)
                ElevatedButton(
                  onPressed: checkSolution,
                  child: const Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next challenge
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Challenger4(score:score)));
                  },
                  child: const Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 16,
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

void main() {
  runApp(const MaterialApp(
    home: Challenger3(score: 0),
  ));
}
