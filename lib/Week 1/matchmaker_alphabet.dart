import 'dart:async';
import 'package:SignEase/Week%201/Tutorial_screen_for_challenger_matchmaker.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Match_maker_alphabet extends StatelessWidget {
  final int score;

  const Match_maker_alphabet({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 233, 215),
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            AlphabetFruitMatch(score: score), // Pass the score to the widget
            // Circular Home Button
            Positioned(
              top: 40,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 252, 133, 37),
                foregroundColor: Colors.white,
                onPressed: () {
                  // Navigate to the initial page (modify as needed)
                  Navigator.pop(context); // Replace with your initial page
                },
                child: const Icon(Icons.home), // Home icon
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlphabetFruitMatch extends StatefulWidget {
  final int score;

  const AlphabetFruitMatch({super.key, required this.score});

  @override
  _AlphabetFruitMatchState createState() => _AlphabetFruitMatchState();
}

class _AlphabetFruitMatchState extends State<AlphabetFruitMatch> with SingleTickerProviderStateMixin {
  late int score;
  late AnimationController _controller;
  late Timer _ribbonTimer;
  late Timer _buttonTimer;
  bool showRibbon = false;
  bool showNextStepButton = false;
  bool showMagicEffect = false;

  List<String> alphabetList = ['O', 'K', 'C', 'D', 'E'];
  Map<String, String> matches = {
    'O': 'Orange',
    'K': 'Kite',
    'C': 'Candy',
    'D': 'Dog',
    'E': 'Egg',
  };

  Map<String, String> images = {
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png',
  };

  Map<String, String> images2 = {
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346884/kite_t2qkvv.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969891/cherry_hsxug7.png',
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/orange_jvyqo7.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/dog_rlu4zj.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346883/egg_owyxyy.png',
  };

  // A map to track which images have been matched
  Map<String, bool> matchedItems = {
    'O': false,
    'K': false,
    'C': false,
    'D': false,
    'E': false,
  };

  @override
  void initState() {
    super.initState();
    // Initialize the score first
    score = widget.score;
        WidgetsBinding.instance.addPostFrameCallback((_) {
      _showtutorialscreen();
    });

    alphabetList.shuffle(Random());

    // Shuffle the right side (matches keys)
    var shuffledKeys = matches.keys.toList()..shuffle(Random());
    matches = Map.fromEntries(shuffledKeys.map((key) => MapEntry(key, matches[key]!)));
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Set your desired duration
    );

    // Initialize the timers
    //_ribbonTimer = Timer(Duration.zero, () {});
    //_buttonTimer = Timer(Duration.zero, () {});

    // Example of how to show ribbons (you can set the time according to your need)
    
  }

    void _showtutorialscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tutorial_screen_for_challenger_matchmaker(
          onBackPressed: () {
            Navigator.pop(
                context); // Return to the current screen on back press
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    _ribbonTimer.cancel(); // Ensure timer is canceled
    _buttonTimer.cancel();
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
            const SizedBox(height: 50),
            Container(
              height: 60,
              width: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Score: $score",
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: alphabetList
                          .map(
                            (alphabet) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Draggable<String>(
                                data: alphabet,
                                feedback: Image.network(
                                  images[alphabet]!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                childWhenDragging: Container(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Visibility(
                                      visible: !matchedItems[alphabet]!,
                                      child: Image.network(
                                        images[alphabet]!,
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: matches.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: DragTarget<String>(
                              builder: (context, accepted, rejected) {
                                return Column(
                                  children: [
                                    Text(entry.value),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          images2[entry.key]!,
                                          width: 90,
                                          height: 90,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              onWillAccept: (data) => data == entry.key,
                              onAccept: (data) {
                                if (data == entry.key) {
                                  setState(() {
                                    score += 100;
                                    alphabetList.remove(data);
                                    matches.remove(entry.key);
                                    if (alphabetList.isEmpty) {
                                      _completeGame();
                                    }
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
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
        Padding(
          padding: const EdgeInsets.all(108.0),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 252, 133, 37),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Back button with icon
              },
              child: const Icon(Icons.arrow_back), // Back icon
            ),
          ),
        ),
      Positioned(
        bottom: 10,
        left: 20,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 252, 133, 37),
            foregroundColor: Colors.white,
          ),
          onPressed: _skipAllAnimations,
          child: const Text('Skip'),
        ),
      ),
    ],
  );
}
 
  void _skipAllAnimations() {
    // Simulate dropping all items one by one without increasing score
    Future.forEach(alphabetList.toList(), (alphabet) async {
      await Future.delayed(const Duration(seconds: 1)); // Delay for animation effect
      setState(() {
        alphabetList.remove(alphabet);
        matches.remove(alphabet);
        if (alphabetList.isEmpty) {
          _completeGame();
        }
      });
    });
  }

  void _completeGame() {
    if (mounted) {
  setState(() {
    showRibbon = true;
    showNextStepButton = true;
  });
}
    _controller.forward();
    _ribbonTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showRibbon = false;
      });
    });
    _buttonTimer = Timer(const Duration(seconds: 4), () {
      setState(() {
        showNextStepButton = false;
        Navigator.pop(context); // Automatically navigate back after completing the game
      });
    });
  }
}

class RibbonWidget extends StatelessWidget {
  const RibbonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: Color.fromARGB(255, 16, 161, 0),
      child: const Center(
        child: Text(
          'Congratulations!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
