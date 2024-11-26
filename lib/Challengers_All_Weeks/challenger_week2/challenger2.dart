import 'package:SignEase/Challengers_All_Weeks/challenger_week2/Result_Challenger_Week2.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week2/tutorialscreen.dart';
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
        _controller.setVolume(0.0);
        setState(() {}); // Refresh the widget once the video is initialized
      })
      ..addListener(() {
        setState(() {}); // Listen for changes in playback state
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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

class Challenger2 extends StatelessWidget {
  final int score;

  Challenger2({required this.score});

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
      'question': 'Hello Father',
      'solution_vids': ['hello', 'father'],
      'solution': ['hello_i', 'father_i'],
      'availableLetters': ['hello_i', 'namaste_i', 'father_i', 'mother_i'],
      'urls': {
        'hello':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4',
        'namaste':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/namaste_u_iptdsn.mp4',
        'father':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266839/father_u_jdbajr.mp4',
        'mother':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266834/mother_u_tkkg10.mp4',
        'hello_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/HELLO_akjme2.png',
        'namaste_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/NAMASTE_j3vc5q.png',
        'father_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/Father_evq902.png',
        'mother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/MOTHER_g4daxq.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    // challenger 2

    {
      'question': 'hy mother',
      'solution_vids': ['hy', 'mother'],
      'solution': ['hy_i', 'mother_i'],
      'availableLetters': ['hy_i', 'namaste_i', 'father_i', 'mother_i'],
      'urls': {
        'hy':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hy_u_dfsvt4.mp4',
        'namaste':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/namaste_u_iptdsn.mp4',
        'father':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266839/father_u_jdbajr.mp4',
        'mother':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266834/mother_u_tkkg10.mp4',
        'hy_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056080/HY_bjz5kv.png',
        'namaste_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/NAMASTE_j3vc5q.png',
        'father_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/Father_evq902.png',
        'mother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/MOTHER_g4daxq.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'goodbye sister',
      'solution_vids': ['goodbye', 'sister'],
      'solution': ['goodbye_i', 'sister_i'],
      'availableLetters': [
        'goodbye_i',
        'see_you_again_i',
        'sister_i',
        'brother_i'
      ],
      'urls': {
        "goodbye":
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266605/good_bye_u_hz6peg.mp4',
        "see_you_again":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/work_ejax98.mp4",
        "sister":
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266838/sister_u_wpybjz.mp4',
        "brother":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4",
        'goodbye_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/GOODBYE_hek6ie.png',
        'see_you_again_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/SEE_YOU_AGAIN_pc2591.png',
        'sister_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/SISTER_cokk0l.png',
        'brother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731057134/Brother_zp3vvl.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'good_after_noon people',
      'solution_vids': ['good_after_noon', 'people'],
      'solution': ['good_after_noon_i', 'people_i'],
      'availableLetters': [
        'people_i',
        'good_morning_i',
        'good_after_noon_i',
        'sister_i',
      ],
      'urls': {
        "good_after_noon":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/good_afternoon_u_wwhvia.mp4",
        "people":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266837/people_u_t4403p.mp4",
        'people_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/PEOPLE_hvebii.png',
        'good_morning_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/GOOD_MORNING_qspsu3.png',
        'good_after_noon_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/GOOD_AFTERNOON_bfewat.png',
        'sister_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/SISTER_cokk0l.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'welcome brother',
      'solution_vids': ['welcome', 'brother'],
      'solution': ['welcome_i', 'brother_i'],
      'availableLetters': ['sister_i', 'welcome_i', 'goodbye_i', 'brother_i'],
      'urls': {
        "welcome":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4",
        "brother":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266840/brother_u_dg76hq.mp4",
        'welcome_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/WELCOME_id8mnm.png',
        'brother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731057134/Brother_zp3vvl.png',
        'sister_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/SISTER_cokk0l.png',
        'goodbye_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/GOODBYE_hek6ie.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'hello baby',
      'solution_vids': ['hello', 'baby'],
      'solution': ['hello_i', 'baby_i'],
      'availableLetters': ['hello_i', 'sister_i', 'female_person_i', 'baby_i'],
      'urls': {
        "hello":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4",
        "baby":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266842/baby_u_p1lbqp.mp4",
        'hello_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/HELLO_akjme2.png',
        'sister_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/SISTER_cokk0l.png',
        'female_person_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/FEMALE_PERSON_l0xwzc.png',
        'baby_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/BABY_fgb8sl.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'good_night sister',
      'solution_vids': ['good_night', 'sister'],
      'solution': ['good_night_i', 'sister_i'],
      'availableLetters': ['good_night_i', 'hello_i', 'sister_i', 'baby_i'],
      'urls': {
        'good_night':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/good_night_u_sgogpu.mp4",
        'sister':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266838/sister_u_wpybjz.mp4",
        'good_night_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/GOOD_NIGHT_teyx2m.png',
        'hello_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/HELLO_akjme2.png',
        'sister_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056773/SISTER_cokk0l.png',
        'baby_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/BABY_fgb8sl.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'see_you_again man',
      'solution_vids': ['see_you_again', 'man'],
      'solution': ['see_you_again_i', 'man_i'],
      'availableLetters': ['see_you_again_i', 'mother_i', 'man_i', 'friend_i'],
      'urls': {
        'see_you_again':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266603/see_you_again_u_jfm6yv.mp4",
        'man':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266834/man_u_llmdsh.mp4",
        'see_you_again_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/SEE_YOU_AGAIN_pc2591.png',
        'mother_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/MOTHER_g4daxq.png',
        'man_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/MAN_htw6r1.png',
        'friend_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/FRIEND_twuacv.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'see_you_tomorrow friend',
      'solution_vids': ['see_you_tomorrow', 'friend'],
      'solution': ["see_you_tomorrow_i", "friend_i"],
      'availableLetters': [
        "see_you_tomorrow_i",
        "see_you_again_i",
        "friend_i",
        "father_i"
      ],
      'urls': {
        "see_you_tomorrow":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/see_you_tomorrow_u_wqcfwu.mp4",
        "friend":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266835/friend_u_nfctlk.mp4",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "see_you_tomorrow_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/SEE_YOU_TOMORROW_iwubay.png",
        'see_you_again_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/SEE_YOU_AGAIN_pc2591.png',
        'friend_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056772/FRIEND_twuacv.png',
        'father_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/Father_evq902.png',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'welcome baby',
      'solution_vids': ['welcome', 'baby'],
      'solution': ["welcome_i", "baby_i"],
      'availableLetters': ["baby_i", "hello_i", "welcome_i", "father_i"],
      'urls': {
        "welcome":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4",
        "baby":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730266842/baby_u_p1lbqp.mp4",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "welcome_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731056082/WELCOME_id8mnm.png",
        "baby_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/BABY_fgb8sl.png",
        "father_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731056771/Father_evq902.png",
        "hello_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1731056081/HELLO_akjme2.png",
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
        builder: (context) => Tutorial_screen_for_challenger_week3(
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
            'solution_vids': challengeData[currentChallengeIndex]
                ['solution_vids'],
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
        currentChallengeIndex++; // Update the current challenge index
        attempts = 0;
        isCorrectSolution = null;
        showMoveToNextButton = false;
        _initializeChallenge(); // Re-initialize the challenge data
      });
    } else {
      // Once all challenges are completed, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Result_Challenger_Week2(
              score: score, incorrectquestions: incorrectQuestions),
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
                            "Drag the greetings/relations signs into the correct boxes. For help, press the 'tutorial button' on the top",
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
                                      challengeData[currentChallengeIndex]
                                          ['solution_vids'][0]],
                                ),
                              ),
                              Flexible(
                                child: VideoWidget(
                                  challengeData[currentChallengeIndex]['urls'][
                                      challengeData[currentChallengeIndex]
                                          ['solution_vids'][1]],
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
                      challengeData[currentChallengeIndex]['urls'][letter]!,
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.18,
                    ),
                    feedback: Material(
                      child: Image.network(
                        challengeData[currentChallengeIndex]['urls'][letter]!,
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
                  builder: (context) => Tutorial_screen_for_challenger_week3(
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
