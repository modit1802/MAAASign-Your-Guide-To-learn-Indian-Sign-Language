import 'dart:math';
import 'package:SignEase/Week%204/Simple_Sentence_Formation_using_Videos/Result_Quiz_Simple_Sentence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class Quiz_Simple_Sentence extends StatefulWidget {
  @override
  _Quiz_Simple_SentenceState createState() => _Quiz_Simple_SentenceState();
}

class _Quiz_Simple_SentenceState extends State<Quiz_Simple_Sentence> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731951051/41_aesnd6.mp4',
      'solution': 'Student eats dinner at house'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731951219/42_eow81c.mp4',
      'solution': 'Deaf people live in India'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848409/18U_wxgpxh.mp4',
      'solution': 'Airplane fly over India'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731951345/43_kityun.mp4',
      'solution': 'Girl child eats breakfast at house'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731951448/50_bi91dr.mp4',
      'solution': 'We cook dinner at home'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848347/22U_rjer3p.mp4',
      'solution': 'I wake up in the morning to work'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848414/21U_dod2n7.mp4',
      'solution': 'You go to school in the morning'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848347/20U_arbdma.mp4',
      'solution': 'You read the school book'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848350/19U_iqqd8d.mp4',
      'solution': 'They look at the birds'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848347/17U_jtctya.mp4',
      'solution': 'I drink tea in morning'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848411/13U_wsa3c2.mp4',
      'solution': 'Teacher loves my work'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848413/12U_ba1dhd.mp4',
      'solution': 'Mother drank tea at office'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848411/10U_sui6l1.mp4',
      'solution': 'Girl child is washing her hands'
    },
    {
      'question':
          'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848414/11U_dpakc3.mp4',
      'solution': 'We are drinking tea'
    },
    
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
    selectedQuestions = selectedQuestions.sublist(0, 10);
  }

  void setOptionsForQuestion() {
    if (selectedQuestions.isNotEmpty) {
      currentOptions = generateOptions(selectedQuestions[0]['solution']);
      videoController =
          VideoPlayerController.network(selectedQuestions[0]['question'])
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

  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution);

    while (options.length < 4) {
      String randomOption =
          questionsAndSolutions[random.nextInt(questionsAndSolutions.length)]
              ['solution'];
      if (!options.contains(randomOption)) {
        options.add(randomOption);
      }
    }

    options.shuffle();
    return options;
  }

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(
      String selectedOption, String correctSolution, int index) {
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
            builder: (context) => Quiz_Simple_Sentence_ResultScreen(
              score: score,
              correctcount: correctCount,
              incorrectcount: incorrectCount,
              totalQuestions: 10,
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

 Widget buildOptionCard(int index) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    child: GestureDetector(
      onTap: selectedOptionIndex == -1
          ? () => _answerQuestion(
                currentOptions[index],
                selectedQuestions[0]['solution'],
                index,
              )
          : null,
      child: Card(
        elevation: screenWidth < 600 ? 8 : 12,
        color: _cardColors[index],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03,
            horizontal: screenWidth * 0.04,
          ),
          height: screenHeight * 0.12,
          child: Center(
            child: Text(
              currentOptions[index],
              style: TextStyle(
                fontSize: screenWidth < 600 ? 12 : 16,
                color: _textColors[index],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  bool isSmallScreen = screenWidth < 600;

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
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -screenHeight * 0.02),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.059),
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
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Transform.translate(
                        offset: Offset(0, -screenHeight * 0.059),
                        child: Text(
                          "Identify the signs of Simple Sentence",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: SingleChildScrollView(
                    child: Transform.translate(
                      offset: Offset(0, -screenHeight * 0.17),
                      child: Container(
                        height: screenHeight * 0.5,
                        width: screenWidth * 0.8,
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
                                  'Question ${10 - selectedQuestions.length + 1}/10',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 206, 109, 30),
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.43,
                                child: Center(
                                  child: videoController != null &&
                                          videoController!.value.isInitialized
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: videoController!
                                                  .value.aspectRatio,
                                              child: VideoPlayer(
                                                  videoController!),
                                            ),
                                            if (videoController!
                                                    .value.position ==
                                                videoController!
                                                    .value.duration)
                                              IconButton(
                                                icon: Icon(
                                                  Icons.replay,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  videoController!
                                                      .seekTo(Duration.zero);
                                                  videoController!.play();
                                                  setState(() {});
                                                },
                                              ),
                                          ],
                                        )
                                      : CircularProgressIndicator(
                                          color: const Color.fromARGB(
                                              255, 189, 74, 2),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.0001),
                Transform.translate(
                  offset: Offset(0, -screenHeight * 0.16),
                  child: Column(
                    children: [
                      for (int i = 0; i < currentOptions.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              ),
                          child: buildOptionCard(i),
                        ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -screenHeight * 0.14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.08,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: LinearProgressIndicator(
                          value: (10 - selectedQuestions.length) / 10,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 189, 74, 2)),
                          backgroundColor:
                              const Color.fromARGB(255, 189, 187, 187),
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
