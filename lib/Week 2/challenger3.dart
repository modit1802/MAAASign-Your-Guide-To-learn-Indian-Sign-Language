import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'challenger4.dart';

class Challenger3 extends StatelessWidget {
  final int score;
  Challenger3({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move Forward'),
        backgroundColor: Color.fromARGB(255, 207, 238, 252),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white,
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
  List<String> availableLetters = ["D", "G", "O", "H"];

  // Cloudinary URLs
  final Map<String, String> cloudinaryUrls = {
    "D": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png",
    "G": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png",
    "O": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png",
    "H": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/H_hv5qdm.png",
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

  // Solution checking logic
  void checkSolution() {
    if (ListEquality().equals(solution, ["D", "O", "G"])) {
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
          solution = ["D", "O", "G"];
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
                "https://res.cloudinary.com/dfph32nsq/image/upload/v1727363980/Challenger_3_senbky.png",
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
                        "https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/dog_rlu4zj.png",
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Solution boxes with Cloudinary images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(onTap: () {
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
                        builder: (context) => Challenger4(score: score),
                      ),
                    );
                  },
                  child: Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
        // Remaining attempts and score
        Positioned(
          top: 16,
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
          top: 16,
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
    home: Challenger3(score: 0),
  ));
}
