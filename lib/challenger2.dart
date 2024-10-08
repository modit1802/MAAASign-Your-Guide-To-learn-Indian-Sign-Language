import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'challenger3.dart';

class Challenger2 extends StatelessWidget {
  final int score;
  Challenger2({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
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
  // Solution and letters available
  List<String?> solution = ["wooden", "wooden", "wooden"];
  List<String> availableLetters = ["B", "T", "A", "R"];

  // Mapping each letter to its Cloudinary URL
  final Map<String, String> cloudinaryUrls = {
    "B": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png",
    "T": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png",
    "A": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png",
    "R": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
    "wooden": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png",
  };

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

  // Checking solution logic
  void checkSolution() {
    if (ListEquality().equals(solution, ["B", "A", "T"])) {
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
          // Auto-fill the correct answer after max attempts
          solution = ["B", "A", "T"];
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
                    width: 100,
                    height: 100,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
                    width: 100,
                    height: 100,
                  ),
                ),
              Image.network(
                "https://res.cloudinary.com/dfph32nsq/image/upload/v1727363980/Challenger_2_jrppoz.png",
                width: 300,
                height: 200,
              ),
              // Display the glass-like effect with the image
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
                        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727969908/bat_hhcjp7.png",
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Solution boxes (use Cloudinary images based on selection)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                           setState(() {
    // If the solution slot has a letter, remove it from the solution
    if (solution[index] != "wooden" && solution[index] != null) {
      availableLetters.add(solution[index]!);
      solution[index] = "wooden";  // Just clear the solution without adding "wooden"
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
                                : SizedBox(),
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
              SizedBox(height: 20),
              // Draggable letters (Cloudinary images)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter,
                    child: Image.network(
                      cloudinaryUrls[letter]!,
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
              SizedBox(height: 20),
              // Check button or move to next challenge
              if (!showMoveToNextButton)
                ElevatedButton(
                  onPressed: checkSolution,
                  child: Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Challenger3(score: score)),
                    );
                  },
                  child: Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
        // Displaying remaining attempts and score
        Positioned(
          top: 50,
          right: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Score: $score",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Challenger2(score: 0),
  ));
}
