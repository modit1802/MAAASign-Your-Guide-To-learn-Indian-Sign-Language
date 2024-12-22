import 'dart:math';
import 'package:SignEase/Week%203/Verbs_Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class VerbQuiz extends StatefulWidget {
  @override
  _VerbQuizState createState() => _VerbQuizState();
}

class _VerbQuizState extends State<VerbQuiz> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530660/finish_abglyx.mp4',
      'solution': 'Finish'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530657/eat_yaf2hc.mp4',
      'solution': 'Eat'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/walk_zsaaad.mp4',
      'solution': 'Walk'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/talk_jh3iqu.mp4',
      'solution': 'Talk'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/work_ejax98.mp4',
      'solution': 'Work'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/wake_up_c6pbs5.mp4',
      'solution': 'Wake Up'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/use_gzlhmv.mp4',
      'solution': 'Use'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/read_w5djtk.mp4',
      'solution': 'Read'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/sleep_vwyvtz.mp4',
      'solution': 'Sleep'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/cook_epek8y.mp4',
      'solution': 'Cook'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/write_omxdnp.mp4',
      'solution': 'Write'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/drink_fxt97a.mp4',
      'solution': 'Drink'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/come_glgkmw.mp4',
      'solution': 'Come'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410721/go_idycp2.mp4',
      'solution': 'Go'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410725/wash_cstfkb.mp4',
      'solution': 'Wash'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410726/live_ge7jys.mp4',
      'solution': 'Live'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410727/love_d6fjxt.mp4',
      'solution': 'Love'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890674/fly_bm5i6w.mp4',
      'solution': 'Fly'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410729/look_qm9e55.mp4',
      'solution': 'Look'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410730/teach_bzjkbw.mp4',
      'solution': 'Teach'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410730/see_hdv0qq.mp4',
      'solution': 'See'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410731/give_lminrz.mp4',
      'solution': 'Give'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890682/swim_rqfbkd.mp4',
      'solution': 'Swim'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890666/wait_jb17dl.mp4',
      'solution': 'Wait'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890667/wear_fkpoy7.mp4',
      'solution': 'Wear'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/drive_anmwpx.mp4',
      'solution': 'Drive'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/dance_uxql6k.mp4',
      'solution': 'Dance'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/draw_nv18vo.mp4',
      'solution': 'Draw'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890669/travel_vtddll.mp4',
      'solution': 'Travel'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890669/clean_a12isl.mp4',
      'solution': 'Clean'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/listen_brxvjq.mp4',
      'solution': 'Listen'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890670/jump_c38hgb.mp4',
      'solution': 'Jump'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/cry_s2tyyz.mp4',
      'solution': 'Cry'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/catch_ngo7mv.mp4',
      'solution': 'Catch'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890672/meet_ivsfa2.mp4',
      'solution': 'Meet'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890674/stand_fejkqq.mp4',
      'solution': 'Stand'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890675/smile_sjxvzd.mp4',
      'solution': 'Smile'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890675/think_pjswbu.mp4',
      'solution': 'Think'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890676/sing_r6mzzg.mp4',
      'solution': 'Sing'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890676/grow_md03gs.mp4',
      'solution': 'Grow'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890678/run_ac37ln.mp4',
      'solution': 'Run'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890679/sit_nci0xg.mp4',
      'solution': 'Sit'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890679/play_tei2bg.mp4',
      'solution': 'Play'
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
                          "Identify the signs for each Verbs",
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
