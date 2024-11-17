import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Play_incorrect_simple_sentences extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  var score1;

  Play_incorrect_simple_sentences({Key? key, required this.incorrectQuestions, required this.score1})
      : super(key: key);

  @override
  State<Play_incorrect_simple_sentences> createState() =>
      _Play_incorrect_simple_sentencesState();
}

class _Play_incorrect_simple_sentencesState
    extends State<Play_incorrect_simple_sentences> {
  late VideoPlayerController _controller;

  List<Map<String, dynamic>> incorrectQuestions = [];
  List<Map<String, dynamic>> selectedQuestions = [];
  VideoPlayerController? videoController;
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
    videoController?.removeListener(() {});
    videoController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<String> generateOptions(String correctSolution) {
    List<String> Simple_sentences = ['I live in a house', 'People are living in India', 'Airplane fly over India', 'Student sees the teacher', 'I talk to friends', 'I wake up in the morning to work', 'You go to school in the morning', 'You read the school book', 'They look at the birds', 'I drink tea in morning', 'Teacher loves my work', 'Mother drank tea at office','Girl child is washing her hands','We are drinking tea'];
    List<String> options = [];

    options.add(correctSolution); // Add the correct answer

    // Remove the correct solution from the Simple_sentences list to avoid duplication
    Simple_sentences.remove(correctSolution);

    Random random = Random();

    while (options.length < 4) {
      // Select a random pronoun from the remaining options
      String randomPronoun = Simple_sentences[random.nextInt(Simple_sentences.length)];
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
  double cardHeight = screenHeight * 0.23;  // Adjust this as per your requirement

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
        width: cardWidth,  // Fixed width
        height: cardHeight,  // Fixed height
        child: Card(
          elevation: screenWidth < 600 ? 8 : 12,
          color: _cardColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.050,
              horizontal: screenWidth * 0.04,
            ),
            child: Center(
              child: Text(
                currentOptions[index],
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 16 : 20,  // Reduced font size
                  color: _textColors[index],
                  fontWeight: FontWeight.bold,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: screenHeight * 0.35,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 133, 37),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(0,
                              -screenHeight * 0.02), // Adjusted with MediaQuery
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.059),
                            child: Text(
                              'Quiz Mania',
                              style: TextStyle(
                                fontFamily: 'RubikWetPaint',
                                fontSize: isSmallScreen ? 32 : 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.001),
                        Transform.translate(
                          offset: Offset(
                              0,
                              -screenHeight *
                                  0.059), // Adjusted with MediaQuery
                          child: Text(
                            "Identify the signs for each noun",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: SingleChildScrollView(
                      child: Transform.translate(
                        offset: Offset(0,-screenHeight * 0.17), // Adjusted with MediaQuery
                        child: Container(
                          height: screenHeight * 0.5,
                          width: screenWidth * 0.8,
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
                                    'Question ${10 - selectedQuestions.length + 1}/10',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 206, 109, 30),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.43,
                                  child: Center(
                                    child: videoController != null &&
                                            videoController!.value.isInitialized
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: videoController!
                                                    .value.aspectRatio,
                                                child: VideoPlayer(
                                                    videoController!),
                                              ),
                                              if (videoController!
                                                      .value.position ==
                                                  videoController!
                                                      .value.duration)
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.replay,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    videoController!
                                                        .seekTo(Duration.zero);
                                                    videoController!.play();
                                                    setState(() {});
                                                  },
                                                ),
                                            ],
                                          )
                                        : CircularProgressIndicator(
                                            color: const Color.fromARGB(
                                                255, 189, 74, 2),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0001),
                  for (int rowIndex = 0;
                      rowIndex < (currentOptions.length / 2).ceil();
                      rowIndex++)
                    Transform.translate(
                      offset: Offset(
                          0, -screenHeight * 0.16), // Adjusted with MediaQuery
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.003,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (rowIndex * 2 < currentOptions.length)
                              buildOptionCard(rowIndex * 2),
                            if (rowIndex * 2 + 1 < currentOptions.length)
                              buildOptionCard(rowIndex * 2 + 1),
                          ],
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.08,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: LinearProgressIndicator(
                            value: (10 - selectedQuestions.length) / 10,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 189, 74, 2)),
                            backgroundColor:
                                const Color.fromARGB(255, 189, 187, 187),
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
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: const Text(
              "Wohoo !! There are no incorrect questions",
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16), // Add spacing between card and button
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          label: const Text("Back To Result Screen",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ), // Set button color to orange
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
