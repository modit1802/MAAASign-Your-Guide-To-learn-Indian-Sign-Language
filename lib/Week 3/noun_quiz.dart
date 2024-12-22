import 'dart:math';
import 'package:SignEase/Week%203/Nouns_Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:video_player/video_player.dart';

class NounQuiz extends StatefulWidget {
  @override
  _NounQuizState createState() => _NounQuizState();
}

class _NounQuizState extends State<NounQuiz> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4',
      'solution': 'School'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/market_vfh9vj.mp4',
      'solution': 'Market'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530818/lunch_cbcgwu.mp4',
      'solution': 'Lunch'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/tea_i6mkyc.mp4',
      'solution': 'Tea'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4',
      'solution': 'Office'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/morning_pvtuty.mp4',
      'solution': 'Morning'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/breakfast_hb90fq.mp4',
      'solution': 'Breakfast'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4',
      'solution': 'Hands'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/deaf_ezkwye.mp4',
      'solution': 'Deaf'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530815/dinner_blbwzm.mp4',
      'solution': 'Dinner'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/book_rmof9s.mp4',
      'solution': 'Book'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410467/student_ohmjwi.mp4',
      'solution': 'Student'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410468/fish_kkyqvv.mp4',
      'solution': 'Fish'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410467/birds_ict0au.mp4',
      'solution': 'Birds'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410469/aeroplane_qpzztg.mp4',
      'solution': 'Aeroplane'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410473/teacher_tqdyrt.mp4',
      'solution': 'Teacher'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410473/home_ocdazz.mp4',
      'solution': 'Home'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410475/india_ludfnp.mp4',
      'solution': 'India'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892129/chair_si7osy.mp4',
      'solution': 'Chair'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892131/Delhi_cparbw.mp4',
      'solution': 'Delhi'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892131/car_dhbu9a.mp4',
      'solution': 'Car'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892133/football_mwcosq.mp4',
      'solution': 'Football'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892133/shirt_muc04j.mp4',
      'solution': 'Shirt'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892133/water_n1yaxd.mp4',
      'solution': 'Water'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892134/sun_nljhud.mp4',
      'solution': 'Sun'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892135/coffee_ytk8dg.mp4',
      'solution': 'Coffee'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892137/table_dvccpo.mp4',
      'solution': 'Table'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892137/shoes_fsghis.mp4',
      'solution': 'Shoes'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892138/egg_egmswp.mp4',
      'solution': 'Egg'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892138/cricket_f0a9ik.mp4',
      'solution': 'Cricket'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892139/garden_pwxfez.mp4',
      'solution': 'Garden'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892141/train_h4wgxx.mp4',
      'solution': 'Train'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892142/flower_wyc7aj.mp4',
      'solution': 'Flower'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892142/mirror_wtdydk.mp4',
      'solution': 'Mirror'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892143/tree_ed0q7g.mp4',
      'solution': 'Tree'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892145/bus_svvoj3.mp4',
      'solution': 'Bus'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892145/floor_xnnsb1.mp4',
      'solution': 'Floor'
    },
    {
      'question':
      'https://res.cloudinary.com/dfph32nsq/video/upload/v1734892147/moon_bphrg5.mp4',
      'solution': 'Moon'
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
            builder: (context) => Quiz_Noun_ResultScreen(
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
                          "Identify the signs for each Nouns",
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
