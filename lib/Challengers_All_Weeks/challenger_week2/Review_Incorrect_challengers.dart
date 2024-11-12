import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  VideoWidget(this.videoUrl);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose();
      _initializeController();
    }
  }

  void _initializeController() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update UI after initialization
      }).catchError((error) {
        print("Video initialization error: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                if (!_controller.value.isPlaying)
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: _togglePlayPause,
                  ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class Review_Incorrect_Challengers extends StatefulWidget {
  final List<Map<String, dynamic>>? incorrectChallenger;

  const Review_Incorrect_Challengers({
    Key? key,
    required this.incorrectChallenger,
  }) : super(key: key);

  @override
  State<Review_Incorrect_Challengers> createState() =>
      _Review_Incorrect_ChallengersState();
}

class _Review_Incorrect_ChallengersState
    extends State<Review_Incorrect_Challengers> {
  int currentChallengeIndex = 0;
  late List<String?> solution;
  late List<Map<String, dynamic>> challengeData;

  @override
  void initState() {
    super.initState();
    challengeData = widget.incorrectChallenger ?? [];
    _initializeChallenge();
  }

  void _initializeChallenge() {
    var currentChallenge = challengeData[currentChallengeIndex];
    var solutionList = currentChallenge['solution'] as List<dynamic>;
    var urlsMap = currentChallenge['urls'] as Map<String, String>;

    solution = solutionList.map<String?>((s) => urlsMap[s as String]).toList();
  }

  void _moveToNextChallenge() {
    if (currentChallengeIndex < challengeData.length - 1) {
      setState(() {
        currentChallengeIndex++;
        _initializeChallenge();
      });
    } else {
      // All challenges completed; handle navigation or completion here
    }
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: const Color.fromARGB(255, 252, 133, 37),
                      child: Center(
                        child: Text(
                          imagePath,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        title: const Text("Review Incorrect Challengers"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        _buildCard(
                          onTap: () {},
                          imagePath: '${currentChallengeIndex + 1}',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          title: 'Review Your Mistakes In Challenger Round',
                          description:
                              "Tap Next to see your mistakes one by one",
                          index: 2,
                        ),
                        Material(
                          elevation: screenHeight * 0.01,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          child: Container(
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              color: Colors.white,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  challengeData[currentChallengeIndex]['urls'][
                                      'Solution_Box.PNG'], // Your solution box image
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.2,
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  children: List.generate(
                                    challengeData[currentChallengeIndex]
                                            ['solution_vids']
                                        .length,
                                    (index) => Flexible(
                                      child: VideoWidget(
                                        challengeData[currentChallengeIndex]
                                                ['urls']
                                            [challengeData[currentChallengeIndex]
                                                ['solution_vids'][index]],
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
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(solution.length, (index) {
                    return Container(
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        child: solution[index] != null
                            ? Image.network(
                                solution[index]!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(),
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.06),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 252, 133, 37),
                  ),
                  onPressed: () {
                    if (currentChallengeIndex < challengeData.length - 1) {
                      _moveToNextChallenge();
                    } else {
                      Navigator.pop(
                          context); // Pops the current screen when "Finish" is clicked
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 252, 133, 37),
                        ),
                      ),
                      Icon(
                        currentChallengeIndex < challengeData.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
