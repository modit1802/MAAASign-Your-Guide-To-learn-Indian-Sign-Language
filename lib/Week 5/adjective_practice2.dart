import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import 'package:SignEase/Week 3/bingo_tutorial.dart';
import 'bingo_result_adjective.dart';

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
  final Map<String, String> adjectiveVideos = {
    'Beautiful': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897613/beautiful_bz4eod.mp4',
    'Delicious': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897758/delicious_fc16jv.mp4',
    'Intelligent': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897768/intelligent_gvtnyz.mp4',
    'Bright': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897621/bright_nof7io.mp4',
    'Proud': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897773/proud_pk3f9s.mp4',
    'Hot(Feel)': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897766/hot_dqkqvc.mp4',
    'Hot(Things)': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897764/hot_things_sg4blu.mp4',
    'Busy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897685/busy_l6ljzm.mp4',
    'Fast': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897761/fast_hdlcaz.mp4',
    'Fresh': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897760/fresh_afehew.mp4',
    'Cold': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897706/cold_bewa1z.mp4',
    'Bad': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897616/bad_y4ocsr.mp4',
    'Big': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897609/big_wqdsar.mp4',
    'Good': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897762/good_j1od8d.mp4',
    'Tall': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897781/tall_ugh0zs.mp4',
    'Short': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897778/short_djtuin.mp4',
    'Old(Things)': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897772/old_llxpk8.mp4',
    'Old(People)': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897770/old_people_migzzj.mp4',
    'Young': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897784/young_iffauh.mp4',
    'Early': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897759/early_lk630z.mp4',
    'Late': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897770/late_coixse.mp4',
    'Happy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897762/happy_aql9hw.mp4',
    'Sad': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897775/sad_icm5u1.mp4',
    'Angry': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897609/angry_smme0q.mp4',
    'Important': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897767/important_ah3jxw.mp4',
    'Weak': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897783/weak_cjvisf.mp4',
    'Sick': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897777/sick_btmtcd.mp4',
    'White': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897781/white_ufozsj.mp4',
    'Sweet': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897779/sweet_ohin7f.mp4',
    'Quiet': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897774/quiet_f9no21.mp4',
    'Dark': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897758/dark_islurc.mp4',
    'Yellow': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739897785/yellow_rluoxo.mp4',
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
      if (questionCount == 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bingo_Adjective_ResultScreen(
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

      List<String> nouns = adjectiveVideos.keys.toList();
      targetNoun = nouns[random.nextInt(nouns.length)];
      nouns.remove(targetNoun);

      currentOptions = [targetNoun, ...nouns..shuffle()].sublist(0, 4);
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
      if (noun == targetNoun) {
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
          selectionStatus[targetNoun] = true; // Mark the correct answer
          incorrectQuestions.add({'question': adjectiveVideos[targetNoun], 'correctSolution': targetNoun});
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
        title: Text('Adjectives Video Bingo Game',style: TextStyle(color: Color.fromARGB(255, 165, 74, 17)),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 250, 233, 215),
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
                        url: adjectiveVideos[noun] ?? '',
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
