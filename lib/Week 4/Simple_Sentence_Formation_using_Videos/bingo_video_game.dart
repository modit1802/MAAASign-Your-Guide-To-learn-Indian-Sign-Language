import 'package:SignEase/Week%203/bingo_result_noun.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

void main() {
  runApp(Bingo_game_simple_Sentences());
}

class Bingo_game_simple_Sentences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Bingo Game',
      debugShowCheckedModeBanner: false,
      home: BingoScreen(),
    );
  }
}

class BingoScreen extends StatefulWidget {
  @override
  _BingoScreenState createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> questions = [
    {'question': "hello mother ______", 'answer': "hello"},
    {'question': "aeroplane ______ in the sky", 'answer': "flies"},
    {'question': "cat ______ on the mat", 'answer': "sits"},
    {'question': "sun ______ in the east", 'answer': "rises"},
    {'question': "stars ______ at night", 'answer': "twinkle"},
    {'question': "birds ______ in the morning", 'answer': "chirp"},
  ];

  final Map<String, String> videoOptions = {
    'hello': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/5_nvihuh.mp4',
    'flies': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/flies_video.mp4',
    'sits': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/sits_video.mp4',
    'rises': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/rises_video.mp4',
    'twinkle': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/twinkle_video.mp4',
    'chirp': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/chirp_video.mp4',
  };

  late int currentQuestionIndex;
  late List<String> currentOptions;
  int score = 0;
  int questionCount = 0;
  Random random = Random();
  late AnimationController _controller;
  bool showAnswer = false;
  String selectedAnswer = '';
   late String targetNoun;
  
 
  int correctCount = 0;
  int incorrectCount = 0;

  List<Map<String, dynamic>> incorrectQuestions = [];
 
  int chancesLeft = 2;
  String selectedNoun = ''; // Track the selected option
  Map<String, bool> selectionStatus = {}; // Track the selection status of each option
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      if (questionCount == 6) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bingo_Noun_ResultScreen(
              score: score,
              correctcount: questionCount,
              incorrectcount: 6 - questionCount,
              totalQuestions: 6,
              incorrectQuestions: [],
            ),
          ),
        );
        return;
      }

      currentQuestionIndex = questionCount;
      String correctAnswer = questions[currentQuestionIndex]['answer']!;
      List<String> options = videoOptions.keys.toList();
      options.remove(correctAnswer);

      currentOptions = [correctAnswer, ...options..shuffle()].sublist(0, 4);
      currentOptions.shuffle();

      questionCount++;
      showAnswer = false;
      selectedAnswer = '';
      _controller.forward(from: 0);
    });
  }

  void _checkAnswer(String answer) {
  setState(() {
    if (answer == questions[currentQuestionIndex]['answer']) {
      score += 100;
      selectionStatus[answer] = true; // Correct selection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correct! +100 points'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      _generateNewQuestion();
    } else {
      chancesLeft--;
      selectionStatus[answer] = false; // Incorrect selection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect! $chancesLeft chances left'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      if (chancesLeft == 0) {
        // Highlight the correct video in green
        selectionStatus[questions[currentQuestionIndex]['answer']!] = true;
        Future.delayed(Duration(seconds: 2), () {
          _generateNewQuestion();
        });
      }
    }
  });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Bingo Game'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBox('Chances: $chancesLeft'),
                  _buildInfoBox('Score: $score'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                questions[currentQuestionIndex]['question']!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 9 / 16,
                  ),
                  itemCount: currentOptions.length,
                  itemBuilder: (context, index) {
                    String option = currentOptions[index];
                    return GestureDetector(
                      child: VideoTile(
                        key: ValueKey(option),
                        url: videoOptions[option]!,
                        isCorrect: showAnswer && selectionStatus[option] == true, // Check if this option is the correct answer
                        isIncorrect: showAnswer && selectionStatus[option] == false, // Check if this option was selected incorrectly
                        isSelected: selectionStatus[option] == false || selectionStatus[option] == true, // Check if this option was selected
                        onSelected: (isSelected) {
                          if (isSelected) {
                            _checkAnswer(option);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

   Widget _buildInfoBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

}
class VideoTile extends StatefulWidget {
  final String url;
  final bool isCorrect;
  final bool isIncorrect;
  final bool isSelected; // Track if this option is selected
  final ValueChanged<bool> onSelected;

  const VideoTile({
    Key? key,
    required this.url,
    this.isCorrect = false,
    this.isIncorrect = false,
    required this.onSelected,
    this.isSelected = false,
  }) : super(key: key);

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        isPlaying = _controller.value.isPlaying;
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isCorrect
          ? Colors.green.withOpacity(0.7) // Green if correct
          : widget.isIncorrect
              ? Colors.red.withOpacity(0.7) // Red if incorrect
              : Colors.white,
      child: Stack(
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () {
                widget.onSelected(true);
              },
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isCorrect ? Colors.green : Colors.black54,
                ),
                child: Text(
                  widget.isCorrect
                      ? '✅'
                      : widget.isIncorrect
                          ? '❌'
                          : '',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
