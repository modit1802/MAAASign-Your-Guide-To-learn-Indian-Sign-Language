import 'dart:async'; // Required for Timer
import 'dart:math';
import 'package:flutter/material.dart';

class TrueFalseGame extends StatefulWidget {
  @override
  _TrueFalseGameState createState() => _TrueFalseGameState();
}

class _TrueFalseGameState extends State<TrueFalseGame> {
  final Random _random = Random();
  int score = 0;
  int currentQuestion = 0;
  int totalQuestions = 6;

  late String questionText;
  late bool correctAnswer;
  bool? selectedAnswer;
  bool answered = false;

  Timer? _timer;
  int remainingTime = 10;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    int a = _random.nextInt(20) + 1;
    int b = _random.nextInt(20) + 1;
    List<String> operators = ['+', '-', '*'];
    String op = operators[_random.nextInt(operators.length)];
    int result = _calculate(a, b, op);

    bool isCorrect = _random.nextBool();
    int displayedResult = isCorrect ? result : result + _random.nextInt(5) + 1;
    correctAnswer = (displayedResult == result);

    questionText = "$a $op $b = $displayedResult";

    selectedAnswer = null;
    answered = false;
    remainingTime = 10;
    _startTimer();

    setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        _handleTimeout();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      answered = true;
      selectedAnswer = null;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestion < totalQuestions - 1) {
        currentQuestion++;
        generateQuestion();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
    });
  }

  void checkAnswer(bool selected) {
    if (answered) return;

    _timer?.cancel();

    setState(() {
      selectedAnswer = selected;
      answered = true;
      if (selected == correctAnswer) {
        score += 100;
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestion < totalQuestions - 1) {
        currentQuestion++;
        generateQuestion();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
    });
  }

  int _calculate(int a, int b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      default:
        return 0;
    }
  }

  Color getButtonColor(bool value) {
    if (!answered) return Colors.white;
    if (value == correctAnswer) return Colors.green.shade700;
    if (value == selectedAnswer) return Colors.red.shade700;
    return Colors.white;
  }

  Color getTextColor(bool value) {
    if (!answered) return Colors.black87;
    if (value == correctAnswer) return Colors.green.shade800;
    if (value == selectedAnswer) return Colors.red.shade800;
    return Colors.black87;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestion + 1) / totalQuestions;

    return Scaffold(
      backgroundColor: Color(0xFFFCEFD8),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'True or False',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Check if the equation is correct',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Question ${currentQuestion + 1}/$totalQuestions',
                                style: TextStyle(fontSize: 16, color: Colors.orange),
                              ),
                              SizedBox(height: 12),
                              Text(
                                questionText,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Time Left: $remainingTime s',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: remainingTime <= 3 ? Colors.red : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        ...[true, false].map(
                              (option) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => checkAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: getButtonColor(option),
                                  foregroundColor: getTextColor(option),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                ),
                                child: Text(
                                  option ? 'True' : 'False',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEFD8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Well done!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Your Score',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '$score',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Play Again', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
