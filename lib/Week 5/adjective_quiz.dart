import 'dart:math';
import 'package:SignEase/Week%205/Adjectives_Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class AdjectiveQuiz extends StatefulWidget {
  @override
  _AdjectiveQuizState createState() => _AdjectiveQuizState();
}

class _AdjectiveQuizState extends State<AdjectiveQuiz> {
  List<Map<String, dynamic>> adjectiveVideos = [
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897613/beautiful_bz4eod.mp4',
      'solution': 'Beautiful'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897758/delicious_fc16jv.mp4',
      'solution': 'Delicious'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897768/intelligent_gvtnyz.mp4',
      'solution': 'Intelligent'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897621/bright_nof7io.mp4',
      'solution': 'Bright'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897773/proud_pk3f9s.mp4',
      'solution': 'Proud'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897766/hot_dqkqvc.mp4',
      'solution': 'Hot(Feel)'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897764/hot_things_sg4blu.mp4',
      'solution': 'Hot(Things)'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897685/busy_l6ljzm.mp4',
      'solution': 'Busy'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897761/fast_hdlcaz.mp4',
      'solution': 'Fast'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897760/fresh_afehew.mp4',
      'solution': 'Fresh'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897706/cold_bewa1z.mp4',
      'solution': 'Cold'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897616/bad_y4ocsr.mp4',
      'solution': 'Bad'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897609/big_wqdsar.mp4',
      'solution': 'Big'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897762/good_j1od8d.mp4',
      'solution': 'Good'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897781/tall_ugh0zs.mp4',
      'solution': 'Tall'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897778/short_djtuin.mp4',
      'solution': 'Short'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897772/old_llxpk8.mp4',
      'solution': 'Old(Things)'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897770/old_people_migzzj.mp4',
      'solution': 'Old(People)'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897784/young_iffauh.mp4',
      'solution': 'Young'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897759/early_lk630z.mp4',
      'solution': 'Early'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897770/late_coixse.mp4',
      'solution': 'Late'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897762/happy_aql9hw.mp4',
      'solution': 'Happy'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897775/sad_icm5u1.mp4',
      'solution': 'Sad'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897609/angry_smme0q.mp4',
      'solution': 'Angry'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897767/important_ah3jxw.mp4',
      'solution': 'Important'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897783/weak_cjvisf.mp4',
      'solution': 'Weak'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897777/sick_btmtcd.mp4',
      'solution': 'Sick'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897781/white_ufozsj.mp4',
      'solution': 'White'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897779/sweet_ohin7f.mp4',
      'solution': 'Sweet'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897774/quiet_f9no21.mp4',
      'solution': 'Quiet'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897758/dark_islurc.mp4',
      'solution': 'Dark'
    },
    {
      'question': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897785/yellow_rluoxo.mp4',
      'solution': 'Yellow'
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
    selectedQuestions = [...adjectiveVideos]..shuffle();
    selectedQuestions = selectedQuestions.sublist(0, 6);
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
      adjectiveVideos[random.nextInt(adjectiveVideos.length)]
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
            builder: (context) => Quiz_Adjective_ResultScreen(
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
                fontSize: screenWidth < 600 ? 20 : 28,
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
                          "Identify the signs for each Adjectives",
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
                                  'Question ${6 - selectedQuestions.length + 1}/6',
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
                          value: (6 - selectedQuestions.length) / 6,
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
