import 'dart:async';
import 'package:flutter/material.dart';
import 'thirdstep.dart';

class MoveForward extends StatelessWidget {
  final int score;

  const MoveForward({super.key, required this.score});

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
        title: const Text('Move Forward'),
        actions: [
          IconButton(
            icon: Image.network(
              'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345720/trophy_obnjfz.png', // Replace with your trophy image URL
              width: 50, // Adjust the size as needed
              height: 50,
            ),
            onPressed: () {
              // Define the action for trophy icon press
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
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png',
  };
  Map<String, String> images2 = {
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346887/orange_fqmwtr.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346884/kite_t2qkvv.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346881/cherry_awgcoa.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346882/dog_ju2ibt.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727346883/egg_owyxyy.png',
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
              const SizedBox(height: 20),
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
                            .map((alphabet) => Draggable<String>(
                          data: alphabet,
                          feedback: Image.network(
                            images[alphabet]!, // Use the image URL from the map
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          childWhenDragging: Container(),
                          child: Image.network(
                            images[alphabet]!, // Use the image URL from the map
                            width: 100,
                            height: 100,
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
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: DragTarget<String>(
                                builder: (context, accepted, rejected) {
                                  return Column(
                                    children: [
                                      Text(entry.value),
                                      Image.network(
                                        images2[entry.key]!, // Target image
                                        width: 100,
                                        height: 100,
                                      ),
                                    ],
                                  );
                                },
                                onWillAccept: (data) {
                                  // Check if the dragged item matches the target
                                  return data == entry.key;
                                },
                                onAccept: (data) {
                                  if (data == entry.key) {
                                    setState(() {
                                      score += 100;
                                      alphabetList.remove(data); // Remove matched item
                                      matches.remove(entry.key); // Remove matched pair
                                      if (alphabetList.isEmpty) {
                                        _completeGame(); // Call game completion logic
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
          Positioned(
            bottom: 20,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(108.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Thirdstep(score: score)));
                  },
                  child: const Text('Move to next step'),
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
      ],
    );
  }

  void _completeGame() {
    setState(() {
      showRibbon = true;
      showNextStepButton = true;
    });
    _controller.forward();
    _ribbonTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        showRibbon = false;
      });
    });
    _buttonTimer = Timer(const Duration(seconds: 20), () {
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
      child: Image.network(
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345841/ribbon_i1czrh.gif', // Replace with your ribbon GIF URL
        fit: BoxFit.cover,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MoveForward(score: 0),
  ));
}
