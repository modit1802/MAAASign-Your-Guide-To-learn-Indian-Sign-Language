import 'dart:math';
import 'package:SignEase/Week%202/Relation_Result_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class True_False_Challenge extends StatefulWidget {
  @override
  _True_False_ChallengeState createState() => _True_False_ChallengeState();
}

class _True_False_ChallengeState extends State<True_False_Challenge> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266842/baby_u_p1lbqp.mp4', 'solution': 'baby'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266834/mother_u_tkkg10.mp4', 'solution': 'mother'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266839/father_u_jdbajr.mp4', 'solution': 'father'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266840/brother_u_dg76hq.mp4}', 'solution': 'brother',},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266838/sister_u_wpybjz.mp4', 'solution': 'sister'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266837/people_u_t4403p.mp4', 'solution': 'people'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266835/friend_u_nfctlk.mp4', 'solution': 'friend'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266834/man_u_llmdsh.mp4', 'solution': 'man'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266837/girl_child_u_qnjmxl.mp4', 'solution': 'girl child'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266844/female_person_u_cgv3es.mp4', 'solution': 'female person'},
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
