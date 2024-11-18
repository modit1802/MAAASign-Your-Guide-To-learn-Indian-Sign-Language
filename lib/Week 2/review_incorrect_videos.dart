import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReviewIncorrectSolution extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  ReviewIncorrectSolution({Key? key, required this.incorrectQuestions})
      : super(key: key);

  @override
  State<ReviewIncorrectSolution> createState() =>
      _ReviewIncorrectSolutionState();
}

class _ReviewIncorrectSolutionState extends State<ReviewIncorrectSolution> {
  late List<VideoPlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize VideoPlayerControllers for each video in the incorrect questions list
    _controllers =
        widget.incorrectQuestions.map<VideoPlayerController>((question) {
      final controller = VideoPlayerController.network(question['question']);
      controller.initialize().then((_) {
        setState(() {});
        controller.setVolume(0.0); // Refresh UI after video initialization
        controller.play(); // Autoplay on initialization
      });
      // Listen for video end to update the UI
      controller.addListener(() {
        if (controller.value.position == controller.value.duration) {
          setState(() {}); // Update UI to show play icon
        }
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    // Dispose of all VideoPlayerControllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.incorrectQuestions.length,
                    itemBuilder: (context, index) {
                      final controller = _controllers[index];
                      return Card(
                        elevation: 8,
                        color: const Color.fromARGB(255, 250, 233, 215),
                        child: ListTile(
                          title: Column(
                            children: [
                              if (controller.value.isInitialized)
                                AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (controller.value.isPlaying) {
                                      controller.pause();
                                    } else {
                                      controller.play();
                                    }
                                  });
                                },
                                child: Icon(
                                  controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
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
