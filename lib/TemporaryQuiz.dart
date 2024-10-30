import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int selectedAnswer = -1;
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questionsAndSolutions = [
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png', 'solution': 'A'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png', 'solution': 'B'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png', 'solution': 'C'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png', 'solution': 'D'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png', 'solution': 'E'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/F_fzej17.png', 'solution': 'F'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png', 'solution': 'G'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/H_hv5qdm.png', 'solution': 'H'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/I_alfmyv.png', 'solution': 'I'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/J_kv1mk8.png', 'solution': 'J'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png', 'solution': 'K'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/L_mkou5r.png', 'solution': 'L'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/M_bboxf8.png', 'solution': 'M'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/N_rvbtxz.png', 'solution': 'N'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png', 'solution': 'O'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/P_xczbe3.png', 'solution': 'P'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/Q_h2pzug.png', 'solution': 'Q'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png', 'solution': 'R'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/S_d7ctxo.png', 'solution': 'S'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png', 'solution': 'T'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/U_gvylmm.png', 'solution': 'U'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/V_ansgpz.png', 'solution': 'V'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/W_bkgjob.png', 'solution': 'W'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/X_kedszo.png', 'solution': 'X'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Y_z2fkfj.png', 'solution': 'Y'},
    { 'question': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/Z_xqqrra.png', 'solution': 'Z'},
  ];

  List<Map<String, dynamic>> selectedQuestions = [];

  @override
  void initState() {
    super.initState();
    generateRandomQuestions();
  }

  void generateRandomQuestions() {
    // Ensure there are enough questions
    if (questionsAndSolutions.length < 6) {
      print("Insufficient questions in the questionsAndSolutions list.");
      return;
    }

    // Shuffle and select first 6 questions
    questionsAndSolutions.shuffle();
    selectedQuestions = questionsAndSolutions.take(6).toList();

    // Debugging: Print selected questions to verify
    print("Selected Questions: $selectedQuestions");
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz App")),
        body: Center(child: Text("No questions available. Please check the data.")),
      );
    }

    var currentQuestion = selectedQuestions[currentQuestionIndex];
    var correctAnswer = currentQuestion['solution'];
    List<String> options = [correctAnswer];

    // Generate random options
    while (options.length < 4) {
      String option = String.fromCharCode(65 + Random().nextInt(26));
      if (!options.contains(option)) options.add(option);
    }
    options.shuffle();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 133, 37),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Orange section with "Quiz Mania" title
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 252, 133, 37),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          // Card with question image
          Transform.translate(
            offset: const Offset(0, -80),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // Question Card
                  Container(
                    width:400,
                    height: 250,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
  
                            SizedBox(height: 10),
                            Image.network(
                              currentQuestion['question'],
                              height: 200,
                              width: 300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAnswer == index ? Colors.orange : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => selectAnswer(index),
                    child: Text(
                      options[index],
                      style: TextStyle(fontSize: 20, color: selectedAnswer == index ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),
          // Next Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (currentQuestionIndex < selectedQuestions.length - 1) {
                  setState(() {
                    currentQuestionIndex++;
                    selectedAnswer = -1; // Reset selected answer
                  });
                } else {
                  // Show result or navigate to result page
                  // For now, you can reset to the first question for demo purposes
                  setState(() {
                    currentQuestionIndex = 0;
                    selectedAnswer = -1; // Reset selected answer
                  });
                }
              },
              child: Text("Next", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
