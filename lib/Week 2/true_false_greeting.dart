import 'dart:math';
import 'package:SignEase/Week%202/Result_t_f.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class True_false_challenger_greetings extends StatefulWidget {
  @override
  _True_false_challenger_greetingsState createState() =>
      _True_false_challenger_greetingsState();
}

class _True_false_challenger_greetingsState
    extends State<True_false_challenger_greetings> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4',
      'solution': 'Hello'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266605/good_bye_u_hz6peg.mp4',
      'solution': 'GoodBye'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4',
      'solution': 'Welcome'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1736093012/namaste_u_iptdsn_lrun3n.mp4',
      'solution': 'Namaste'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hy_u_dfsvt4.mp4',
      'solution': 'Hy'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266607/good_morning_u_ug5jxg.mp4',
      'solution': 'Good Morning'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/good_afternoon_u_wwhvia.mp4',
      'solution': 'Good Afternoon'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/good_night_u_sgogpu.mp4',
      'solution': 'Good Night'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266603/see_you_again_u_jfm6yv.mp4',
      'solution': 'See You Again'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/see_you_tomorrow_u_wqcfwu.mp4',
      'solution': 'See You Tomorrow'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1734887473/What_s_Up_ugj5gn.mp4',
      'solution': "What's Up?"
    },
  ];

  List<Map<String, dynamic>> selectedQuestions = [];
  List<Map<String, dynamic>> incorrectQuestions = [];
  Random random = Random();
  int score = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? userId;
  VideoPlayerController? videoController;
  String displayedAnswer = '';

  @override
  void initState() {
    super.initState();
    generateRandomQuiz();
    _fetchUserId();
    connectToMongoDB();
    setQuestionAndAnswer();
  }

  Future<void> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      print('User ID: $userId');
    }
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');

    try {
      await db.open();
      userCollection = db.collection('users');
      print("Connected to MongoDB!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  void generateRandomQuiz() {
    selectedQuestions = [...questionsAndSolutions]..shuffle();
    selectedQuestions = selectedQuestions.sublist(0, 6);
  }

  void setQuestionAndAnswer() {
    if (selectedQuestions.isNotEmpty) {
      var question = selectedQuestions[0];
      displayedAnswer = random.nextBool()
          ? question['solution']
          : questionsAndSolutions[random.nextInt(questionsAndSolutions.length)]
              ['solution'];
      videoController = VideoPlayerController.network(question['question'])
        ..initialize().then((_) {
          videoController?.setVolume(0.0);
          setState(() {});
          videoController?.play();
        })
        ..addListener(() {
          if (videoController!.value.position ==
              videoController!.value.duration) {
            setState(() {});
          }
        });
    }
  }

  void _answerQuestion(bool isTrue) {
    String correctSolution = selectedQuestions[0]['solution'];
    bool isCorrect = (displayedAnswer == correctSolution) == isTrue;

    setState(() {
      if (isCorrect) {
        score += 100;
        correctCount++;
        // Show success toast
      } else {
        incorrectCount++;
        incorrectQuestions.add({
          'question': selectedQuestions[0]['question'],
          'correctSolution': correctSolution,
        });
        // Show error toast
      }
    });

    Future.delayed(const Duration(seconds: 0), () {
      if (selectedQuestions.length > 1) {
        selectedQuestions.removeAt(0);
        videoController?.dispose();
        setQuestionAndAnswer();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Result_True_False(
              score: score,
              correctcount: correctCount,
              incorrectcount: incorrectCount,
              totalQuestions: 6,
              incorrectQuestions: incorrectQuestions,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    videoController?.removeListener(() {});
    videoController?.dispose();
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  buildHeader(screenHeight, isSmallScreen),

                  // Question & Video Section
                  buildQuestionCard(screenWidth, screenHeight, isSmallScreen),

                  // Answer Section
                  Transform.translate(
                      offset: Offset(0, -screenHeight * 0.14),
                      child: buildAnswerButtons(screenWidth, screenHeight)),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 189, 74, 2),
              ),
            ),
    );
  }

  Widget buildHeader(double screenHeight, bool isSmallScreen) {
    return Container(
      height: screenHeight * 0.35,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 252, 133, 37),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, -screenHeight * 0.06),
            child: Text(
              'Guess Right!',
              style: TextStyle(
                fontSize: isSmallScreen ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Transform.translate(
            offset: Offset(0, -screenHeight * 0.059),
            child: Text(
              "Identify if the answer is correct",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildQuestionCard(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Transform.translate(
        offset: Offset(0, -screenHeight * 0.14),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Question ${6 - selectedQuestions.length + 1}/6',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 80, 24, 24),
                  ),
                ),
              ),
              if (videoController != null &&
                  videoController!.value.isInitialized)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth *
                          0.4, // Adjust width as per your requirement
                      height: screenHeight *
                          0.5, // Adjust height as per your requirement
                      child: AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      ),
                    ),
                    if (videoController!.value.position ==
                        videoController!.value.duration)
                      ElevatedButton(
                        onPressed: () {
                          videoController!
                              .seekTo(Duration.zero); // Reset to start
                          videoController!.play(); // Play video
                          setState(() {}); // Update UI to hide button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          shape: CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(
                          Icons.replay,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                  ],
                )
              else
                Container(
                  height: screenHeight * 0.25, // Keep consistent fallback size
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 243, 128, 27),
                  ),
                ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                '$displayedAnswer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 18 : 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnswerButtons(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              _answerQuestion(true);
            },
            icon: Icon(Icons.check_circle, color: Colors.white),
            label: Text(
              "True",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.1,
              ),
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _answerQuestion(false);
            },
            icon: Icon(Icons.cancel, color: Colors.white),
            label: Text(
              "False",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.1,
              ),
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
