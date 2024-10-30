import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Challengers%20For%20Week%201/challengernumbers/challenger1number.dart';

class MoveForwardtonumbers extends StatelessWidget {
  final int score;

  const MoveForwardtonumbers({super.key, required this.score});

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
            icon: Image.network(
              'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345720/trophy_obnjfz.png', // Cloudinary URL for trophy image
              width: 50,
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
              Colors.white,
            ],
          ),
        ),
        child: AlphabetFruitMatch(score: score),
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
  // List of numbers that will be draggable
  List<String> alphabetList = ['1', '2', '4', '5', '6'];

  // Matching logic for each number and object
  Map<String, String> matches = {
    '1': 'teddy',
    '2': 'banana',
    '4': 'icecream',
    '5': 'five',
    '6': 'boys',
  };

  // Cloudinary URLs for the number images (left-side)
  Map<String, String> numberImages = {
    '1': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/1_tlz5st.png',
    '2': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png',
    '4': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/4_xzh3hq.png',
    '5': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/5_vno5r2.png',
    '6': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/6_okwpzy.png',
  };

  // Cloudinary URLs for the matching images (right-side)
  Map<String, String> objectImages = {
    '1': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717827/teddy_ztzcst.png',
    '2': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717826/banana_djgdle.png',
    '4': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717830/icecream_ceyf4o.png',
    '5': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717826/five_a64ptj.png',
    '6': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717828/boys_ghv7pn.png',
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
                    // Draggable numbers (left side)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: alphabetList
                            .map((alphabet) => Draggable<String>(
                          data: alphabet,
                          feedback: Image.network(
                            numberImages[alphabet]!, // Use Cloudinary number image
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          childWhenDragging: Container(),
                          child: Image.network(
                            numberImages[alphabet]!, // Use Cloudinary number image
                            width: 100,
                            height: 100,
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    // Drop targets for the matching objects (right side)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: matches.entries.map((entry) {
                            return DragTarget<String>(
                              builder: (context, accepted, rejected) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Image.network(
                                    objectImages[entry.key]!, // Use Cloudinary object image
                                    width: 100,
                                    height: 100,
                                  ),
                                );
                              },
                              onWillAccept: (data) => data == entry.key,
                              onAccept: (data) {
                                if (data == entry.key) {
                                  setState(() {
                                    score += 100; // Increment score
                                    alphabetList.remove(data); // Remove from left side
                                    matches.remove(entry.key); // Remove from right side
                                    if (alphabetList.isEmpty) {
                                      _completeGame(); // Check if game is complete
                                    }
                                  });
                                  _controller.forward();
                                  setState(() {
                                    showMagicEffect = true; // Show magic effect
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Challenger1Number(score: score)),
                    );
                  },
                  child: const Text('Move to next step'),
                ),
              ),
            ),
          ),
        if (showMagicEffect)
          Positioned.fill(
            child: Image.network(
              'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345820/star_cpjyys.gif', // Cloudinary URL for magic effect (GIF)
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  void _completeGame() {
    setState(() {
      showRibbon = true;
      showNextStepButton = true; // Show the next step button
    });
    _controller.forward();
    _ribbonTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        showRibbon = false; // Hide the ribbon after 10 seconds
      });
    });
    _buttonTimer = Timer(const Duration(seconds: 20), () {
      setState(() {
        showNextStepButton = false; // Hide the button after 20 seconds
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
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727345841/ribbon_i1czrh.gif', // Cloudinary URL for ribbon GIF
        fit: BoxFit.cover,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MoveForwardtonumbers(score: 0), // Initial score
  ));
}
