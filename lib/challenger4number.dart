import 'package:flutter/material.dart';
import 'package:flutter_login_signup/numberfinal.dart';

class Challenger4Image extends StatelessWidget {
  final int score; // Accept score from the previous screen

  Challenger4Image({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Move Forward"),
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
              Colors.white
            ],
          ),
        ),
        child: Center(
          child: ThirdGame(score: score),
        ),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score; // Accept score from the previous screen

  ThirdGame({required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  String? solution; // Store the solution
  List<String> availableNumbers = ["2", "1", "9", "7"]; // Available numbers
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  late int score; // Initialize score
  bool buttonClicked = false; // Track if the button has been clicked

  @override
  void initState() {
    super.initState();
    // Set the score to the initial score received from the previous screen
    score = widget.score;
  }

  void checkSolution() {
    if (solution == "2") {
      // Correct solution
      setState(() {
        isCorrectSolution = true;
        buttonClicked = true; // Set buttonClicked to true when solution is correct
        score += 100; // Increase score on correct solution
      });
    } else {
      // Incorrect solution
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          // If the maximum attempts are reached, reset score
          score = 0;
          solution = "2"; // Set solution to correct answer after max attempts
        }
        isCorrectSolution = false;
      });
    }
  }

  void moveForward() {
    // Navigate to next screen or perform any action you want when solution is correct
    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => numberfinal(score:score,)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isCorrectSolution != null && isCorrectSolution!)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                "images/correct.gif", // Path to correct.gif
                width: 100,
                height: 100,
              ),
            ),
          if (isCorrectSolution != null && !isCorrectSolution!)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                "images/wrong.gif", // Path to wrong.gif
                width: 100,
                height: 100,
              ),
            ),
          Image.asset(
            "images/two.png",
            width: 300,
            height: 200,
          ),
          SizedBox(height: 20),
          // Display the box for solution
          GestureDetector(
            onTap: () {
              setState(() {
                if (solution != null) {
                  availableNumbers.add(solution!); // Add number back to options list
                  solution = null; // Clear solution
                }
              });
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              alignment: Alignment.center,
              child: solution != null
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        "images/$solution.png",
                        fit: BoxFit.contain,
                      ),
                    ) // Render dropped image
                  : SizedBox(), // Render nothing if no image is dropped
            ),
          ),
          SizedBox(height: 20),
          // Display draggable number cards
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableNumbers.map((number) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (solution == null) {
                      solution = number; // Update solution
                      availableNumbers.remove(number); // Remove selected number
                    }
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Material(
                    elevation: 5, // Increase elevation
                    borderRadius: BorderRadius.circular(12), // Round corners
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Round corners
                      child: Image.asset(
                        "images/$number.png",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Display "Check Solution" or "Move Forward" button based on solution
          if (!buttonClicked)
            ElevatedButton(
              onPressed: checkSolution,
              child: Text("Check Solution"),
            ),
          if (isCorrectSolution != null && isCorrectSolution! && buttonClicked)
            ElevatedButton(
              onPressed: moveForward,
              child: Text("Move Forward"),
            ),
          SizedBox(height: 20),
          // Display score and remaining attempts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Score: $score",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${maxAttempts - attempts} Chance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Challenger4Image(score:0), // Provide the initial score here
  ));
}
