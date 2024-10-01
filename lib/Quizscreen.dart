import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'learnalphabet.dart';
import 'moveforward.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      home: Quiz_Screen(),
    );
  }
}

class Quiz_Screen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<Quiz_Screen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _quizData = [
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
      'options': ['C', 'D', 'A', 'B'],
      'correctIndex': 0,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png',
      'options': ['D', 'Z', 'M', 'N'],
      'correctIndex': 0,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png',
      'options': ['D', 'E', 'P', 'O'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png',
      'options': ['Q', 'R', 'G', 'T'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/K_rv6591.png',
      'options': ['W', 'M', 'K', 'O'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/M_bboxf8.png',
      'options': ['M', 'S', 'T', 'U'],
      'correctIndex': 1,
    },
  ];

  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  void _answerQuestion(int selectedOptionIndex) {
    if (selectedOptionIndex == _quizData[_currentQuestionIndex]['correctIndex']) {
      setState(() {
        _score += 100;
        _cardColors[selectedOptionIndex] = Colors.green;
        _textColors[selectedOptionIndex] = Colors.white;
      });
    } else {
      setState(() {
        _cardColors[selectedOptionIndex] = Colors.red;
        _textColors[selectedOptionIndex] = Colors.white;
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_currentQuestionIndex < _quizData.length - 1) {
          _currentQuestionIndex++;
        } else {
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Play Quiz"),
        backgroundColor: Color.fromARGB(255, 207, 238, 252),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ), // Removes shadow from AppBar
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      _quizData[_currentQuestionIndex]['questionGifUrl'],
                      height: 300,
                      width: double.infinity,
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
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () => _answerQuestion(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _quizData[_currentQuestionIndex]['options'][index],
                              style: TextStyle(
                                color: _textColors[index],
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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),// Removes shadow from AppBar
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
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Image.asset('images/wooden2.png'),
                        Positioned(
                          bottom: 50,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Your Score: ${widget.score}/${widget.totalQuestions * 100}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Add your functionality here
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>LearnAlphabet()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('images/learn.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Add your functionality here
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>MoveForward(score: widget.score)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('images/move.png'),
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
