import 'dart:async';
import 'package:SignEase/compoundsentences.dart';
import 'package:SignEase/learnnumbers.dart';
import 'package:SignEase/matchmaker_number.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class NumberStartScreen extends StatelessWidget {
  const NumberStartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: const Color.fromARGB(255, 207, 238, 252), // Set the app bar background color
      ),
      body: const QuizScreen(),
    );
  }

}
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  final List<Map<String, dynamic>> _quizData = [
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716936/10_iwh2ip.png',
      'options': ['8', '6', '10', '0'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717006/8_iml5cs.png',
      'options': ['7', '8', '5', '2'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717008/5_ag2kbp.png',
      'options': ['5', '3', '1', '0'],
      'correctIndex': 0,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717003/1_g5k8rj.png',
      'options': ['2', '1', '0', '10'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717005/7_jrfg35.png',
      'options': ['4', '6', '7', '2'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716936/0_e1tfib.png',
      'options': ['1', '0', '2', '3'],
      'correctIndex': 1,
    },
    // Add more questions here...
  ];

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(int selectedOptionIndex) {
    // Check if the selected answer is correct
    if (selectedOptionIndex == _quizData[_currentQuestionIndex]['correctIndex']) {
      // Update score and set card color to green for correct answer
      setState(() {
        _score += 100;
        _cardColors[selectedOptionIndex] = Colors.green;
        _textColors[selectedOptionIndex] = Colors.white;
      });
    } else {
      // Set card color to red for incorrect answer
      setState(() {
        _cardColors[selectedOptionIndex] = Colors.red;
        _textColors[selectedOptionIndex] = Colors.white;
      });
    }

    // Reset card colors and text colors for the next question
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
      });
    });

    // Move to the next question or result screen
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (_currentQuestionIndex < _quizData.length - 1) {
          _currentQuestionIndex++;
        } else {
          // Navigate to result screen when all questions are answered
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultScreen(score: _score, totalQuestions: _quizData.length)),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_quizData.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4, // Add elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Adjust the border radius for rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Same border radius as the Card
                    child: Image.network(
                      _quizData[_currentQuestionIndex]['questionGifUrl'],
                      height: 300,
                      width: double.infinity, // Make the image expand to full width
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(_quizData[_currentQuestionIndex]['options'].length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: _cardColors[index],
                        elevation: 4, // Add elevation for a shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Adjust the border radius for rounded corners
                        ),
                        child: TextButton(
                          onPressed: () => _answerQuestion(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _quizData[_currentQuestionIndex]['options'][index],
                              style: TextStyle(
                                color: _textColors[index], // Set text color based on user interaction
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
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

  const ResultScreen({super.key, required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showRibbons = true;

  @override
  void initState() {
    super.initState();
    // Hide the ribbons after 5 seconds
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _showRibbons = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        backgroundColor: const Color.fromARGB(255, 207, 238, 252), // Set the app bar background color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            _showRibbons
                ? Positioned.fill(
              child: Image.network(
                'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717465/greenleaf_vryta1.gif',
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox(),
            SingleChildScrollView( // Wrap the Column with SingleChildScrollView
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the wooden background image
                    Stack(
                      children: [
                        Image.network(
                          'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717492/wooden2_y0rlzl.png',
                        ),
                        // Overlay the score text on the wooden background image
                        Positioned(
                          bottom: 50, // Adjust the position of the text as needed
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Your Score: ${widget.score}/${widget.totalQuestions * 100}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Set text to bold
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Use Expanded and Flex to ensure equal size for both cards
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 4, // Add elevation for a shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Adjust the border radius for rounded corners
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Action for the "Learn" button
                              // Add your functionality here
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnNumbers()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.network(
                                'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717531/learn_cjf6uk.png', // Cloudinary image
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing between buttons
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 4, // Add elevation for a shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Adjust the border radius for rounded corners
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MoveForwardtonumbers(score: widget.score)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.network(
                                'https://res.cloudinary.com/dfph32nsq/image/upload/v1727717556/move_dtx6i4.png', // Cloudinary image
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
