import 'dart:async';
import 'package:SignEase/Week%201/Tutorial_screen_for_challenger_matchmaker.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Match_maker_alphabet5 extends StatelessWidget {
  final int score;

  const Match_maker_alphabet5({Key? key, required this.score}) : super(key: key);

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
  final String mongoDbUri = "mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority";
  final String collectionName = "users";
  List<String> alphabetList = ['T', 'U', 'V', 'W', 'X'];
  Map<String, String> matches = {
    'T': 'Tree',
    'U': 'Umbrella',
    'V': 'Violin',
    'W': 'Watch',
    'X': 'Xylophone',
  };
  Map<String, String> images = {
    'T': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-unlabelled_lqapym.png',
    'U': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-unlabelled_kvzsbn.png',
    'V': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-unlabelled_ffi7tv.png',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-unlabelled_vnlcoq.png',
    'X': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-unlabelled_ufoyeu.png',
  };
  Map<String, String> images2 = {
    'T': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726901/tree_uc1hho.png',
    'U': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726902/umbrella_iyjuer.png',
    'V': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726906/violin_trmytx.png',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726904/watch_omjfkl.png',
    'X': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726900/xylophone_dvm7gj.png',
  };


  // A map to track which images have been matched
  Map<String, bool> matchedItems = {
    'T': false,
    'U': false,
    'V': false,
    'W': false,
    'X': false,
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

  Future<void> _storeScoreInMongoDB() async {
    try {
      var db = mongo.Db(mongoDbUri);
      await db.open();
      var collection = db.collection(collectionName);
      String? userId = await getUserId();
      var userDoc = await collection.findOne(mongo.where.eq('userId', userId));
      // Insert the score with a timestamp
      if (userDoc == null) {
        // If user doesn't exist, insert new document with only Score_number
        await collection.insert({
          'userId': userId,
          'week': {
            'week1': {
              'Score_alphabet_match': {
                'score_alphabet_match': score,
              }
            }
          }
        });
      } else {
        // If user exists, add or update only the Score_number field inside week1
        await collection.update(
          mongo.where.eq('userId', userId),
          mongo.modify.set('week.week1.Score_alphabet_match', {
            'score_alphabet_match': score,
          }),
        );
      }
      print("Inserted Score in MongoDB");
      print("UserID:$userId");
      await db.close();
    } catch (e) {
      print("Error storing score in MongoDB: $e");
    }
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
                  style: const TextStyle(color: Colors.white, fontSize: 18),
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
      if (showRibbon) RibbonWidget(score1: score),
      if (showNextStepButton)
        Padding(
          padding: const EdgeInsets.all(16.0), // Reduced padding for better visibility
          child: Center(
            child: Image.asset(
              'images/celebrate-cat.gif',
              width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
              height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
              fit: BoxFit.contain, // Maintain aspect ratio
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
    _buttonTimer = Timer(const Duration(seconds: 4), () async {
      setState(() {
        showNextStepButton = false;
      });
      await _storeScoreInMongoDB();
      // Automatically navigate back after completing the game
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}


class RibbonWidget extends StatelessWidget {
  final int score1;

  const RibbonWidget({Key? key, required this.score1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: score1 ==500
          ? Color.fromARGB(255, 16, 161, 0)
          : score1>0 && score1<500
          ? Color.fromARGB(255, 250, 200, 2)
          : Color.fromARGB(255, 200, 0, 0), // Different color for a score of 0
      child: Center(
        child: Text(
          score1 == 500 ? 'Congratulations!' : score1>0 && score1<500 ? 'Good Attempt!' : 'Try next time!',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
