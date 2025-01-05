import 'package:SignEase/Challengers_All_Weeks/challenger_week1/challenger1.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%201/alphabetstart.dart';
import 'package:SignEase/Week%201/numberstart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../Challengers_All_Weeks/challenger_week4/challenger4.dart';
import 'Basic_Sentence_Quiz.dart';
import 'Simple_Sentence_Formation_using_Videos/Quiz_Simple_Sentence_Quiz.dart';
import 'Simple_Sentence_Formation_using_Videos/bingo_video_game.dart';
import 'Simple_Sentence_Formation_using_Videos/learnpage_videos.dart';

class Week4Entry extends StatefulWidget {
  const Week4Entry({super.key});

  @override
  _Week4EntryState createState() => _Week4EntryState();
}

class _Week4EntryState extends State<Week4Entry> {
  bool _showGif = false;
  bool _showScoreBox = false;
  int? _selectedCardIndex;
  int score1=0;
  int score2=0;
  int score3=0;
  int score = 0;
  int score_challenger=0;
  @override
  void initState() {
    super.initState();
    _fetchScoresFromMongoDB();
  }

  Future<void> _fetchScoresFromMongoDB() async {
    try {
      // Replace with your MongoDB connection details
      final db = await mongo.Db.create(
          'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
      await db.open();

      // Replace with your collection and query
      final collection = db.collection('users');
      String? userId = await getUserId();
      final data = await collection.findOne({"userId": userId});

      setState(() {
        score1 = (data?['week']?['week4']?['Score_Basic_Sentence']?['score_basic_sentence'] ?? 0) as int;
        score2 = (data?['week']?['week4']?['Score_Simple_Sentence']?['score_simple_sentence'] ?? 0) as int;
        score3 = (data?['week']?['week4']?['Score_bingo_simple_sentence']?['score_bingo_simple_sentence_2'] ?? 0) as int;
        score_challenger=(data?['week']?['Week4']?['Score_Challenger_Week4']?['score_challenger'] ?? 0) as int;
        score = score1 + score2 + score3;
      });

      await db.close();
    } catch (e) {
      print("Error fetching scores: $e");
      setState(() {
        score1 = 0;
        score2 = 0;
        score3 = 0;
        score = 0;
        score_challenger=0;
      });
    }
  }
  void _onItemTapped(int index) {
    setState(() {});

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 0),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 1),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 2),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 3),
          ),
        );
        break;
      default:
        break;
    }
  }
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ));
    return GestureDetector(
      onTap: () {
        if (_showScoreBox) {
          setState(() {
            _showScoreBox = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    SizedBox(height: screenHeight * 0.14),

        _buildCard2(
          onTap: () => _handleCardTap(0, const Learn_Simple_Sentence()),
          imagePath: 'images/verbs.png',
          color: const Color.fromARGB(255, 255, 255, 255),
          title: 'Review Signing Simple Sentences',
          index: 0,
        ),
        const SizedBox(height: 10),
        // Verb Card
        _buildCard(
          onTap: () => _handleCardTap(1, Basic_Sentence_Structure_Quiz()),
          imagePath: 'images/quiz.png',
          color: const Color.fromARGB(255, 255, 255, 255),
          title: 'Pop Quiz (Text) !',
          description: "Identify the correct ISL GLoss!",
          index: 1,
        ),

        const SizedBox(height: 10),

        // Noun Card
        _buildCard(
          onTap: () => _handleCardTap(2, Quiz_Simple_Sentence()),
          imagePath: 'images/quiz.png',
          color: const Color.fromARGB(255, 255, 255, 255),
          title: 'Pop Quiz (Videos) !',
          description:
          "Identify the correct Sentence!",
          index: 2,
        ),
        const SizedBox(height: 10),
        _buildCard(
          onTap: () => _handleCardTap(3, Bingo_game_simple_Sentences()),
          imagePath: 'images/bingo.png',
          color: const Color.fromARGB(255, 255, 255, 255),
          title: 'Bingo Bonanza!',
          description:
          "Watch the clips, guess the word, and mark your card.",
          index: 3,
        ),
        const SizedBox(height: 10),

        // Challenger Card
                      _buildCard(
                        onTap: score >= 1500
                            ? () => _handleCardTap(2, Challenger4(score: score))
                            : () {}, // Provide a no-op function when locked
                        imagePath: 'images/challenger.png',
                        color: score >= 1500
                            ? Colors.white
                            : Colors.grey.shade400, // Change color if locked
                        title: 'Challenger',
                        description: score >= 1500
                            ? 'Challenge yourself to unlock Week 2!'
                            : 'Score 1500+ to unlock!',
                        index: 2,
                      ),
        ],
                ),
              ),
            ),
            if (_showGif) ..._buildGifOverlay(context),
            Positioned(
              top: screenHeight * 0.065,
              left: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 165, 74, 17),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.065,
              right: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showScoreBox = !_showScoreBox;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Score: $score",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_showScoreBox)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Text Quiz: $score1", style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("Videos Quiz: $score2", style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("Bingo Bonanza: $score3", style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(
                              score_challenger == 0 ? "Challenger: Not Attempted" : "Challenger: $score_challenger",
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardTap(int index, Widget nextPage) {
    setState(() {
      _selectedCardIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      ).then((_) => setState(() {
        _selectedCardIndex = null;
      }));
    });
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 140,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGifOverlay(BuildContext context) {
    return [
      Container(color: Colors.black.withOpacity(0.92)),
      Center(
        child: Image.asset(
          'images/teacher2.gif',
          height: 350,
          fit: BoxFit.contain,
        ),
      ),
      Positioned(
        top: 60,
        right: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showGif = false;
            });
          },
          child: const Icon(
            Icons.close,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    ];
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 233, 215),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 165, 74, 17),
                    size: 30,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.fact_check,
                    color: Color.fromARGB(255, 165, 74, 17),
                    size: 30,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.score,
                    color: Color.fromARGB(255, 165, 74, 17),
                    size: 30,
                  ),
                  onPressed: () => _onItemTapped(2),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 165, 74, 17),
                    size: 30,
                  ),
                  onPressed: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCard2({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required int index,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 140,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}