import 'dart:math';
import 'package:SignEase/Quiz_alphabet_result_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PracticeAssignment1 extends StatefulWidget {
  @override
  _PracticeAssignment1State createState() => _PracticeAssignment1State();
}

class _PracticeAssignment1State extends State<PracticeAssignment1> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/A-unlabelled_igujpe.png',
      'solution': 'A'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/B-unlabelled_w31a7y.png',
      'solution': 'B'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/C-unlabelled_rxxbds.png',
      'solution': 'C'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/D-unlabelled_wtzvac.png',
      'solution': 'D'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/E-unlabelled_blw8z3.png',
      'solution': 'E'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/F-unlabelled_snbfpt.png',
      'solution': 'F'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/G-unlabelled_s2gkov.png',
      'solution': 'G'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/H-unlabelled_ly0uji.png',
      'solution': 'H'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/I-unlabelled_ony1yb.png',
      'solution': 'I'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/J-unlabelled_oyfo82.png',
      'solution': 'J'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/K-unlabelled_xrrfnn.png',
      'solution': 'K'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/L-unlabelled_hhwzsw.png',
      'solution': 'L'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/M-unlabelled_wjswwl.png',
      'solution': 'M'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/N-unlabelled_rxq0j5.png',
      'solution': 'N'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/O-unlabelled_y5juiu.png',
      'solution': 'O'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/P-unlabelled_wqndna.png',
      'solution': 'P'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/Q-unlabelled_vcixdp.png',
      'solution': 'Q'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/R-unlabelled_gpraqs.png',
      'solution': 'R'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/S-unlabelled_oasqu9.png',
      'solution': 'S'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-unlabelled_lqapym.png',
      'solution': 'T'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-unlabelled_kvzsbn.png',
      'solution': 'U'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-unlabelled_ffi7tv.png',
      'solution': 'V'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-unlabelled_vnlcoq.png',
      'solution': 'W'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-unlabelled_ufoyeu.png',
      'solution': 'X'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Y-unlabelled_qwzmjd.png',
      'solution': 'Y'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Z-unlabelled_afrfch.png',
      'solution': 'Z'
    },
  ];

  List<Map<String, dynamic>> selectedQuestions = [];
  List<Map<String, dynamic>> incorrectQuestions =
      []; // List to store incorrect questions
  Random random = Random();
  int score = 0;
  int selectedOptionIndex = -1;
  List<String> currentOptions = [];
  bool isLoading = true;
  int correctcount = 0;
  int incorrectcount = 0;
  late mongo.Db db; // MongoDB database instance
  late mongo.DbCollection userCollection;
  String? userId; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    generateRandomQuiz();
    _fetchUserId();
    connectToMongoDB();
    setOptionsForQuestion(); // Generate options for the first question
  }

  Future<void> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      setState(() {
        userId = user.uid; // Set user ID
      });
      print('User ID: $userId'); // Print user ID in the console for debugging
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
    selectedQuestions =
        selectedQuestions.sublist(0, 6); // Select 6 random questions
  }

  void setOptionsForQuestion() {
    // Generate options for the current question and shuffle them once
    currentOptions = generateOptions(selectedQuestions[0]['solution']);
    isLoading = true; // Set loading to true while options are being set
  }

  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution); // Add correct answer

    // Generate random wrong options
    while (options.length < 4) {
      String randomLetter = String.fromCharCode(
          65 + random.nextInt(26)); // Generate random letter A-Z
      if (!options.contains(randomLetter)) {
        options.add(randomLetter);
      }
    }

    options.shuffle(); // Shuffle options to mix them
    return options;
  }

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(
      String selectedOption, String correctSolution, int index) {
    setState(() {
      selectedOptionIndex = index; // Mark the selected option
      if (selectedOption == correctSolution) {
        score += 100;
        _cardColors[index] = Colors.green;
        _textColors[index] = Colors.white;
        correctcount++;
      } else {
        _cardColors[index] = Colors.red;
        _textColors[index] = Colors.white;
        incorrectcount++;
        // Add the incorrect question to the list with the question and correct solution
        incorrectQuestions.add({
          'question': selectedQuestions[0]['question'],
          'correctSolution': correctSolution,
        });
      }
    });

    // 2-3 seconds delay before showing the next question
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
        selectedOptionIndex = -1; // Reset the selected option index
      });

      if (selectedQuestions.length > 1) {
        selectedQuestions.removeAt(0);
        setOptionsForQuestion(); // Set new options for the next question
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz_alphabet_ResultScreen(
              score: score,
              correctcount: correctcount,
              incorrectcount: incorrectcount,
              totalQuestions: 6,
              incorrectQuestions: incorrectQuestions,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen =
        screenWidth < 600; // You can adjust this threshold based on your needs

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange section with "Quiz Mania" title
                  Container(
                    height: screenHeight *
                        0.4, // Adjust height based on screen size
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 133, 37),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Align(
                      alignment: Alignment.center, // Align text to the left
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight *
                                    0.050), // Add top padding for text
                            child: Text(
                              'Quiz Mania',
                              style: TextStyle(
                                fontFamily:
                                    'RubikWetPaint', // Use the custom font family
                                fontSize: isSmallScreen
                                    ? 38
                                    : 40, // Font size adjustment
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Text(
                            "Identify the below signs of alphabets",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.18),
                    child: Padding(
                      padding: EdgeInsets.all(
                          isSmallScreen ? 8 : 16), // Padding adjustment
                      child: Container(
                        width: screenWidth *
                            0.9, // Width adjustment based on screen size
                        height: screenHeight *
                            0.4, // Adjust height based on screen size
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Display the question number
                                Text(
                                  'Question ${6 - selectedQuestions.length + 1}/6', // Show the question number
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 16
                                        : 20, // Font size adjustment
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 206, 109, 30),
                                  ),
                                ),
                                // Display the image
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Color.fromARGB(255, 189, 74, 2),
                                      ),
                                      Image.network(
                                        selectedQuestions[0]['question'],
                                        fit: BoxFit.contain,
                                        height: isSmallScreen
                                            ? screenHeight * 0.3
                                            : screenHeight *
                                                0.25, // Image height adjustment
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Display options in two rows with two options each
                  for (int i = 0; i < 2; i++) ...[
                    Transform.translate(
                      offset: Offset(0, -screenHeight * 0.18),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                isSmallScreen ? 8 : 16), // Padding adjustment
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildOptionCard(i * 2),
                            buildOptionCard(i * 2 + 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.13),
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
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            ),
    );
  }

  // Helper method to build option cards
  Widget buildOptionCard(int index) {
  // Obtain screen width and height using MediaQuery
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Expanded(
    child: GestureDetector(
      onTap: selectedOptionIndex == -1
          ? () => _answerQuestion(
                currentOptions[index],
                selectedQuestions[0]['solution'],
                index,
              )
          : null, // Disable tap if an option is already selected
      child: Card(
        elevation: screenWidth < 600 ? 8 : 12, // Adjust elevation based on screen size
        color: _cardColors[index],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04), // Adjust border radius
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03, // Adjust vertical padding based on screen size
            horizontal: screenWidth * 0.04, // Adjust horizontal padding based on screen size
          ),
          child: Center(
            child: Text(
              currentOptions[index],
              style: TextStyle(
                fontSize: screenWidth < 600 ? 20 : 28, // Adjust font size for small screens
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
}
