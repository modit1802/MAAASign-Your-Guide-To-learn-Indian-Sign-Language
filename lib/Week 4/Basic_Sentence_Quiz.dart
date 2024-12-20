import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:math';
import 'Basic_Sentence_Structure_Quiz_Result.dart';

class Basic_Sentence_Structure_Quiz extends StatefulWidget {
  @override
  _Basic_Sentence_Structure_QuizState createState() => _Basic_Sentence_Structure_QuizState();
}

class _Basic_Sentence_Structure_QuizState extends State<Basic_Sentence_Structure_Quiz> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {'question': 'I love reading books.', 'solution': 'I BOOK READ LOVE'},
    {'question': 'She is cooking dinner.', 'solution': 'SHE DINNER COOK'},
    {'question': 'We are going to school.', 'solution': 'WE SCHOOL GO'},
    {'question': 'I am drinking tea.', 'solution': 'I TEA DRINK'},
    {'question': 'She is walking to the market.', 'solution': 'SHE MARKET WALK'},
    {'question': 'We are going to work.', 'solution': 'WE WORK GO'},
    {'question': 'They are looking at birds.', 'solution': 'THEY BIRDS LOOK'},
    {'question': 'I am reading a book.', 'solution': 'I BOOK READ'},
    {'question': 'She is sleeping in the morning.', 'solution': 'SHE MORNING SLEEP'},
    {'question': 'We are eating lunch.', 'solution': 'WE LUNCH EAT'},
    {'question': 'They are cooking dinner.', 'solution': 'THEY DINNER COOK'},
    {'question': 'I am teaching a student.', 'solution': 'I STUDENT TEACH'},
    {'question': 'She is giving a book.', 'solution': 'SHE BOOK GIVE'},
    {'question': 'They are flying an aeroplane.', 'solution': 'THEY AEROPLANE FLY'},
    {'question': 'I am working at the office.', 'solution': 'I OFFICE WORK'},
    {'question': 'She is talking to a friend.', 'solution': 'SHE FRIEND TALK'},
    {'question': 'He is washing his hands.', 'solution': 'HE HANDS WASH'},
    {'question': 'They are going home.', 'solution': 'THEY HOME GO'},
    {'question': 'I am looking at a book.', 'solution': 'I BOOK LOOK'},
    {'question': 'We are drinking tea.', 'solution': 'WE TEA DRINK'},
    {'question': 'They are walking to the school.', 'solution': 'THEY SCHOOL WALK'},
    {'question': 'I am going to the market.', 'solution': 'I MARKET GO'},
    {'question': 'She is seeing a teacher.', 'solution': 'SHE TEACHER SEE'},
    {'question': 'We are flying to India.', 'solution': 'WE INDIA FLY'},
    {'question': 'They are working at home.', 'solution': 'THEY HOME WORK'},
    {'question': 'I am talking to my mother.', 'solution': 'I MOTHER TALK'},
    {'question': 'She is writing a book.', 'solution': 'SHE BOOK WRITE'},
    {'question': 'We are eating dinner.', 'solution': 'WE DINNER EAT'},
    {'question': 'I am seeing my father.', 'solution': 'I FATHER SEE'},
    {'question': 'She is looking at the birds.', 'solution': 'SHE BIRDS LOOK'},
    {'question': 'We are walking in the morning.', 'solution': 'WE MORNING WALK'},
    {'question': 'I am going to the office.', 'solution': 'I OFFICE GO'},
    {'question': 'He is seeing a fish.', 'solution': 'HE FISH SEE'},
    {'question': 'She is talking to a girl child.', 'solution': 'SHE GIRL CHILD TALK'},
    {'question': 'We are finishing our work.', 'solution': 'WE WORK FINISH'},
    {'question': 'They are eating breakfast.', 'solution': 'THEY BREAKFAST EAT'},
    {'question': 'I am walking to school.', 'solution': 'I SCHOOL WALK'},
    {'question': 'She is looking at her hands.', 'solution': 'SHE HANDS LOOK'},
    {'question': 'I am teaching my friend.', 'solution': 'I FRIEND TEACH'},
    {'question': 'She is reading a letter in the morning.', 'solution': 'SHE LETTER MORNING READ'},
    {'question': 'We are seeing the teacher.', 'solution': 'WE TEACHER SEE'},
    {'question': 'They are working at the office.', 'solution': 'THEY OFFICE WORK'},
    {'question': 'I am walking in the market.', 'solution': 'I MARKET WALK'},
    {'question': 'She is giving a fish to her father.', 'solution': 'SHE FATHER FISH GIVE'},
    {'question': 'We are looking at the birds in the morning.', 'solution': 'WE BIRDS MORNING LOOK'},
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
    selectedQuestions = [...questionsAndSolutions]..shuffle();
    selectedQuestions = selectedQuestions.sublist(0, 10);
  }

  void setOptionsForQuestion() {
    currentOptions = generateOptions(selectedQuestions[0]['solution']);
    isLoading = true;
  }
  int _factorial(int n) {
    return n <= 1 ? 1 : n * _factorial(n - 1);
  }

  List<String> generateOptions(String correctSolution) {
    // Use a Set to ensure uniqueness of options
    Set<String> options = {correctSolution};
    List<String> words = correctSolution.split(' ');
    Random random = Random();

    // Generate unique permutations until we have 4 options
    while (options.length < 4) {
      // Shuffle words to create a permutation
      List<String> shuffled = List.from(words)..shuffle(random);
      String option = shuffled.join(' ');

      // Add the new permutation to the set
      options.add(option);
    }

    // Convert to a list, shuffle the final options, and return
    List<String> result = options.toList()..shuffle(random);
    return result;
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
            builder: (context) => Basic_Sentence_Structure_Quiz_Result(
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
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
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
                          "Translate the following English Sentence to Indian Sign Language Gloss",
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
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Question ${10 - selectedQuestions.length + 1}/10',
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

                // Options displayed column-wise
                Transform.translate(
                  offset: Offset(0, -screenHeight * 0.06),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                    child: Column(
                      children: [
                        for (int i = 0; i < 4; i++) ...[
                          buildOptionCard(i),
                          SizedBox(height: screenHeight * 0.02), // Space between option cards
                        ],
                      ],
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset(0, -screenHeight * 0.04),
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

// Helper method to build option cards
Widget buildOptionCard(int index) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  bool isSmallScreen = screenWidth < 600;

  return GestureDetector(
    onTap: selectedOptionIndex == -1
        ? () {
            _answerQuestion(currentOptions[index],
                selectedQuestions[0]['solution'], index);
          }
        : null,
    child: Container(
      padding: EdgeInsets.all(screenWidth * 0.025),
      height: screenHeight * 0.12,
      decoration: BoxDecoration(
        color: _cardColors[index],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          currentOptions[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: _textColors[index],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}


}
