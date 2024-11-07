import 'package:SignEase/Challengers/challenger_week3//Result_Challenger_Week3.dart';
import 'package:SignEase/Challengers/challenger_week3/tutorialscreen.dart';
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

class Challenger3 extends StatelessWidget {
  final int score;

  Challenger3({required this.score});

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
  int maxAttempts = 3;
  int currentChallengeIndex = 0; // Track the current challenge index
  bool showMoveToNextButton = false;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> challengeData = [


    // challenger 1

    {
      'question': 'eat lunch',
      'solution_vids': ['eat', 'lunch'],
      'solution': ['eat_i', 'lunch_i'],
      'availableLetters': ['eat_i', 'cook_i', 'lunch_i', 'dinner_i'],
      'urls': {
        'eat':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530657/eat_yaf2hc.mp4',
        'cook':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/cook_epek8y.mp4',
        'lunch':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530818/lunch_cbcgwu.mp4',
        'dinner':
            'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530815/dinner_blbwzm.mp4',
        'eat_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730974723/Eat_vf1awm.png',
        'cook_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730974895/Cook_qmzd54.png',
        'lunch_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730974959/Lunch_lgyo07.png',
        'dinner_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730975017/Dinner_cistxn.png',
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
      'question': 'read book',
      'solution_vids': ['read', 'book'],
      'solution': ['read_i', 'book_i'],
      'availableLetters': ['read_i', 'write_i', 'book_i', 'school_i'],
      'urls': {
        "read":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/read_w5djtk.mp4",
        "write":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/write_omxdnp.mp4",
        "book":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/book_rmof9s.mp4",
        "school":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4",
        "read_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977095/Read_q0cq1f.png",
        "write_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977048/Write_utov42.png",
        "book_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977160/Book_gosph2.png",
        "school_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730977235/School_cdvg2o.png",
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'finish work',
      'solution_vids': ['finish', 'work'],
      'solution':['finish_i','work_i'],
      'availableLetters': ['finish_i','use_i','office_i','work_i'],
      'urls': {
        "finish":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530660/finish_abglyx.mp4",
        "work":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/work_ejax98.mp4",
        "use":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/use_gzlhmv.mp4",
        "office":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4",
        'finish_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984383/Finish_a88xkj.png',
        'use_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984473/Use_q4y2oo.png',
        'work_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984542/Work_eanznr.png',
        'office_i':
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
      'question': 'drink tea',
      'solution_vids': ['drink', 'tea'],
      'solution':['drink_i','tea_i'],
      'availableLetters': ['drink_i','eat_i','breakfast_i','tea_i',],
      'urls': {
        "drink":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/drink_fxt97a.mp4",
        "eat":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530657/eat_yaf2hc.mp4",
        "breakfast":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/breakfast_hb90fq.mp4",
        "tea":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/tea_i6mkyc.mp4",
        'drink_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730985321/Drink_wofu27.png',
        'eat_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730974723/Eat_vf1awm.png',
        'breakfast_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730985448/Breakfast_sc6ruy.png',
        'tea_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730985530/Tea_gzhp4z.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'come office',
      'solution_vids': ['come', 'office'],
      'solution':['come_i','office_i'],
      'availableLetters': ['go_i','come_i','school_i','office_i'],
      'urls': {
        "go":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/come_glgkmw.mp4",
        "office":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4",
        "come":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/come_glgkmw.mp4",
        "school":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4",
        'go_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986208/Go_kmooei.png',
        'office_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730984598/Office_jhay8v.png',
        'come_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986339/Come_b2f00f.png',
        'school_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730977235/School_cdvg2o.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'wake up morning',
      'solution_vids': ['wake up', 'morning'],
      'solution':['wake up_i', 'morning_i'],
      'availableLetters': ['wake up_i', 'sleep_i', 'morning_i', 'house_i'],
      'urls': {
        "wake up":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/wake_up_c6pbs5.mp4",
        "sleep":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/sleep_vwyvtz.mp4",
        "morning":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/morning_pvtuty.mp4",
        "house":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4",
        'wake up_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986852/Wake_up_eo3jud.png',
        'sleep_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986852/Sleep_c8ersf.png',
        'morning_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986851/Morning_qvqdfu.png',
        'house_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730986851/House_mt8ywx.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'birds fly',
      'solution_vids': ['birds', 'fly'],
      'solution':['birds_i', 'fly_i'],
      'availableLetters': ['fish_i', 'fly_i', 'birds_i', 'swim_i'],
      'urls': {
        'birds':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'fish':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'fly':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'swim':
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'birds_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987716/Birds_zhgyzl.png',
        'fly_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987715/Fly_j9jtn9.png',
        'swim_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987715/Swim_ea5apc.png',
        'fish_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987716/Fish_ukkxsz.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'fish swim',
      'solution_vids': ['fish','swim'],
      'solution': ['fish_i', 'swim_i'],
      'availableLetters': ['birds_i', 'fish_i', 'swim_i', 'fly_i'],
      'urls': {
        'birds':
        "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'fish':
        "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'fly':
        "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'swim':
        "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4",
        'birds_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987716/Birds_zhgyzl.png',
        'fly_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987715/Fly_j9jtn9.png',
        'swim_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987715/Swim_ea5apc.png',
        'fish_i':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730987716/Fish_ukkxsz.png',
        'correct':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'I deaf',
      'solution_vids': ['I','deaf'],
      'solution':["I_i","deaf_i"],
      'availableLetters': ["we_i", "deaf_i", "I_i", "teacher_i"],
      'urls': {
        "I":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530903/I_jcee6z.mp4",
        "deaf":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/deaf_ezkwye.mp4",
        "we":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530904/we_duowgj.mp4",
        "teacher":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/book_rmof9s.mp4",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "I_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/I_reqpgr.png",
        'we_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/We_d4trpx.png',
        'teacher_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988758/Teacher_ygovmv.png',
        'deaf_i':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1730988759/Deaf_lqqlfz.png',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'live India',
      'solution_vids': ['live', 'India'],
      'solution': ["live_i", "India_i"],
      'availableLetters': ["walk_i", "live_i", "house_i", "India_i"],
      'urls': {
        "live":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/walk_zsaaad.mp4",
        "India":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4",
        "walk":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/walk_zsaaad.mp4",
        "house":
            "https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "live_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730989201/Live_hbudpg.png",
        "India_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730989201/India_mdg3uj.png",
        "house_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730986851/House_mt8ywx.png",
        "walk_i":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1730989202/Walk_ucjkq9.png",
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
        } else if (attempts == 2) {
          score += 25;
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
            'urls': challengeData[currentChallengeIndex]['urls']
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
        builder: (context) => Result_Challenger_Week3(
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
                            "Drag the correct yellow color available boxes and drop them in to the wooden boxes as per the spelling of question. For more information press the 'tutorial button' on the top",
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
Flexible(
  child: VideoWidget(
    challengeData[currentChallengeIndex]['urls'][
        challengeData[currentChallengeIndex]['solution_vids'][1]],
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
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.1,
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
              screenWidth * 0.4, // Adjust this to align properly in the center
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
