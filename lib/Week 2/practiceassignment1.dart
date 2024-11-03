import 'dart:math';
import 'package:SignEase/Verbs_Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class PracticeAssignment1 extends StatefulWidget {
  @override
  _PracticeAssignment1State createState() => _PracticeAssignment1State();
}

class _PracticeAssignment1State extends State<PracticeAssignment1> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4', 'solution': 'Hello'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266605/good_bye_u_hz6peg.mp4', 'solution': 'GoodBye'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4', 'solution': 'Welcome'},
    {'question': 'hhttps://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/namaste_u_iptdsn.mp4', 'solution': 'Namaste'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hy_u_dfsvt4.mp4', 'solution': 'Hy'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266607/good_morning_u_ug5jxg.mp4', 'solution': 'Good Morning'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/good_afternoon_u_wwhvia.mp4', 'solution': 'Good Afternoon'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/good_night_u_sgogpu.mp4', 'solution': 'Good Night'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266603/see_you_again_u_jfm6yv.mp4', 'solution': 'See You Again'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v173053https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/see_you_tomorrow_u_wqcfwu.mp4', 'solution': 'See You Tomorrow'},
  ];

  List<Map<String, dynamic>> selectedQuestions = [];
  List<Map<String, dynamic>> incorrectQuestions = [];
  Random random = Random();
  int score = 0;
  int selectedOptionIndex = -1;
  List<String> currentOptions = [];
  bool isLoading = true;
  int correctCount = 0;
  int incorrectCount = 0;
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? userId;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    generateRandomQuiz();
    _fetchUserId();
    connectToMongoDB();
    setOptionsForQuestion();
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

  void setOptionsForQuestion() {
    if (selectedQuestions.isNotEmpty) {
      currentOptions = generateOptions(selectedQuestions[0]['solution']);
      videoController = VideoPlayerController.network(selectedQuestions[0]['question'])
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

  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution);

    while (options.length < 4) {
      String randomOption = questionsAndSolutions[random.nextInt(questionsAndSolutions.length)]['solution'];
      if (!options.contains(randomOption)) {
        options.add(randomOption);
      }
    }

    options.shuffle();
    return options;
  }

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(String selectedOption, String correctSolution, int index) {
    setState(() {
      selectedOptionIndex = index;
      if (selectedOption == correctSolution) {
        score += 100;
        _cardColors[index] = Colors.green;
        _textColors[index] = Colors.white;
        correctCount++;
      } else {
        _cardColors[index] = Colors.red;
        _textColors[index] = Colors.white;
        incorrectCount++;
        incorrectQuestions.add({
          'question': selectedQuestions[0]['question'],
          'correctSolution': correctSolution,
        });
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
        selectedOptionIndex = -1;
      });

      if (selectedQuestions.length > 1) {
        selectedQuestions.removeAt(0);
        videoController?.dispose();
        setOptionsForQuestion();
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
                    "Identify the signs for each verb",
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
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            for (int i = 0; i < currentOptions.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.01,
                ),
                child: GestureDetector(
                  onTap: selectedOptionIndex == -1
                      ? () => _answerQuestion(currentOptions[i], selectedQuestions[0]['solution'], i)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _cardColors[i],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _cardColors[i],
                        width: 2,
                      ),
                    ),
                    child: Text(
                      currentOptions[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textColors[i],
                        fontSize: isSmallScreen ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
