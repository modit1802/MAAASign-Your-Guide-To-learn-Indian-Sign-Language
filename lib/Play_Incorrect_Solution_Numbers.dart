import 'dart:math';
import 'package:flutter/material.dart';

class Play_Incorrect_Solution_Numbers extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  Play_Incorrect_Solution_Numbers({Key? key, required this.incorrectQuestions})
      : super(key: key);

  @override
  State<Play_Incorrect_Solution_Numbers> createState() =>
      _Play_Incorrect_Solution_NumbersState();
}

class _Play_Incorrect_Solution_NumbersState
    extends State<Play_Incorrect_Solution_Numbers> {
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
    String randomNumber = random.nextInt(11).toString(); // Generate a random number between 0 and 10
    if (!options.contains(randomNumber)) {
      options.add(randomNumber);
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

  void _answerQuestion(String selectedOption, String correctSolution, int index) {
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

  Widget buildOptionCard(int index) {
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
          elevation: 12,
          color: _cardColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                currentOptions[index],
                style: TextStyle(
                  fontSize: 28,
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 233, 215),
      body: selectedQuestions.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange section with "Quiz Mania" title
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 133, 37),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 400,
                        height: 360,
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
                                  'Question ${6 - selectedQuestions.length + 1}/6',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 206, 109, 30),
                                  ),
                                ),
                                // Display the image
                                Center(
                                  child: Image.network(
                                    selectedQuestions[0]['question'],
                                    fit: BoxFit.contain,
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
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildOptionCard(0),
                          buildOptionCard(1),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -180),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildOptionCard(2),
                          buildOptionCard(3),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -160),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.080,
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
            child: Text(
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
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          label: Text("Back To Result Screen",style: TextStyle(color: Colors.white),),
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
