import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/thirdstepchallengerfornumbers.dart';

class MoveForwardtonumbers extends StatelessWidget {
  final int score; // Add a parameter to accept the score

  const MoveForwardtonumbers
  ({super.key, required this.score}); // Constructor to receive the score

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 207, 238, 252),
        title: const Text('Move Forward to Numbers Match'),
        actions: [
          IconButton(
            icon: Image.asset(
              'images/trophy.png', // Replace 'path/to/trophy.png' with the actual path to your trophy image
              width: 50, // Adjust the size as needed
              height: 50,
            ),
            onPressed: () {
              // Define the action for trophy icon press
              // For example: Show achievements or leaderboards
              // You can replace this with your desired functionality
            },
          ),
        ],
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
        child: AlphabetFruitMatch(score: score), // Pass the score to the widget
      ),
    );
  }
}

class AlphabetFruitMatch extends StatefulWidget {
  final int score; // Add a parameter to accept the score

  const AlphabetFruitMatch({super.key, required this.score}); // Constructor to receive the score

  @override
  _AlphabetFruitMatchState createState() => _AlphabetFruitMatchState();
}

class _AlphabetFruitMatchState extends State<AlphabetFruitMatch>
    with SingleTickerProviderStateMixin {
  List<String> alphabetList = ['1', '2', '4', '5', '6'];
  Map<String, String> matches = {
    '1': 'teddy',
    '2': 'banana',
    '4': 'icecream',
    '5': 'five',
    '6': 'boys',
  };
  Map<String, String> images = {
   '1': 'teddy.png',
    '2': 'banana.png',
    '4': 'icecream.png',
    '5': 'five.png',
    '6': 'boys.png',

  };
  late int score; // Declare score variable
  bool showRibbon = false;
  bool showNextStepButton =
      false; // Flag to control the visibility of the button
  late AnimationController _controller;
  late Timer _ribbonTimer;
  late Timer _buttonTimer;
  bool showMagicEffect = false; // Flag to track whether the magic effect is shown

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    score = widget.score; // Initialize score with the received score
  }

  @override
  void dispose() {
    _controller.dispose();
    _ribbonTimer.cancel(); // Cancel the ribbon timer when disposing the widget
    _buttonTimer.cancel(); // Cancel the button timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Score: $score', // Display the score
                style: const TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: alphabetList
                            .map((alphabet) => Draggable<String>(
                                  data: alphabet,
                                  feedback: Image.asset(
                                    'images/$alphabet.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  childWhenDragging: Container(),
                                  child: Image.asset(
                                    'images/$alphabet.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: DragTarget<String>(
                          builder: (context, accepted, rejected) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: matches.entries.map((entry) {
                                return DragTarget<String>(
                                  builder: (context, accepted, rejected) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 16.0),
                                      child: accepted == entry.key
                                          ? Image.asset(
                                              'images/${images[entry.key]}',
                                              width: 100,
                                              height: 100,
                                            )
                                          : Draggable<String>(
                                              data: entry.key,
                                              feedback: Image.asset(
                                                'images/${images[entry.key]}',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              childWhenDragging: Container(),
                                              child: Image.asset(
                                                'images/${images[entry.key]}',
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                    );
                                  },
                                  onWillAcceptWithDetails: (data) => true,
                                  onAcceptWithDetails: (data) {
                                    if (matches[data] == entry.value) {
                                      setState(() {
                                        score = score + 100;
                                        alphabetList.remove(data);
                                        matches.remove(entry.key);
                                        if (alphabetList.isEmpty) {
                                          _completeGame();
                                        }
                                      });
                                      if (!_controller.isAnimating) {
                                        _controller.reset();
                                        _controller.forward();
                                      }
                                      setState(() {
                                        showMagicEffect = true;
                                      });
                                      Future.delayed(const Duration(seconds: 1), () {
                                        setState(() {
                                          showMagicEffect = false;
                                        });
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          },
                          onWillAcceptWithDetails: (data) => true,
                          onAcceptWithDetails: (data) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showRibbon) const RibbonWidget(),
        if (showNextStepButton)
          Positioned(
            bottom: 20,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(108.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action to perform when button is pressed
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Thirdstepchallengersfornumbers(score:score)));
                  },
                  child: const Text('Move to next step'),
                ),
              ),
            ),
          ),
        if (showMagicEffect)
          Positioned.fill(
            child: Image.asset(
              'images/star.gif',
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  void _completeGame() {
    setState(() {
      showRibbon = true;
      showNextStepButton = true; // Set the flag to true when game is completed
    });
    _controller.forward();
    _ribbonTimer = Timer(const Duration(seconds: 10), () {
      // Start a timer to hide the ribbon after 10 seconds
      setState(() {
        showRibbon = false;
      });
    });
    _buttonTimer = Timer(const Duration(seconds: 20), () {
      // Start a timer to hide the button after 20 seconds
      setState(() {
        showNextStepButton = false;
      });
    });
  }
}

class RibbonWidget extends StatelessWidget {
  const RibbonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'images/ribbon.gif',
        fit: BoxFit.cover,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MoveForwardtonumbers(score: 0), // Pass the initial score
  ));
}
