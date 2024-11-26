import 'dart:math';
import 'package:flutter/material.dart';

class Play_Incorrect_Solution_Alphabet extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  Play_Incorrect_Solution_Alphabet({Key? key, required this.incorrectQuestions})
      : super(key: key);

  @override
  State<Play_Incorrect_Solution_Alphabet> createState() =>
      _Play_Incorrect_Solution_AlphabetState();
}

class _Play_Incorrect_Solution_AlphabetState
    extends State<Play_Incorrect_Solution_Alphabet> {
  List<Map<String, dynamic>> incorrectQuestions = [];
  List<Map<String, dynamic>> selectedQuestions = [];
  List<String> currentOptions = [];
  List<Color> _cardColors = List.filled(4, Colors.white);
  List<Color> _textColors = List.filled(4, Colors.black);

  int score = 0;
  int correctcount = 0;
  int incorrectcount = 0;
  int selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    incorrectQuestions = widget.incorrectQuestions;
    // Initialize selectedQuestions with incorrectQuestions
    selectedQuestions = List.from(incorrectQuestions);
    setOptionsForQuestion();
  }

  List<String> generateOptions(String correctSolution) {
    List<String> options = [];
    options.add(correctSolution); // Add correct answer

    Random random = Random();
    // Generate random wrong options
    while (options.length < 4) {
      String randomLetter = String.fromCharCode(65 + random.nextInt(26)); // A-Z
      if (!options.contains(randomLetter)) {
        options.add(randomLetter);
      }
    }

    options.shuffle(); // Shuffle options to mix them
    return options;
  }

  void setOptionsForQuestion() {
    if (selectedQuestions.isNotEmpty) {
      currentOptions = generateOptions(selectedQuestions[0]['correctSolution']);
    }
  }

void _answerQuestion(
      String selectedOption, String correctSolution, int index) {
    setState(() {
      selectedOptionIndex = index; // Mark the selected option
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


    // 1-second delay before showing the next question
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
         Navigator.pop(context);
      }
    });
  }



 @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen =
        screenWidth < 600; // You can adjust this threshold based on your needs

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange section with "Quiz Mania" title
                  Container(
                    height: screenHeight *
                        0.4, // Adjust height based on screen size
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 133, 37),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Align(
                      alignment: Alignment.center, // Align text to the left
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight *
                                    0.050), // Add top padding for text
                            child: Text(
                              'Quiz Mania',
                              style: TextStyle(
                                fontFamily:
                                    'RubikWetPaint', // Use the custom font family
                                fontSize: isSmallScreen
                                    ? 38
                                    : 40, // Font size adjustment
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Text(
                            "Identify the below signs of alphabets",
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
                      padding: EdgeInsets.all(
                          isSmallScreen ? 8 : 16), // Padding adjustment
                      child: Container(
                        width: screenWidth *
                            0.9, // Width adjustment based on screen size
                        height: screenHeight *
                            0.4, // Adjust height based on screen size
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Display the question number
                                Text(
                                  'Question ${6 - selectedQuestions.length + 1}/6', // Show the question number
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 16
                                        : 20, // Font size adjustment
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 206, 109, 30),
                                  ),
                                ),
                                // Display the image
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Color.fromARGB(255, 189, 74, 2),
                                      ),
                                      Image.network(
                                        selectedQuestions[0]['question'],
                                        fit: BoxFit.contain,
                                        height: isSmallScreen
                                            ? screenHeight * 0.3
                                            : screenHeight *
                                                0.25, // Image height adjustment
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
                  // Display options in two rows with two options each
                  for (int i = 0; i < 2; i++) ...[
                    Transform.translate(
                      offset: Offset(0, -screenHeight * 0.18),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                isSmallScreen ? 8 : 16), // Padding adjustment
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

Widget buildOptionCard(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      child: GestureDetector(
        onTap: selectedOptionIndex == -1
            ? () => _answerQuestion(
                  currentOptions[index],
                  selectedQuestions[0]['correctSolution'],
                  index,
                )
            : null, // Disable tap if an option is already selected
        child: Card(
          elevation: screenWidth < 600 ? 8 : 12,
          color: _cardColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03, // Adjust vertical padding based on screen size
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
}
