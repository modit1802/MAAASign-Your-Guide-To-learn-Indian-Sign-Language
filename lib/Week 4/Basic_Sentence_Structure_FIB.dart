import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'Basic_Sentence_Structure_FIB_Result.dart';

class Basic_Sentence_Structure_FIB extends StatefulWidget {
  @override
  _Basic_Sentence_Structure_FIBState createState() => _Basic_Sentence_Structure_FIBState();
}

class _Basic_Sentence_Structure_FIBState extends State<Basic_Sentence_Structure_FIB> {
  List<Map<String, dynamic>> fillInTheBlanks = [
    {'question': 'I ___ READ LOVE', 'solution': 'BOOK'},
    {'question': 'SHE DINNER ___', 'solution': 'COOK'},
    {'question': 'WE SCHOOL ___', 'solution': 'GO'},
    {'question': 'I TEA ___', 'solution': 'DRINK'},
    {'question': 'SHE MARKET ___', 'solution': 'WALK'},
    {'question': 'WE WORK ___', 'solution': 'GO'},
    {'question': 'THEY BIRDS ___', 'solution': 'LOOK'},
    {'question': 'I BOOK ___', 'solution': 'READ'},
    {'question': 'SHE MORNING ___', 'solution': 'SLEEP'},
    {'question': 'WE LUNCH ___', 'solution': 'EAT'},
    {'question': 'THEY DINNER ___', 'solution': 'COOK'},
    {'question': 'I STUDENT ___', 'solution': 'TEACH'},
    {'question': 'SHE BOOK ___', 'solution': 'GIVE'},
    {'question': 'THEY AEROPLANE ___', 'solution': 'FLY'},
    {'question': 'I OFFICE ___', 'solution': 'WORK'},
    {'question': 'SHE FRIEND ___', 'solution': 'TALK'},
    {'question': 'HE HANDS ___', 'solution': 'WASH'},
    {'question': 'THEY HOME ___', 'solution': 'GO'},
    {'question': 'I BOOK ___', 'solution': 'LOOK'},
    {'question': 'WE TEA ___', 'solution': 'DRINK'},
    {'question': 'THEY SCHOOL ___', 'solution': 'WALK'},
    {'question': 'I MARKET ___', 'solution': 'GO'},
    {'question': 'SHE TEACHER ___', 'solution': 'SEE'},
    {'question': 'WE INDIA ___', 'solution': 'FLY'},
    {'question': 'THEY HOME ___', 'solution': 'WORK'},
    {'question': 'I MOTHER ___', 'solution': 'TALK'},
    {'question': 'SHE BOOK ___', 'solution': 'WRITE'},
    {'question': 'WE DINNER ___', 'solution': 'EAT'},
    {'question': 'I FATHER ___', 'solution': 'SEE'},
    {'question': 'SHE BIRDS ___', 'solution': 'LOOK'},
    {'question': 'WE MORNING ___', 'solution': 'WALK'},
    {'question': 'I OFFICE ___', 'solution': 'GO'},
    {'question': 'HE FISH ___', 'solution': 'SEE'},
    {'question': 'SHE GIRL CHILD ___', 'solution': 'TALK'},
    {'question': 'WE WORK ___', 'solution': 'FINISH'},
    {'question': 'THEY BREAKFAST ___', 'solution': 'EAT'},
    {'question': 'I SCHOOL ___', 'solution': 'WALK'},
    {'question': 'SHE HANDS ___', 'solution': 'LOOK'},
    {'question': 'I FRIEND ___', 'solution': 'TEACH'},
    {'question': 'SHE LETTER MORNING ___', 'solution': 'READ'},
    {'question': 'WE TEACHER ___', 'solution': 'SEE'},
    {'question': 'THEY OFFICE ___', 'solution': 'WORK'},
    {'question': 'I MARKET ___', 'solution': 'WALK'},
    {'question': 'SHE FATHER FISH ___', 'solution': 'GIVE'},
    {'question': 'WE BIRDS MORNING ___', 'solution': 'LOOK'},
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
    selectedQuestions = [...fillInTheBlanks]..shuffle();
    selectedQuestions = selectedQuestions.sublist(0, 6);
  }

  void setOptionsForQuestion() {
    currentOptions = generateOptions(selectedQuestions[0]['solution']);
    isLoading = true;
  }

  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution);

    while (options.length < 4) {
      String randomGloss = fillInTheBlanks[random.nextInt(fillInTheBlanks.length)]['solution'];
      if (!options.contains(randomGloss)) {
        options.add(randomGloss);
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
        setOptionsForQuestion();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Basic_Sentence_Structure_FIB_Result(
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
              height: screenHeight * 0.4,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 252, 133, 37),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.1),
                      child: Text(
                        'Quiz Mania',
                        style: TextStyle(
                          fontFamily: 'RubikWetPaint',
                          fontSize: isSmallScreen ? 38 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Guess the Missing Word in the ISL Gloss",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.08),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.25,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: Center( // Centers the content inside the card
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Centers content vertically
                          children: [
                            Text(
                              'Question ${6 - selectedQuestions.length + 1}/6',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 206, 109, 30),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              selectedQuestions[0]['question'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            for (int i = 0; i < 2; i++) ...[
              Transform.translate(
                offset: Offset(0, -screenHeight * 0.08),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Spacing around the row
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Even spacing between cards
                    children: [
                      buildOptionCard(i * 2),
                      SizedBox(width: screenWidth * 0.04), // Space between cards in the same row
                      buildOptionCard(i * 2 + 1),
                    ],
                  ),
                ),
              ),
            ],

            Transform.translate(
              offset: Offset(0, -screenHeight * 0.06),
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
  // Helper method to build option cards
  Widget buildOptionCard(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600;

    return Expanded(
      child: GestureDetector(
        onTap: selectedOptionIndex == -1
            ? () {
          _answerQuestion(currentOptions[index],
              selectedQuestions[0]['solution'], index);
        }
            : null,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, // Vertical space between cards
            horizontal: screenWidth * 0.02, // Horizontal space between cards
          ),
          padding: EdgeInsets.all(screenWidth * 0.025),
          height: screenHeight * 0.12, // Fixed height for consistent size
          decoration: BoxDecoration(
            color: _cardColors[index],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Offset for shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              currentOptions[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: _textColors[index],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

}
