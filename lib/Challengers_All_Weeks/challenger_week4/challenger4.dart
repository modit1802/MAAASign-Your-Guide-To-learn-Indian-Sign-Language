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


    // challenger 1

    {
      'question': 'They Office Walk',
      'solution_vids': ['They Office Walk'],  // Add 3 items here
      'solution': ['They_i', 'office_i', 'walk_i'],
      'availableLetters': ['office_i', 'walk_i', 'go_i', 'They_i'],
      'urls': {
        'They Office Walk': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731990214/44_tpfxr3.mp4',
        'They_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1731952266/They_agb4za.png',
        'office_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Office_jhay8v.png',
        'walk_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Walk_ucjkq9.png',
        'go_i': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Go_kmooei.png',
        'correct': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    // challenger 2

    {
      'question': 'I Book Read',
      'solution_vids': ['I Book Read'],
      'solution': ['I_i', 'book_i', 'read_i'],
      'availableLetters': ['read_i', 'write_i', 'book_i', 'I_i'],
      'urls': {
        "I Book Read":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1731990303/45_eda2ru.mp4",
        "read_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731349370/Read_image_dayuwe.png",
        "write_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977048/Write_utov42.png",
        "book_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977160/Book_gosph2.png",
        "I_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/I_reqpgr.png",
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'He finish work',
      'solution_vids': ['He finish work'],
      'solution':['he_i','finish_i','work_i'],
      'availableLetters': ['finish_i','he_i','she_i','work_i'],
      'urls': {
        "He finish work":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1731951448/47_ah0xjy.mp4",
        'finish_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984383/Finish_a88xkj.png',

        'he_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991318/He_rwe5eo.png',
        'work_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984542/Work_eanznr.png',
        'she_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991318/She_hh9a9j.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'I You Love',
      'solution_vids': ['I You Love'],
      'solution':['I_i','You_i','Love_i'],
      'availableLetters': ['Love_i','You_i','Live_i','I_i'],
      'urls': {
        "I You Love":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1731990302/46_gtoown.mp4",
        'I_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/I_reqpgr.png',
        'Love_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731950093/Love_hhpehb.png',
        'You_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731950091/You_g6qwwc.png',
        'Live_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989201/Live_hbudpg.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'He You Talk',
      'solution_vids': ['He You Talk'],
      'solution':['he_i','you_i','talk_i'],
      'availableLetters': ['you_i','he_i','see_i','talk_i'],
      'urls': {
        "He You Talk":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1731990302/47_ah0xjy.mp4",
        'he_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991318/He_rwe5eo.png',
        'you_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731950091/You_g6qwwc.png',
        'see_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991967/See_d1in8r.png',
        'talk_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991967/Talk_wnlepw.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'It My Office',
      'solution_vids': ['It My Office'],
      'solution':['It_i','My_i','Office_i'],
      'availableLetters': ['It_i','My_i','Tea_i','Office_i'],
      'urls': {
        "It My Office":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1731990302/48_b6gjsd.mp4",
        'It_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731992279/It_jhqgf2.png',
        'My_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731992278/My_bhlngd.png',
        'Tea_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730985530/Tea_gzhp4z.png',
        'Office_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Office_jhay8v.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'I house live',
      'solution_vids': ['I house live'],
      'solution':['I_i', 'house_i','live_i'],
      'availableLetters': ['we_i','I_i','house_i','live_i'],
      'urls': {
        'I house live':
            "https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848348/16U_bymgr3.mp4",
        'I_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/I_reqpgr.png',
        'we_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/We_d4trpx.png',
        'house_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986851/House_mt8ywx.png',
        'live_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730989201/Live_hbudpg.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'Student Teacher See',
      'solution_vids': ['Student Teacher See'],
      'solution': ['student_i', 'teacher_i','see_i'],
      'availableLetters': [ 'student_i','see_i','look_i','teacher_i'],
      'urls': {
        'Student Teacher See':
        "https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848345/25U_rnebn0.mp4",
        'student_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1731945382/Student_tcwbz7.png',
        'see_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991967/See_d1in8r.png',
        'look_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1731992741/Look_uf3cld.png',
        'teacher_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/Teacher_ygovmv.png',
        'correct':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'I Friend Talk',
      'solution_vids': ['I Friend Talk'],
      'solution':["I_i","friend_i",'talk_i'],
      'availableLetters': ['talk_i',"I_i",'brother_i',"friend_i"],
      'urls': {
        "I Friend Talk":
            "https://res.cloudinary.com/dz3zoiak2/video/upload/v1731848348/23U_uswf0h.mp4",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "I_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/I_reqpgr.png",
        'talk_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731991967/Talk_wnlepw.png',
        'brother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731993138/Brother_xzmdp5.png',
        'friend_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731993137/Friend_kbpxyi.png',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

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
                            "Drag the verbs/nouns signs into the correct boxes to spell the object shown. For more information press the 'tutorial button' on the top",
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
              "${maxAttempts - attempts} Chance Left",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
