import 'package:SignEase/Week%204/Simple_Sentence_Formation_using_Videos/result_bingo_simple_Sentence.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import 'package:SignEase/Week 4/Simple_Sentence_Formation_using_Videos/bingo_tutorial.dart';


void main() {
  runApp(Bingo_game_simple_Sentences());
}

class Bingo_game_simple_Sentences extends StatelessWidget {
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
  final Map<String, String> Simple_sentence_links = {
    'Man and female person are washing the hands': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908793/26_nr8jcf.mp4',
    'Birds fly in the house': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908784/27_fhujac.mp4',
    'Teacher teaches student to swim': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908793/28_jcufnb.mp4',
    'Student look at teacher': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908786/29_iukqk6.mp4',
    'Aeroplane flies with the birds': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908792/30_yuq5c8.mp4',
    'Mother loves her house': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908785/31_ceay4p.mp4',
    'Teacher sees the Aeroplane': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908787/32_jjwbl8.mp4',
    'Man loves the fish': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908785/33_wfyfje.mp4',
    'Female Person sees the bird': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908787/34_vxshgh.mp4',
    'Student loves to read book': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908789/35_b8lrsu.mp4',
    'Man is looking at fish': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908783/37_cbx1v9.mp4',
    'Teacher goes to school': 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908783/38_v2py8c.mp4',
    'Student lives in India' : 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908783/39_viy9ma.mp4',
    'Teacher eats lunch at school' : 'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731908783/40_v31g1n.mp4',
  };

  late String target_sentence;
  late List<String> currentOptions;
  int score = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  int questionCount = 0;
  List<Map<String, dynamic>> incorrectQuestions = [];
  Random random = Random();
  late AnimationController _controller;
  int chancesLeft = 2;
  bool showAnswer = false;
  String selectedNoun = ''; // Track the selected noun
  Map<String, bool> selectionStatus = {}; // Track the selection status of each option

  @override
  void initState() {
    super.initState();
    _showTutorialScreen();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _generateNewRound();
  }

  void _generateNewRound() {
    setState(() {
      if (questionCount == 10) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bingo_Simple_Sentence_ResultScreen(
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

      List<String> nouns = Simple_sentence_links.keys.toList();
      target_sentence = nouns[random.nextInt(nouns.length)];
      nouns.remove(target_sentence);

      currentOptions = [target_sentence, ...nouns..shuffle()].sublist(0, 4);
      currentOptions.shuffle();

      questionCount++;
      chancesLeft = 2;
      showAnswer = false;
      selectedNoun = ''; // Reset selected noun for the new round
      selectionStatus = {}; // Reset selection status for the new round
      _controller.forward(from: 0);
    });
  }

  void _checkAnswer(String noun) {
    setState(() {
      selectedNoun = noun; // Update the selected noun
      if (noun == target_sentence) {
        int points = chancesLeft == 2 ? 100 : chancesLeft == 1 ? 50 : 0;
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
          selectionStatus[target_sentence] = true; // Mark the correct answer
          incorrectQuestions.add({'question': Simple_sentence_links[target_sentence], 'correctSolution': target_sentence});
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
  void _showTutorialScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BingoTutorialScreen(
                onBackPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Simple Sentence Video Bingo Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Navigate to the tutorial screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BingoTutorialScreen(onBackPressed: () {Navigator.pop(context);  },)),
              );
            },
          ),
        ],
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
                '"$target_sentence"',
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
                        url: Simple_sentence_links[noun] ?? '',
                        isCorrect: showAnswer && selectionStatus[noun] == true,
                        isIncorrect: showAnswer && selectionStatus[noun] == false,
                        isSelected: selectionStatus[noun] == false || selectionStatus[noun] == true,
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
