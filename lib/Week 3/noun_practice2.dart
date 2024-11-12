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
      debugShowCheckedModeBanner: false,
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
    'Student' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410467/student_ohmjwi.mp4',
    'Birds' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410467/birds_ict0au.mp4',
    'Fish' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410468/fish_kkyqvv.mp4',
    'Aeroplane' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410469/aeroplane_qpzztg.mp4',
    'Teacher' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410473/teacher_tqdyrt.mp4',
    'Home' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410473/home_ocdazz.mp4',
    'India' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410475/india_ludfnp.mp4',
    'My Name Is' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410475/my_name_is_w54hkc.mp4',

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
  int chancesLeft = 3;
  bool showAnswer = false;
  String selectedNoun = ''; // Track the selected noun
  Map<String, bool> selectionStatus = {}; // Track the selection status of each option

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

      List<String> nouns = nounGifs.keys.toList();
      targetNoun = nouns[random.nextInt(nouns.length)];
      nouns.remove(targetNoun);

      currentOptions = [targetNoun, ...nouns..shuffle()].sublist(0, 4);
      currentOptions.shuffle();

      questionCount++;
      chancesLeft = 3;
      showAnswer = false;
      selectedNoun = ''; // Reset selected noun for the new round
      selectionStatus = {}; // Reset selection status for the new round
      _controller.forward(from: 0);
    });
  }

  void _checkAnswer(String noun) {
    setState(() {
      selectedNoun = noun; // Update the selected noun
      if (noun == targetNoun) {
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
        selectionStatus[noun] = false; // Mark the selected option as incorrect
        if (chancesLeft == 0) {
          showAnswer = true;
          selectionStatus[targetNoun] = true; // Mark the correct answer
          incorrectQuestions.add({'question': nounGifs[targetNoun], 'correctSolution': targetNoun});
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
                      child: VideoTile(
                        key: ValueKey(noun),
                        url: nounGifs[noun] ?? '',
                        isCorrect: showAnswer && selectionStatus[noun] == true, // Check if this option is the correct answer
                        isIncorrect: showAnswer && selectionStatus[noun] == false, // Check if this option was selected incorrectly
                        isSelected: selectionStatus[noun] == false || selectionStatus[noun] == true, // Check if this option was selected
                        onSelected: (isSelected) {
                          if (isSelected) {
                            _checkAnswer(noun);
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
      color: widget.isCorrect && widget.isSelected
          ? Colors.green // Green background if correctly selected
          : widget.isIncorrect
          ? Colors.red // Red background if incorrectly selected
          : Colors.white,
      child: Stack(
        children: [
          if (_controller.value.isInitialized)
            ColorFiltered(
              colorFilter: widget.isCorrect && widget.isSelected
                  ? ColorFilter.mode(Colors.green.withOpacity(0.5), BlendMode.srcATop)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
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
                  color: Colors.black54,
                ),
                child: Text(
                  widget.isSelected
                      ? (widget.isCorrect ? '✅' : '❌')
                      : '',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          if (_controller.value.isInitialized)
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
