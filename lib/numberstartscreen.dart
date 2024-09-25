import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/learnalphabet.dart';
import 'package:flutter_login_signup/learnnumbers.dart';
import 'package:flutter_login_signup/moveforwardtonumbers.dart';

void main() {
  runApp(MyApp());
}
class NumberStartScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Color.fromARGB(255, 207, 238, 252), // Set the app bar background color
      ),
      body: QuizScreen(),
    );
  }

}
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _quizData = [
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1O_KggV8RMdHKzg03Ic0ppLMXwxZcmK-T',
      'options': ['8', '6', '10', '0'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OeomXu7e7XPOIlaceHLECx8gkYzUAmNT',
      'options': ['7', '8', '5', '2'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://drive.usercontent.google.com/download?id=1OZqxsYspFey5EAj1VHRCtxLLAP6mGoVU&authuser=1',
      'options': ['5', '3', '1', '0'],
      'correctIndex': 0,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OZ_3Ny15MZcD7dFenWoba0exuzgXjPl8',
      'options': ['2', '1', '0', '10'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OZnpkgNZTcYGAOS_RtyOUGeL8wL-9RSw',
      'options': ['4', '6', '7', '2'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OcwqxUUqa_sH0PVX4e0iD223mbWg2PSu',
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
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
      });
    });

    // Move to the next question or result screen
    Future.delayed(Duration(seconds: 1), () {
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
        decoration: BoxDecoration(
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
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showRibbons = true;

  @override
  void initState() {
    super.initState();
    // Hide the ribbons after 5 seconds
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showRibbons = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        backgroundColor: Color.fromARGB(255, 207, 238, 252), // Set the app bar background color
      ),
      body: Container(
        decoration: BoxDecoration(
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
            _showRibbons ? Positioned.fill(child: Image.asset('images/greenleaf.gif', fit: BoxFit.cover)) : SizedBox(),
            SingleChildScrollView( // Wrap the Column with SingleChildScrollView
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the wooden background image
                    Stack(
                      children: [
                        Image.asset('images/wooden2.png'),
                        // Overlay the score text on the wooden background image
                        Positioned(
                          bottom: 50, // Adjust the position of the text as needed
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Your Score: ${widget.score}/${widget.totalQuestions * 100}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Set text to bold
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LearnNumbers()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('images/learn.png'), // Set the image for the "Learn" button
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Add spacing between buttons
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
                              child: Image.asset('images/move.png'), // Set the image for the "Move Forward" button
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
