import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Retry_Mistakes extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  var score1;

  Retry_Mistakes({Key? key, required this.incorrectQuestions, required this.score1})
      : super(key: key);

  @override
  State<Retry_Mistakes> createState() =>
      _Retry_MistakesState();
}

class _Retry_MistakesState
    extends State<Retry_Mistakes> {
  late VideoPlayerController _controller;

  List<Map<String, dynamic>> incorrectQuestions = [];
  List<Map<String, dynamic>> selectedQuestions = [];
  List<String> currentOptions = [];
  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  int score = 0;
  int correctcount = 0;
  int incorrectcount = 0;
  int selectedOptionIndex = -1;
  int score1=0;

  @override
  void initState() {
    super.initState();
    incorrectQuestions = widget.incorrectQuestions;
    selectedQuestions = List.from(incorrectQuestions);
    score1=widget.score1;// Copy the questions list
    if (selectedQuestions.isNotEmpty) {
      setOptionsForQuestion();
    }
  }

  // Initialize video player controller
  void _initializeVideo(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        setState(() {}); // Update the UI after initializing
      })
      ..setLooping(true)
      ..play(); // Auto-play the video if needed
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _factorial(int n) {
    return n <= 1 ? 1 : n * _factorial(n - 1);
  }
  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution);

    // Generate permutations of the correct answer
    List<String> words = correctSolution.split(' ');
    for (int i = 0; i < 100; i++) {
      List<String> shuffled = List.from(words)..shuffle();
      String option = shuffled.join(' ');
      if (!options.contains(option)) {
        options.add(option);
      }
    }

    options.shuffle();
    return options.take(4).toList();
  }

  void setOptionsForQuestion() {
    if (selectedQuestions.isNotEmpty) {
      currentOptions = generateOptions(selectedQuestions[0]['correctSolution']);
      _initializeVideo(selectedQuestions[0]['question']); // Load video for the question
    } else {
      // Handle end of quiz scenario, show results or navigate out
      Navigator.pop(context); // Go back if no questions are left
    }
  }


  void _answerQuestion(String selectedOption, String correctSolution, int index) {
    setState(() {
      selectedOptionIndex = index;
      if (selectedOption == correctSolution) {
        score += 100;
        _cardColors[index] = Colors.green;
        _textColors[index] = Colors.white;
        correctcount++;
      } else {
        _cardColors[index] = Colors.red;
        _textColors[index] = Colors.white;
        incorrectcount++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _cardColors = List.filled(4, Colors.white);
        _textColors = List.filled(4, Colors.black);
        selectedOptionIndex = -1;
      });

      if (selectedQuestions.isNotEmpty) {
        selectedQuestions.removeAt(0); // Remove the answered question
        if (selectedQuestions.isNotEmpty) {
          setOptionsForQuestion(); // Load next question if available
        } else {
          // If no questions are left, end the quiz
          Navigator.pop(context); // You can navigate to a results screen here
        }
      }
    });
  }
  Widget buildOptionCard(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the fixed width and height for each card
    double cardWidth = screenWidth < 600 ? screenWidth * 0.8 : screenWidth * 0.6;
    double cardHeight = screenHeight * 0.25; // Increased height for more content

    return Expanded(
      child: GestureDetector(
        onTap: selectedOptionIndex == -1
            ? () => _answerQuestion(
          currentOptions[index],
          selectedQuestions[0]['solution'],
          index,
        )
            : null,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Card(
            elevation: screenWidth < 600 ? 8 : 12,
            color: _cardColors[index],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02, // Reduced padding
                horizontal: screenWidth * 0.02,
              ),
              child: Center(
                child: Flexible(
                  child: Text(
                    currentOptions[index],
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 14 : 18, // Smaller font size
                      color: _textColors[index],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3, // Or remove to allow unlimited lines
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
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
              padding: EdgeInsets.all(isSmallScreen ? 8 : 16), // Padding adjustment
              child: Container(
                width: screenWidth * 0.9, // Width adjustment based on screen size
                height: screenHeight * 0.25, // Adjust height based on screen size
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display the question number
                          Text(
                            'Question ${6 - selectedQuestions.length + 1}/6', // Show the question number
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20, // Font size adjustment
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 206, 109, 30),
                            ),
                          ),
                          // Display the image
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Display options in two rows with two options each
          for (int i = 0; i < 2; i++) ...[
            Transform.translate(
            offset: Offset(0, -screenHeight * 0.08),
            child: Padding(
            padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 16), // Padding adjustment
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            buildOptionCard(i * 2),
            buildOptionCard(i * 2 + 1),
    ],
    ),
    ),
    ),
            ],
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.05),
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
                      backgroundColor: const Color.fromARGB(255, 189, 187, 187),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'All Correct!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your Score: $score1',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
