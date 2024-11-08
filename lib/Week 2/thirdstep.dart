import 'dart:math';
import 'package:SignEase/Week%202/Greeting_Result_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class PracticeAssignment2 extends StatefulWidget {
  @override
  _PracticeAssignment2State createState() => _PracticeAssignment2State();
}

class _PracticeAssignment2State extends State<PracticeAssignment2> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4', 'solution': 'Hello'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266605/good_bye_u_hz6peg.mp4', 'solution': 'GoodBye'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4', 'solution': 'Welcome'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/namaste_u_iptdsn.mp4', 'solution': 'Namaste'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hy_u_dfsvt4.mp4', 'solution': 'Hy'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266607/good_morning_u_ug5jxg.mp4', 'solution': 'Good Morning'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/good_afternoon_u_wwhvia.mp4', 'solution': 'Good Afternoon'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/good_night_u_sgogpu.mp4', 'solution': 'Good Night'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266603/see_you_again_u_jfm6yv.mp4', 'solution': 'See You Again'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/see_you_tomorrow_u_wqcfwu.mp4', 'solution': 'See You Tomorrow'},
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
      displayedAnswer = random.nextBool() ? question['solution'] : questionsAndSolutions[random.nextInt(questionsAndSolutions.length)]['solution'];
      videoController = VideoPlayerController.network(question['question'])
        ..initialize().then((_) {
          setState(() {});
          videoController?.play();
        })
        ..addListener(() {
          if (videoController!.value.position == videoController!.value.duration) {
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
      } else {
        incorrectCount++;
        incorrectQuestions.add({
          'question': selectedQuestions[0]['question'],
          'correctSolution': correctSolution,
        });
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (selectedQuestions.length > 1) {
        selectedQuestions.removeAt(0);
        videoController?.dispose();
        setQuestionAndAnswer();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz_Verb_ResultScreen(
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
            Container(
              height: screenHeight * 0.35,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 252, 133, 37),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05),
                    child: Text(
                      'Quiz Mania',
                      style: TextStyle(
                        fontFamily: 'RubikWetPaint',
                        fontSize: isSmallScreen ? 32 : 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Identify if the answer is correct",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 206, 109, 30),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.25,
                      child: Center(
                        child: videoController != null && videoController!.value.isInitialized
                            ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: videoController!.value.aspectRatio,
                              child: VideoPlayer(videoController!),
                            ),
                            if (videoController!.value.position == videoController!.value.duration)
                              IconButton(
                                icon: Icon(
                                  Icons.replay,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  videoController!.seekTo(Duration.zero);
                                  videoController!.play();
                                  setState(() {});
                                },
                              ),
                          ],
                        )
                            : CircularProgressIndicator(
                          color: const Color.fromARGB(255, 189, 74, 2),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        displayedAnswer,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 191, 101, 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _answerQuestion(true),
                          child: Text(
                            'True',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 191, 101, 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _answerQuestion(false),
                          child: Text(
                            'False',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
