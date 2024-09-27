import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'challenger5.dart';

class Challenger4 extends StatelessWidget {
  final int score;
  Challenger4({required this.score});

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
  ThirdGame({required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  List<String?> solution = ["wooden", "wooden", "wooden"];
  List<String> availableLetters = ["B", "O", "X", "R"];

  // Cloudinary URLs for each letter and placeholder
  final Map<String, String> cloudinaryUrls = {
    "B": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png",
    "O": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png",
    "X": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/X_kedszo.png",
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

  void checkSolution() {
    if (const ListEquality().equals(solution, ["B", "O", "X"])) {
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
          solution = ["B", "O", "X"];
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
                "https://res.cloudinary.com/dfph32nsq/image/upload/v1727363980/Challenger_4_bjnmkr.png",
                width: 300,
                height: 200,
              ),
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
                        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727364017/box_vfvohv.png",
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != null) {
                              availableLetters.add(solution[index]!);
                              solution[index] = "wooden";
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
                        if (index >= 0 && index < solution.length) {
                          solution[index] = data;
                          availableLetters.remove(data);
                        }
                      });
                    },
                  );
                }),
              ),

              SizedBox(height: 20),
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
                        builder: (context) => Challenger5(score: score),
                      ),
                    );
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
  runApp(MaterialApp(
    home: Challenger4(score: 0),
  ));
}
