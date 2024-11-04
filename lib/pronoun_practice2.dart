import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

import 'bingo_result_noun.dart';

void main() {
  runApp(VideoBingoGame());
}

class VideoBingoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Bingo Game',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 250, 233, 215),
      ),
      home: BingoScreen(),
    );
  }
}

class BingoScreen extends StatefulWidget {
  @override
  _BingoScreenState createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> with SingleTickerProviderStateMixin {
  final Map<String, String> pronounGifs =
    {'I': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530903/I_jcee6z.mp4',
    'You': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530904/you_eyvdmd.mp4',
    'He': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530905/he_kldbgn.mp4',
    'She': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530905/she_xhozgj.mp4',
    'It': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530903/It_ws1bwe.mp4',
    'We': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530904/we_duowgj.mp4',
    'They': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530908/they_wmmoxf.mp4'};

  late String targetNoun;
  late List<String> currentOptions;
  int score = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  int questionCount = 0;
  List<Map<String, dynamic>> incorrectQuestions = [];
  Random random = Random();
  late AnimationController _controller;
  int chancesLeft = 3;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _generateNewRound();
  }

  void _generateNewRound() {
    setState(() {
      if (questionCount == 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bingo_Noun_ResultScreen(
              score: score,
              correctcount: correctCount,
              incorrectcount: incorrectCount,
              totalQuestions: questionCount,
              incorrectQuestions: incorrectQuestions,
            ),
          ),
        );
        return;
      }

      List<String> nouns = pronounGifs.keys.toList();
      targetNoun = nouns[random.nextInt(nouns.length)];
      nouns.remove(targetNoun);

      currentOptions = [targetNoun, ...nouns..shuffle()].sublist(0, 4);
      currentOptions.shuffle();

      questionCount++;
      chancesLeft = 3;
      showAnswer = false;
      _controller.forward(from: 0);
    });
  }

  void _checkAnswer(String selectedNoun) {
    setState(() {
      if (selectedNoun == targetNoun) {
        int points = chancesLeft == 3 ? 100 : chancesLeft == 2 ? 50 : chancesLeft == 1 ? 25 : 0;
        score += points;
        correctCount++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correct! +$points points'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        _generateNewRound();
      } else {
        incorrectCount++;
        chancesLeft--;
        if (chancesLeft == 0) {
          showAnswer = true;
          incorrectQuestions.add({'question': pronounGifs[targetNoun], 'correctSolution': targetNoun});
          Future.delayed(Duration(seconds: 2), () {
            _generateNewRound();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect! $chancesLeft chances left.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
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
                'Find the sign for "$targetNoun"',
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
                    String noun = currentOptions[index];
                    return GestureDetector(
                      onTap: () => _checkAnswer(noun),
                      child: VideoTile(
                        key: ValueKey(noun),
                        url: pronounGifs[noun] ?? '',
                        isCorrect: showAnswer && noun == targetNoun,
                        isIncorrect: showAnswer && noun != targetNoun,
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
        borderRadius: BorderRadius.circular(20),
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

  const VideoTile({Key? key, required this.url, this.isCorrect = false, this.isIncorrect = false}) : super(key: key);

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
        setState(() {});
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isCorrect ? Colors.green : widget.isIncorrect ? Colors.red : Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: 9 / 16,
              child: VideoPlayer(_controller),
            )
                : Center(child: CircularProgressIndicator()),
          ),
          if (widget.isCorrect)
            Positioned.fill(
              child: Container(color: Colors.yellow.withOpacity(0.5)),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white70,
              ),
              onPressed: _togglePlayPause,
              tooltip: isPlaying ? 'Pause' : 'Play',
            ),
          ),
        ],
      ),
    );
  }
}
