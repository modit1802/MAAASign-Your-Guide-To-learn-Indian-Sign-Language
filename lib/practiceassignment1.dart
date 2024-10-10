import 'dart:math';
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
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png',
      'solution': 'A'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png',
      'solution': 'B'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
      'solution': 'C'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png',
      'solution': 'D'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png',
      'solution': 'E'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/F_fzej17.png',
      'solution': 'F'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png',
      'solution': 'G'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/H_hv5qdm.png',
      'solution': 'H'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/I_alfmyv.png',
      'solution': 'I'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/J_kv1mk8.png',
      'solution': 'J'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png',
      'solution': 'K'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/L_mkou5r.png',
      'solution': 'L'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/M_bboxf8.png',
      'solution': 'M'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/N_rvbtxz.png',
      'solution': 'N'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
      'solution': 'O'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/P_xczbe3.png',
      'solution': 'P'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/Q_h2pzug.png',
      'solution': 'Q'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png',
      'solution': 'R'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/S_d7ctxo.png',
      'solution': 'S'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png',
      'solution': 'T'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/U_gvylmm.png',
      'solution': 'U'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/V_ansgpz.png',
      'solution': 'V'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/W_bkgjob.png',
      'solution': 'W'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/X_kedszo.png',
      'solution': 'X'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Y_z2fkfj.png',
      'solution': 'Y'
    },
    {
      'question':
          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Z_xqqrra.png',
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
      appBar: AppBar(
        title: const Text("Quiz Practice"),
        backgroundColor: const Color.fromARGB(255, 255, 150, 250),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 150, 250),
                  Color.fromARGB(255, 159, 223, 252),
                  Colors.white
                ],
              ),
            ),
            child: selectedQuestions.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.080,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: LinearProgressIndicator(
                                value: (6 - selectedQuestions.length) / 6,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.purple),
                                backgroundColor: Colors.grey[200],
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
                                color: Color.fromARGB(255, 76, 13, 110),
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
          ),
        ],
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
      
      if (userDoc == null) {
        // If user doesn't exist, insert new document
        await userCollection.insert({
          'userId': userId,
          'week': {
            'week1': {
              'score': widget.score,
              'incorrectQuestions': widget.incorrectQuestions,
            }
          }
        });
      } else {
        // If user exists, update their week 1 data
        await userCollection.update(
          mongo.where.eq('userId', userId),
          mongo.modify.set('week.week1', {
            'score': widget.score,
            'incorrectQuestions': widget.incorrectQuestions,
          }),
        );
      }

      print("Data inserted/updated for user ID: $userId");
    }
  }

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Result"),
        backgroundColor: const Color.fromARGB(255, 255, 150, 250),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Your Score: ${widget.score}/${widget.totalQuestions * 100}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (widget.incorrectQuestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.incorrectQuestions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 255, 240, 210),
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
    );
  }
}
