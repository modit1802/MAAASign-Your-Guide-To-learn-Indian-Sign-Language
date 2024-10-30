import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PracticeAssignment2 extends StatefulWidget {
  @override
  _PracticeAssignment2State createState() => _PracticeAssignment2State();
}

class _PracticeAssignment2State extends State<PracticeAssignment2> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/1_ypmmhh.png', 'solution': '1'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716936/0_e1tfib.png', 'solution': '0'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/2_tb6h2y.png', 'solution': '2'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/4_hltwy4.png', 'solution': '4'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/10_qkdwqf.png', 'solution': '10'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/3_tbfqjk.png', 'solution': '3'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264002/5_nofsuk.png', 'solution': '5'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264003/6_ireutv.png', 'solution': '6'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/7_msy2e3.png', 'solution': '7'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/9_mgaajm.png', 'solution': '9'},
    { 'question':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/8_kabrqo.png', 'solution': '8'},
  ];

  List<Map<String, dynamic>> selectedQuestions = [];
  List<Map<String, dynamic>> incorrectQuestions =
      []; // List to store incorrect questions
  Random random = Random();
  int score = 0;
  int selectedOptionIndex = -1;
  List<String> currentOptions = [];
  bool isLoading = true;
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
    String randomNumber = random.nextInt(11).toString(); // Generate a random number between 0 and 10
    if (!options.contains(randomNumber)) {
      options.add(randomNumber);
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
      } else {
        _cardColors[index] = Colors.red;
        _textColors[index] = Colors.white;
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
            builder: (context) => ResultScreen(
              score: score,
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
    backgroundColor: Color.fromARGB(255, 250, 233, 215),
    body: selectedQuestions.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50,),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.080,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: LinearProgressIndicator(
                        value: (6 - selectedQuestions.length) / 6,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>( Color.fromARGB(255, 189, 74, 2)),
                        backgroundColor: const Color.fromARGB(255, 189, 187, 187),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "Select the correct option",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 189, 74, 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 240, 210),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 170, 0),
                        width: 3.0,
                      ),
                    ),
                    child: Center(
                      child: Image.network(
                        selectedQuestions[0]['question'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Display options in two rows with two options each
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildOptionCard(0),
                      buildOptionCard(1),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildOptionCard(2),
                      buildOptionCard(3),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
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

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> incorrectQuestions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.incorrectQuestions,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? userId;

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
    try {
      await db.open();
      userCollection = db.collection('users');
      await saveResultToMongoDB();
      print("Connected to MongoDB and result saved!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

Future<void> saveResultToMongoDB() async {
  // Get the user ID from Firebase
  String? userId = await getUserId();
  if (userId != null) {
    // Check if user already exists in the collection
    var userDoc = await userCollection.findOne(mongo.where.eq('userId', userId));

    // Define the week key
    String weekKey = 'week1';

    if (userDoc == null) {
      // If user doesn't exist, insert new document with only Score_number
      await userCollection.insert({
        'userId': userId,
        'week': {
          weekKey: {
            'Score_number': {
              'score_number': widget.score,
              'incorrectQuestions_number': widget.incorrectQuestions,
            }
          }
        }
      });
    } else {
      // If user exists, add or update only the Score_number field inside week1
      await userCollection.update(
        mongo.where.eq('userId', userId),
        mongo.modify.set('week.$weekKey.Score_number', {
          'score_number': widget.score,
          'incorrectQuestions_number': widget.incorrectQuestions,
        }),
      );
    }

    print("Data inserted/updated for user ID: $userId, week key: $weekKey");
  }
}

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 255, 86, 247),
            Color.fromARGB(255, 105, 207, 255),
            Colors.white
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the screen before the quiz screen
        // Prevent going back to the quiz screen
        Navigator.pop(context);
        return false;
      },
     child: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 233, 215),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50,),
                Container(
                  height: 100,
                  width: 300,
                  child: Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "Quiz Score: ${widget.score}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                if (widget.incorrectQuestions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.incorrectQuestions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color.fromARGB(255, 239, 214, 163),
                          child: ListTile(
                            title: Column(
                              children: [
                                Image.network(
                                  widget.incorrectQuestions[index]['question'],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Correct Solution: ${widget.incorrectQuestions[index]['correctSolution']}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
