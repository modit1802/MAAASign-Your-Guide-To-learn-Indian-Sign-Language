import 'dart:async';
import 'package:flutter/material.dart';

class MoveForward extends StatelessWidget {
  final int score;

  const MoveForward({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
        child: Stack(
          children: [
            AlphabetFruitMatch(score: score), // Pass the score to the widget
            // Circular Home Button
            Positioned(
              top: 40,
              left: 20,
              child: FloatingActionButton(
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

class _AlphabetFruitMatchState extends State<AlphabetFruitMatch>
    with SingleTickerProviderStateMixin {
  List<String> alphabetList = ['O', 'K', 'C', 'D', 'E'];
  Map<String, String> matches = {
    'O': 'Orange',
    'K': 'Kite',
    'C': 'Cherry',
    'D': 'Dog',
    'E': 'Egg',
  };

  // Replace image paths with corresponding URLs
  Map<String, String> images = {
    'O':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
    'K':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png',
    'C':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
    'D':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png',
    'E':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png',
  };
  Map<String, String> images2 = {
    'O':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/orange_jvyqo7.png',
    'K':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346884/kite_t2qkvv.png',
    'C':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969891/cherry_hsxug7.png',
    'D':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/dog_rlu4zj.png',
    'E':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346883/egg_owyxyy.png',
  };
  late int score;
  bool showRibbon = false;
  bool showNextStepButton = false;
  late AnimationController _controller;
  late Timer _ribbonTimer;
  late Timer _buttonTimer;
  bool showMagicEffect = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    score = widget.score;
  }

  @override
  void dispose() {
    _controller.dispose();
    _ribbonTimer.cancel();
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
              Text(
                'Score: $score',
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
                            .map((alphabet) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Space between images
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
                                        child: Image.network(
                                          images[alphabet]!,
                                          width: 90,
                                          height: 90,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
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
                                          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)), // Border for card effect
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
                                onWillAccept: (data) {
                                  return data == entry.key;
                                },
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
          Center(
            child: Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.all(108.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Back button with icon
                  },
                  child: const Icon(Icons.arrow_back), // Back icon
                ),
              ),
            ),
          ),
        if (showMagicEffect)
          Positioned.fill(
            child: Image.network(
              'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345820/star_cpjyys.gif', // Replace with your star effect URL
              fit: BoxFit.cover,
            ),
          ),
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
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
    setState(() {
      showRibbon = true;
      showNextStepButton = true;
    });
    _controller.forward();
    _ribbonTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        showRibbon = false;
      });
    });
    _buttonTimer = Timer(const Duration(seconds: 5), () {
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
