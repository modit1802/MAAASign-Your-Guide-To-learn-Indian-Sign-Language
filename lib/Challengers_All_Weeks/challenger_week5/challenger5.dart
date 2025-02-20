import 'package:SignEase/Challengers_All_Weeks/challenger_Week4/Result_Challenger_Week4.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_Week4/tutorialscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart';
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
    _initializeController(widget.videoUrl);
  }

   @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the video URL has changed
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose(); // Dispose of the old controller
      _initializeController(widget.videoUrl); // Initialize new controller
    }
  }

  void _initializeController(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget once the video is initialized
      })
      ..addListener(() {
        setState(() {}); // Listen for changes in playback state
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {}); // Update the play button visibility immediately
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: 9 / 16, // Maintain 9:16 aspect ratio
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                if (!_controller
                    .value.isPlaying) // Show play button only when paused
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
        : Center(
            child:
                CircularProgressIndicator()); // Loading indicator until video initializes
  }
}

class Challenger4 extends StatelessWidget {
  final int score;

  Challenger4({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ThirdGame(score: score),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score;

  ThirdGame({required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  late int score;
  bool? isCorrectSolution;
  late VideoPlayerController _controller;
  List<Map<String, dynamic>> incorrectQuestions = [];
  int attempts = 0;
  int maxAttempts = 2;
  int currentChallengeIndex = 0; // Track the current challenge index
  bool showMoveToNextButton = false;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> challengeData = [

    {
      'question': 'Student very intelligent',
      'solution_vids': ['Student very intelligent'],
      'solution': ['student_i', 'very_i', 'intelligent_i'],
      'availableLetters': ['student_i', 'very_i', 'intelligent_i', 'happy_i'],
      'urls': {
        'Student very intelligent': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/1.mp4',
        'student_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Student.png',
        'very_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Very.png',
        'intelligent_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Intelligent.png',
        'happy_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Happy.png',
      }
    },

    {
      'question': 'Birds quickly fly',
      'solution_vids': ['Birds quickly fly'],
      'solution': ['birds_i', 'quickly_i', 'fly_i'],
      'availableLetters': ['birds_i', 'quickly_i', 'fly_i', 'run_i'],
      'urls': {
        'Birds quickly fly': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/2.mp4',
        'birds_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Birds.png',
        'quickly_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Quickly.png',
        'fly_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Fly.png',
        'run_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Run.png',
      }
    },

    {
      'question': 'People always talk',
      'solution_vids': ['People always talk'],
      'solution': ['people_i', 'always_i', 'talk_i'],
      'availableLetters': ['people_i', 'always_i', 'talk_i', 'shout_i'],
      'urls': {
        'People always talk': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/3.mp4',
        'people_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/People.png',
        'always_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Always.png',
        'talk_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Talk.png',
        'shout_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Shout.png',
      }
    },

    {
      'question': 'Mother sometimes sad',
      'solution_vids': ['Mother sometimes sad'],
      'solution': ['mother_i', 'sometimes_i', 'sad_i'],
      'availableLetters': ['mother_i', 'sometimes_i', 'sad_i', 'happy_i'],
      'urls': {
        'Mother sometimes sad': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/4.mp4',
        'mother_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Mother.png',
        'sometimes_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Sometimes.png',
        'sad_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Sad.png',
        'happy_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Happy.png',
      }
    },

    {
      'question': 'Today lunch delicious',
      'solution_vids': ['Today lunch delicious'],
      'solution': ['today_i', 'lunch_i', 'delicious_i'],
      'availableLetters': ['today_i', 'lunch_i', 'delicious_i', 'bad_i'],
      'urls': {
        'Today lunch delicious': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/5.mp4',
        'today_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Today.png',
        'lunch_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Lunch.png',
        'delicious_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Delicious.png',
        'bad_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Bad.png',
      }
    },

    {
      'question': 'She already wake-up',
      'solution_vids': ['She already wake-up'],
      'solution': ['she_i', 'already_i', 'wake-up_i'],
      'availableLetters': ['she_i', 'already_i', 'wake-up_i', 'sleep_i'],
      'urls': {
        'She already wake-up': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/6.mp4',
        'she_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/She.png',
        'already_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Already.png',
        'wake-up_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Wake-Up.png',
        'sleep_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Sleep.png',
      }
    },

    {
      'question': 'Office tomorrow busy',
      'solution_vids': ['Office tomorrow busy'],
      'solution': ['office_i', 'tomorrow_i', 'busy_i'],
      'availableLetters': ['office_i', 'tomorrow_i', 'busy_i', 'free_i'],
      'urls': {
        'Office tomorrow busy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/7.mp4',
        'office_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Office.png',
        'tomorrow_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Tomorrow.png',
        'busy_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Busy.png',
        'free_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Free.png',
      }
    },

    {
      'question': 'Fish fast swim',
      'solution_vids': ['Fish fast swim'],
      'solution': ['fish_i', 'fast_i', 'swim_i'],
      'availableLetters': ['fish_i', 'fast_i', 'swim_i', 'jump_i'],
      'urls': {
        'Fish fast swim': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/8.mp4',
        'fish_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Fish.png',
        'fast_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Fast.png',
        'swim_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Swim.png',
        'jump_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Jump.png',
      }
    },

    {
      'question': 'Teacher rarely angry',
      'solution_vids': ['Teacher rarely angry'],
      'solution': ['teacher_i', 'rarely_i', 'angry_i'],
      'availableLetters': ['teacher_i', 'rarely_i', 'angry_i', 'calm_i'],
      'urls': {
        'Teacher rarely angry': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/9.mp4',
        'teacher_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Teacher.png',
        'rarely_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Rarely.png',
        'angry_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Angry.png',
        'calm_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Calm.png',
      }
    },
    {
      'question': 'Baby never weak',
      'solution_vids': ['Baby never weak'],
      'solution': ['baby_i', 'never_i', 'weak_i'],
      'availableLetters': ['baby_i', 'never_i', 'weak_i', 'strong_i'],
      'urls': {
        'Baby never weak': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/10.mp4',
        'baby_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Baby.png',
        'never_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Never.png',
        'weak_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Weak.png',
        'strong_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Strong.png',
      }
    }
  ];
  late List<String?> solution;
  late List<String> availableLetters;

  @override
  void initState() {
    super.initState();

    score = widget.score;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showtutorialscreen();
    });
    _initializeChallenge();
  }

  void _showtutorialscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tutorial_screen_for_challenger_Week4(
          onBackPressed: () {
            Navigator.pop(
                context); // Return to the current screen on back press
          },
        ),
      ),
    );
  }



  void checkSolution() {
    if (const ListEquality()
        .equals(solution, challengeData[currentChallengeIndex]['solution'])) {
      setState(() {
        isCorrectSolution = true;
        showMoveToNextButton = true;
        if (attempts == 0) {
          score += 100;
        } else if (attempts == 1) {
          score += 50;
        }
      });
      _scrollToGif();
      Future.delayed(const Duration(seconds: 2), () {
        _moveToNextChallenge();
      });
    } else {
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          solution =
              List.from(challengeData[currentChallengeIndex]['solution']);
          isCorrectSolution = false;
          showMoveToNextButton = false;
          incorrectQuestions.add({
            'question': challengeData[currentChallengeIndex]['question'],
            'solution': challengeData[currentChallengeIndex]['solution'],
            'available_letters': challengeData[currentChallengeIndex]
                ['availableLetters'],
            'urls': challengeData[currentChallengeIndex]['urls'],
            'solution_vids':challengeData[currentChallengeIndex]['solution_vids'],
          });
        } else {
          isCorrectSolution = false;
          showMoveToNextButton = false;
        }
      });
      print(currentChallengeIndex);
      _scrollToGif();
    }
  }

 void _moveToNextChallenge() {
  if (currentChallengeIndex < challengeData.length - 1) {
    setState(() {
      currentChallengeIndex++;  // Update the current challenge index
      attempts = 0;
      isCorrectSolution = null;
      showMoveToNextButton = false;
      _initializeChallenge();  // Re-initialize the challenge data
    });
  } else {
    // Once all challenges are completed, navigate to the next screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Result_Challenger_Week4(
          score: score, 
          incorrectquestions: incorrectQuestions
        ),
      ),
    );
  }
}

