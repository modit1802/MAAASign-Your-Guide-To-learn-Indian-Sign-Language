import 'package:flutter/material.dart';

class Review_Incorrect_Solution extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  Review_Incorrect_Solution({Key? key, required this.incorrectQuestions})
      : super(key: key);

  @override
  State<Review_Incorrect_Solution> createState() =>
      _Review_Incorrect_SolutionState();
}

class _Review_Incorrect_SolutionState extends State<Review_Incorrect_Solution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review Incorrect Answers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 252, 133, 37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 252, 133, 37),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.incorrectQuestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.incorrectQuestions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      color: const Color.fromARGB(255, 250, 233, 215),
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "English: ${widget.incorrectQuestions[index]['question']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "ISL: ${widget.incorrectQuestions[index]['correctSolution']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
