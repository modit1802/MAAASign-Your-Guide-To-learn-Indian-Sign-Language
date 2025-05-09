import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PLay_Incorrect_Bingo extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  var score1;

  PLay_Incorrect_Bingo({Key? key, required this.incorrectQuestions, required this.score1})
      : super(key: key);

  @override
  State<PLay_Incorrect_Bingo> createState() =>
      _PLay_Incorrect_BingoState();
}

class _PLay_Incorrect_BingoState
    extends State<PLay_Incorrect_Bingo> {
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

  List<String> generateOptions(String correctSolution) {
    List<String> adverbs = [
      'Quickly', 'Hard', 'Now', 'Soon', 'Tomorrow', 'Today', 'Yesterday',
      'Here', 'There', 'Always', 'Often', 'Sometimes', 'Rarely',
      'Never', 'Very', 'Enough', 'Already'
    ];
    List<String> options = [];

    options.add(correctSolution); // Add the correct answer

    // Remove the correct solution from the pronouns list to avoid duplication
    adverbs.remove(correctSolution);

    Random random = Random();

    while (options.length < 4) {
      // Select a random pronoun from the remaining options
      String randomPronoun = adverbs[random.nextInt(adverbs.length)];
      if (!options.contains(randomPronoun)) {
        options.add(randomPronoun);
      }
    }

    options.shuffle();
    return options;
  }


  void setOptionsForQuestion() {
    if (selectedQuestions.isNotEmpty) {
      currentOptions = generateOptions(selectedQuestions[0]['correctSolution']);
      _initializeVideo(selectedQuestions[0]['question']); // Load video for the question
    }
  }

  void _answerQuestion(
      String selectedOption, String correctSolution, int index) {
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

      if (selectedQuestions.length > 1) {
        selectedQuestions.removeAt(0);
        setOptionsForQuestion();
      } else {
        Navigator.pop(context);
      }
    });
  }

  Widget buildOptionCard(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (index >= currentOptions.length || index >= _cardColors.length || index >= _textColors.length) {
      return SizedBox.shrink();
    }

    return Expanded(
      child: GestureDetector(
        onTap: selectedOptionIndex == -1
            ? () => _answerQuestion(
          currentOptions[index],
          selectedQuestions[0]['correctSolution'] ?? 'No Solution',
          index,
        )
            : null,
        child: Card(
          elevation: screenWidth < 600 ? 8 : 12,
          color: _cardColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.03,
              horizontal: screenWidth * 0.04,
            ),
            child: Center(
              child: Text(
                currentOptions[index],
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 20 : 28,
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
                      padding: EdgeInsets.only(top: screenHeight * 0.050),
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
                      "Identify the below signs of Adverbs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.18),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Question ${6 - selectedQuestions.length + 1}/6',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 206, 109, 30),
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.25,
                          child: Center(
                            child: _controller.value.isInitialized
                                ? Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                if (_controller.value.position == _controller.value.duration)
                                  IconButton(
                                    icon: Icon(
                                      Icons.replay,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      _controller.seekTo(Duration.zero);
                                      _controller.play();
                                      setState(() {});
                                    },
                                  ),
                              ],
                            )
                                : CircularProgressIndicator(
                              color: const Color.fromARGB(255, 189, 74, 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            for (int i = 0; i < 2; i++) ...[
              Transform.translate(
                offset: Offset(0, -screenHeight * 0.18),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
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
              offset: Offset(0, -screenHeight * 0.13),
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
                        'Your Score: $score',
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
