import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/thirdstep.dart';

class PracticeAssignment1 extends StatefulWidget {
  @override
  _PracticeAssignment1State createState() => _PracticeAssignment1State();
}

class _PracticeAssignment1State extends State<PracticeAssignment1> {
  List<Map<String, dynamic>> questionsAndSolutions = [
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png', 'solution': 'A'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png', 'solution': 'B'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png', 'solution': 'C'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png', 'solution': 'D'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png', 'solution': 'E'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/F_fzej17.png', 'solution': 'F'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png', 'solution': 'G'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/H_hv5qdm.png', 'solution': 'H'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/I_alfmyv.png', 'solution': 'I'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/J_kv1mk8.png', 'solution': 'J'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png', 'solution': 'K'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/L_mkou5r.png', 'solution': 'L'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/M_bboxf8.png', 'solution': 'M'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/N_rvbtxz.png', 'solution': 'N'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png', 'solution': 'O'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/P_xczbe3.png', 'solution': 'P'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/Q_h2pzug.png', 'solution': 'Q'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png', 'solution': 'R'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/S_d7ctxo.png', 'solution': 'S'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png', 'solution': 'T'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/U_gvylmm.png', 'solution': 'U'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/V_ansgpz.png', 'solution': 'V'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/W_bkgjob.png', 'solution': 'W'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/X_kedszo.png', 'solution': 'X'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Y_z2fkfj.png', 'solution': 'Y'},
    {'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Z_xqqrra.png', 'solution': 'Z'},
  ];

  List<Map<String, dynamic>> selectedQuestions = [];
  Random random = Random();
  int score = 0;
  int selectedOptionIndex = -1;
  List<String> currentOptions = [];
  bool isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    generateRandomQuiz();
    setOptionsForQuestion(); // Generate options for the first question
  }

  void generateRandomQuiz() {
    selectedQuestions = [...questionsAndSolutions]..shuffle();
    selectedQuestions = selectedQuestions.sublist(0, 6); // Select 6 random questions
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
      String randomLetter = String.fromCharCode(65 + random.nextInt(26)); // Generate random letter A-Z
      if (!options.contains(randomLetter)) {
        options.add(randomLetter);
      }
    }

    options.shuffle(); // Shuffle options to mix them
    return options;
  }

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(String selectedOption, String correctSolution, int index) {
    setState(() {
      selectedOptionIndex = index; // Mark the selected option
      if (selectedOption == correctSolution) {
        score += 100;
        _cardColors[index] = Colors.green;
        _textColors[index] = Colors.white;
      } else {
        _cardColors[index] = Colors.red;
        _textColors[index] = Colors.white;
      }
    });

    // 2-3 seconds delay before showing the next question
    Future.delayed(const Duration(seconds: 2), () {
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
            builder: (context) => ResultScreen(score: score, totalQuestions: 6),
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
        backgroundColor:Color.fromARGB(255, 255, 150, 250),
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
                              value: (6 - selectedQuestions.length + 1) / 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 5, 142, 255)),
                                                  ),
                            ),
                                                
                          ),
                          const SizedBox(height: 20),
                          // Card containing the loading and image display
                          Card(
                            child: FutureBuilder(
                              future: precacheImage(NetworkImage(selectedQuestions[0]['question']), context),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  // Show the image once it's loaded
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Image.network(
                                      selectedQuestions[0]['question'],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  // Show circular progress indicator while loading
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentOptions.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (selectedOptionIndex == -1) {
                                    _answerQuestion(currentOptions[index], selectedQuestions[0]['solution'], index);
                                  }
                                },
                                child: Card(
                                  color: _cardColors[index],
                                  child: Center(
                                    child: Text(
                                      currentOptions[index],
                                      style: TextStyle(color: _textColors[index], fontSize: 24),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'No questions available',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          ),
          
           
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $score / ${totalQuestions * 100}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Thirdstep(score: 0))); // Go back to the quiz
              },
              child: const Text('Back to Quiz'),
            ),
          ],
          
        ),
      ),
      
    );
  }
}
