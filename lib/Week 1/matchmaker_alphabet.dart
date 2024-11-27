import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class MatchMakerGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlphabetGameNavigator(),
    );
  }
}

class AlphabetGameNavigator extends StatefulWidget {
  @override
  _AlphabetGameNavigatorState createState() => _AlphabetGameNavigatorState();
}

class _AlphabetGameNavigatorState extends State<AlphabetGameNavigator> {
  int currentGameIndex = 0;
  int totalScore = 0;

  final List<Map<String, String>> allMatches = [
    {'T': 'Tree', 'O': 'Orange', 'R': 'Rabbit', 'M': 'Monkey', 'F': 'Fish', 'G': 'Grapes'},
    {'A': 'Apple', 'Y': 'YoYo', 'K': 'Kite', 'V': 'Violin', 'C': 'Cat', 'U': 'Umbrella'},
    {'J': 'Jug', 'D': 'Dog', 'S': 'Snail', 'L': 'Lion', 'N': 'Nest', 'H': 'House'},
    {'P': 'Parrot', 'Q': 'Queen', 'I': 'Ice Cream', 'E': 'Elephant', 'B': 'Ball', 'W': 'Watch'}
  ];


  final Map<String, String> images = {
    'B': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/B-unlabelled_w31a7y.png',
    'A': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/A-unlabelled_igujpe.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/C-unlabelled_rxxbds.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/D-unlabelled_wtzvac.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/E-unlabelled_blw8z3.png',
    'F': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/F-unlabelled_snbfpt.png',
    'G': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/G-unlabelled_s2gkov.png',
    'H': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/H-unlabelled_ly0uji.png',
    'I': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/I-unlabelled_ony1yb.png',
    'J': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/J-unlabelled_oyfo82.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/K-unlabelled_xrrfnn.png',
    'L': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/L-unlabelled_hhwzsw.png',
    'M': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/M-unlabelled_wjswwl.png',
    'N': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/N-unlabelled_rxq0j5.png',
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/O-unlabelled_y5juiu.png',
    'P': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/P-unlabelled_wqndna.png',
    'Q': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/Q-unlabelled_vcixdp.png',
    'R': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/R-unlabelled_gpraqs.png',
    'S': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/S-unlabelled_oasqu9.png',
    'T': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-unlabelled_lqapym.png',
    'U': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-unlabelled_kvzsbn.png',
    'V': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-unlabelled_ffi7tv.png',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-unlabelled_vnlcoq.png',
    'X': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-unlabelled_ufoyeu.png',
    'Y': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Y-unlabelled_qwzmjd.png',
    'Z': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Z-unlabelled_afrfch.png',

  };

  final Map<String, String> images2 = {
    'A': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726919/apple_ecnzt8.png',
    'B': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726907/ball_a6kj9i.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726905/cat_tgyrlt.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726905/dog1_gp18by.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726907/elephant_q7awma.png',
    'F': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726906/fish_z5jt9q.png',
    'G': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726905/grapes_waru8a.png',
    'H': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726905/house_t7yyeo.png',
    'I': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726916/icecream_wdpsfl.png',
    'J': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726904/jug_dyzpug.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726903/kite_dohrsc.png',
    'L': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726903/lion_nndhjz.png',
    'M': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726902/monkey_xg79lj.png',
    'N': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726903/nest_ubx4kg.png',
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726901/orange1_dm10aa.png',
    'P': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726899/parrot_vtrwqp.png',
    'Q': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726914/queen_ietryw.png',
    'R': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726903/rabbit_tjd7sj.png',
    'S':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726903/snail_zwlefe.png',
    'T':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726901/tree_uc1hho.png',
    'U':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726902/umbrella_fnqzgn.png',
    'V':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726899/violin_mncug8.png',
    'W':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726927/watch_txuhl8.png',
    'X':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726899/xylophone_yvmxil.png',
    'Y':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726900/yoyo_flnmgu.png',
    'Z':'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726898/zebra_ow86ws.png',
  };


  void onGameComplete(int score) {
    setState(() {
      totalScore += score;
      currentGameIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentGameIndex < allMatches.length) {
      return AlphabetMatchGame(
        matches: allMatches[currentGameIndex],
        images: images,
        images2: images2,
        onGameComplete: onGameComplete,
      );
    } else {
      return FinalScoreScreen(totalScore: totalScore);
    }
  }
}

class AlphabetMatchGame extends StatefulWidget {
  final Map<String, String> matches;
  final Map<String, String> images;
  final Map<String, String> images2;
  final Function(int) onGameComplete;

  const AlphabetMatchGame({
    required this.matches,
    required this.images,
    required this.images2,
    required this.onGameComplete,
  });

  @override
  _AlphabetMatchGameState createState() => _AlphabetMatchGameState();
}

class _AlphabetMatchGameState extends State<AlphabetMatchGame> {
  late List<String> alphabetList;
  late Map<String, String> currentMatches;
  late Map<String, bool> matchedItems;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  // Initialize the game and reset the state variables
  void initializeGame() {
    currentMatches = Map.from(widget.matches);  // Copy the map for the current game
    alphabetList = currentMatches.keys.toList();
    alphabetList.shuffle(Random());  // Shuffle the list of alphabets
    matchedItems = Map.fromIterable(alphabetList, key: (k) => k, value: (_) => false);  // Reset matched items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Center(
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
                  // Left side options (Draggables)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: alphabetList
                          .map(
                            (alphabet) => Visibility(
                          visible: !matchedItems[alphabet]!,
                          child: Draggable<String>(
                            data: alphabet,
                            feedback: Image.network(
                              widget.images[alphabet]!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            childWhenDragging: Container(),
                            child: Image.network(
                              widget.images[alphabet]!,
                              width: 90,
                              height: 90,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  // Right side targets
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: currentMatches.entries.map((entry) {
                          return DragTarget<String>(
                            builder: (context, accepted, rejected) {
                              return Column(
                                children: [
                                  Text(entry.value),
                                  Image.network(
                                    widget.images2[entry.key]!,
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              );
                            },
                            onWillAccept: (data) => data == entry.key,
                            onAccept: (data) {
                              setState(() {
                                score += 100;
                                matchedItems[data] = true;
                                currentMatches.remove(data);
                                if (alphabetList.every((item) => matchedItems[item]!)) {
                                  widget.onGameComplete(score);  // Game complete, move to next
                                }
                              });
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
    );
  }
}

class FinalScoreScreen extends StatelessWidget {
  final int totalScore;

  const FinalScoreScreen({Key? key, required this.totalScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Score: $totalScore",
              style: const TextStyle(color: Colors.black, fontSize: 32),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Go Home"),
            ),
          ],
        ),
      ),
    );
  }
}
