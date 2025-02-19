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
  final Map<String, String> verbGifs =
  {'Finish': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530660/finish_abglyx.mp4',
    'Eat' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530657/eat_yaf2hc.mp4',
    'Walk' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/walk_zsaaad.mp4',
    'Talk' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/talk_jh3iqu.mp4',
    'Work' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/work_ejax98.mp4',
    'Wake Up' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/wake_up_c6pbs5.mp4',
    'Use' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530655/use_gzlhmv.mp4',
    'Read' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/read_w5djtk.mp4',
    'Sleep' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530654/sleep_vwyvtz.mp4',
    'Cook' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/cook_epek8y.mp4',
    'Write' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/write_omxdnp.mp4',
    'Drink' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/drink_fxt97a.mp4',
    'Come' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730530653/come_glgkmw.mp4',
    'Go' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410721/go_idycp2.mp4',
    'Wash' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410725/wash_cstfkb.mp4',
    'Live' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410726/live_ge7jys.mp4',
    'Love' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410727/love_d6fjxt.mp4',
    'Fly' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890674/fly_bm5i6w.mp4',
    'Look' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410729/look_qm9e55.mp4',
    'Teach' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410730/teach_bzjkbw.mp4',
    'See' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410730/see_hdv0qq.mp4',
    'Give' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410731/give_lminrz.mp4',
    'Swim' : 'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890682/swim_rqfbkd.mp4',
    'Play':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890679/play_tei2bg.mp4',
    'Sit':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890679/sit_nci0xg.mp4',
    'Run':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890678/run_ac37ln.mp4',
    'Grow':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890676/grow_md03gs.mp4',
    'Sing':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890676/sing_r6mzzg.mp4',
    'Think':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890675/think_pjswbu.mp4',
    'Smile':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890675/smile_sjxvzd.mp4',
    'Stand':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890674/stand_fejkqq.mp4',
    'Catch':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/catch_ngo7mv.mp4',
    'Meet':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890672/meet_ivsfa2.mp4',
    'Cry':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/cry_s2tyyz.mp4',
    'Jump':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890670/jump_c38hgb.mp4',
    'Listen':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890671/listen_brxvjq.mp4',
    'Clean':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890669/clean_a12isl.mp4',
    'Travel':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890669/travel_vtddll.mp4',
    'Draw':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/draw_nv18vo.mp4',
    'Dance':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/dance_uxql6k.mp4',
    'Drive':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890668/drive_anmwpx.mp4',
    'Wear':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890667/wear_fkpoy7.mp4',
    'Wait':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890666/wait_jb17dl.mp4',
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

      List<String> nouns = verbGifs.keys.toList();
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
          incorrectQuestions.add({'question': verbGifs[targetNoun], 'correctSolution': targetNoun});
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
        title: Text('Verbs Video Bingo Game',style: TextStyle(color: Color.fromARGB(255, 165, 74, 17)),),
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
                        url: verbGifs[noun] ?? '',
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