void _initializeChallenge() {
  // Ensure that the new challenge data is being loaded based on the updated index
  setState(() {
    solution = List.filled(
        challengeData[currentChallengeIndex]['solution'].length, "wooden");
    availableLetters = List.from(
      challengeData[currentChallengeIndex]['availableLetters'],
    );
  });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToGif() async {
    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(seconds: 1));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
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
                        )),
                      )),
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
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Image.network(
                    challengeData[currentChallengeIndex]['urls']['correct'],
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.3,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Image.network(
                    challengeData[currentChallengeIndex]['urls']['wrong'],
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.3,
                  ),
                ),
              SizedBox(height: screenHeight * 0.13),
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      _buildCard(
                        onTap: () {},
                        imagePath: '${currentChallengeIndex + 1}',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Challenger Round',
                        description:
                            "Drag the words into the correct boxes. For help, press the 'tutorial button' on the top",
                        index: 2,
                      ),
                      Material(
                        elevation: screenHeight * 0.01,
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        child: Container(
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                             Flexible(
  child: VideoWidget(
    challengeData[currentChallengeIndex]['urls'][
        challengeData[currentChallengeIndex]['solution_vids'][0]],
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
                children: List.generate(
                    challengeData[currentChallengeIndex]['solution'].length,
                    (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != "wooden" &&
                                solution[index] != null) {
                              availableLetters.add(solution[index]!);
                              solution[index] = "wooden";
                            }
                          });
                        },
                        child: Container(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                            child: solution[index] != null
                                ? Image.network(
                                    challengeData[currentChallengeIndex]['urls']
                                        [solution[index]!]!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        if (solution[index] != "wooden" &&
                            solution[index] != null) {
                          availableLetters.add(solution[index]!);
                        }
                        solution[index] = data;
                        availableLetters.remove(data);
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.007),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter,
                    child: Image.network(
                      challengeData[currentChallengeIndex]['urls'][letter] ?? '',
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.18,
                    ),
                    feedback: Material(
                      child: Image.network(
                        challengeData[currentChallengeIndex]['urls'][letter] ?? '',
                        width: screenWidth * 0.17,
                        height: screenHeight * 0.09,
                      ),
                    ),
                    childWhenDragging: Container(),
                  );
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.007),
              if (!showMoveToNextButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 252, 133, 37),
                  ),
                  onPressed: checkSolution,
                  child: const Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 252, 133, 37),
                  ),
                  onPressed: _moveToNextChallenge,
                  child: const Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
// Score widget (Left side)
        Positioned(
          top: screenHeight * 0.06,
          left: screenWidth * 0.04,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Text(
              "Score: $score",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ),

// Tutorial widget (Center)
// Tutorial widget with information icon (Center)
        Positioned(
          top: screenHeight * 0.06,
          left:
              screenWidth * 0.35, // Adjust this to align properly in the center
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tutorial_screen_for_challenger_Week4(
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Ensures the row only takes the required space
                children: [
                  Text(
                    "Tutorial",
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(
                      width: screenWidth * 0.02), // Space between text and icon
                  Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: screenWidth * 0.05, // Adjust icon size as needed
                  ),
                ],
              ),
            ),
          ),
        ),

// Chances Left widget (Right side)
        Positioned(
          top: screenHeight * 0.06,
          right: screenWidth * 0.04,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
