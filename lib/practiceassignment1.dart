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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz_alphabet_ResultScreen(
              score: score,
              correctcount:correctcount,
              incorrectcount:incorrectcount,
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange section with "Quiz Mania" title
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 133, 37),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 400,
                        height: 360,
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
                                  'Question ${6 - selectedQuestions.length + 1}/${6}', // Show the question number
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 206, 109, 30),
                                  ),
                                ),
                                // Display the image
                                Center(
                                  child: Image.network(
                                    selectedQuestions[0]['question'],
                                    fit: BoxFit.contain,
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
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildOptionCard(0),
                          buildOptionCard(1),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildOptionCard(2),
                          buildOptionCard(3),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -160),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.080,
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
          elevation: 12,
          color: _cardColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                currentOptions[index],
                style: TextStyle(
                  fontSize: 28,
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
