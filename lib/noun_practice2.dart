import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

import 'bingo_result.dart';

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
  final Map<String, String> nounGifs = {
    'Book': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/book_rmof9s.mp4',
    'School': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/school_kmk2uh.mp4',
    'Lunch': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530818/lunch_cbcgwu.mp4',
    'Hands': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/hands_hngxdm.mp4',
    'Morning': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/morning_pvtuty.mp4',
    'Deaf': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/deaf_ezkwye.mp4',
    'Tea': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/tea_i6mkyc.mp4',
    'Office': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530817/office_ggo4af.mp4',
    'Breakfast': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530816/breakfast_hb90fq.mp4',
    'Dinner': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530815/dinner_blbwzm.mp4',
    'Market': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530819/market_vfh9vj.mp4',
    'Work': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530814/work_zjfapw.mp4',
  };

  late String targetNoun;
  late List<String> currentOptions;
  int score = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  int questionCount = 0;
  List<Map<String, dynamic>> incorrectQuestions = [];
  Random random = Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _generateNewRound();
  }

  void _generateNewRound() {
    setState(() {
      if (questionCount == 5) {
        // Navigate to Result Screen after 5 questions
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

      List<String> nouns = nounGifs.keys.toList();
      targetNoun = nouns[random.nextInt(nouns.length)];
      nouns.remove(targetNoun);

      // Randomize options and pick 3 incorrect options along with the correct answer
      currentOptions = [targetNoun, ...nouns..shuffle()].sublist(0, 4);
      currentOptions.shuffle();

      questionCount++;
      _controller.forward(from: 0);
    });
  }

  void _checkAnswer(String selectedNoun) {
    if (selectedNoun == targetNoun) {
      int points = 100; // Score for correct answer
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
      incorrectQuestions.add({'question': targetNoun, 'selected': selectedNoun});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect! Try Again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
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
        title: Text('Video Bingo Game - Score: $score'),
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
              child: Text(
                'Find the sign for "$targetNoun"',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                    crossAxisCount: 2, // 2 columns for video tiles
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
                        url: nounGifs[noun] ?? '',
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
}

class VideoTile extends StatefulWidget {
  final String url;

  const VideoTile({Key? key, required this.url}) : super(key: key);

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
      color: Colors.grey[850],
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