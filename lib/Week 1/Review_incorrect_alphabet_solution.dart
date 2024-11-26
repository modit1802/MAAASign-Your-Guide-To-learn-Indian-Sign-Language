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
        body: widget.incorrectQuestions.isNotEmpty
            ? Container(
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
                        child: ListTile(
                          title: Column(
                            children: [
                              Image.network(
                                widget.incorrectQuestions[index]['question'],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Correct Solution: ${widget.incorrectQuestions[index]['correctSolution']}",
                                style: const TextStyle(
                                  fontSize: 20,
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
        )
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/celebrate-cat.gif', // Replace with your GIF path
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Congratulations! 🎉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You got all the answers correct!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
