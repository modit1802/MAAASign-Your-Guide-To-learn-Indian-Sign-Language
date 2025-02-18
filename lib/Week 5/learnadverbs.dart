import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Colors.transparent,
        ),
      ),
      home: const LearnAdverbs(),
    );
  }
}

class LearnAdverbs extends StatelessWidget {
  const LearnAdverbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Signing Adverbs",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        elevation: 0,
      ),
      body: const Verbs_links(),
    );
  }
}


class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const VideoWidget({
    Key? key,
    required this.videoUrl,
    required this.isActive,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showOverlay = false;
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _localPath = await _getLocalVideoPath(widget.videoUrl);
      if (!File(_localPath!).existsSync()) {
        await _cacheVideo(widget.videoUrl, _localPath!);
      }

      _controller = VideoPlayerController.file(File(_localPath!));
      await _controller.initialize();
      _controller.setVolume(0.0);

      setState(() {
        _isInitialized = true;
      });

      if (widget.isActive) {
        _controller.play();
      }

      // Listen for video state changes
      _controller.addListener(() {
        final isVideoEnded =
            _controller.value.position >= _controller.value.duration;

        setState(() {
          _showOverlay = isVideoEnded;
        });
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  Future<String> _getLocalVideoPath(String videoUrl) async {
    final directory = await getTemporaryDirectory();
    final filename = videoUrl.split('/').last;
    return '${directory.path}/$filename';
  }

  Future<void> _cacheVideo(String url, String path) async {
    final response = await http.get(Uri.parse(url));
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInitialized && widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _isInitialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator()),
        if (_showOverlay)
          Container(
            color: Colors.black.withOpacity(0.5), // Black shadow with opacity
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(
                Icons.replay,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () {
                if (_isInitialized) {
                  setState(() {
                    _showOverlay = false; // Remove overlay on replay click
                  });
                  _controller.seekTo(Duration.zero);
                  _controller.play();
                }
              },
            ),
          ),
      ],
    );
  }
}



class Verbs_links extends StatefulWidget {
  const Verbs_links({super.key});

  @override
  _Verbs_linksState createState() => _Verbs_linksState();
}

class _Verbs_linksState extends State<Verbs_links> {
  final Map<String, String> greetingGifs = const {
    'Come': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/come_l_xxndp7.mp4',
    'Eat': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/eat_l_kqflhk.mp4',
    'Drink': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/drink_l_qcxtet.mp4',
    'Read': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/read_l_pdsx7g.mp4',
    'Write': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558847/write_l_i7jrlt.mp4',
    'Sleep': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/sleep_l_wej9uh.mp4',
    'Walk': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558851/walk_l_urzxqn.mp4',
    'Talk': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/talk_l_zurskm.mp4',
    'Wake Up': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/wake_up_l_o1upds.mp4',
    'Work': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/work_l_ik2ynw.mp4',
    'Finish': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/finish_l_vl1692.mp4',
    'Use': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/use_l_nwwifk.mp4',
    'Cook': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730559387/cook_l_tao1wz.mp4',
    'Wash':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Wash_labelled_jvhgir.mp4',
    'Fly':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890135/fly__labelled_j9xcbb.mp4',
    'Give':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409738/Give_labelled_n99bii.mp4',
    'Teach':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Teach_labelled_urxibn.mp4',
    'Swim':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890142/swim_labelled_mkv4nm.mp4',
    'Live':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Live_labelled_im0cj3.mp4',
    'Love':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Love_labelled_flwjac.mp4',
    'See':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/See_labelled_vbmmjz.mp4',
    'Go':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Go_labelled_crsq3i.mp4',
    'Look':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409741/Look_labelled_xp94zn.mp4',
    'Catch':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890133/catch_labelled_p3cske.mp4',
    'Cry':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890134/cry_labelled_imopdy.mp4',
    'Wear':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890135/wear_labelled_hq6leo.mp4',
    'Grow':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890136/grow_labelled_kfenxp.mp4',
    'Drive':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890137/drive_labelled_ucmbgh.mp4',
    'Sing':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890137/sing_labelled_x6vmao.mp4',
    'Clean':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/clean_labelled_odui5v.mp4',
    'Wait':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/wait_labelled_apa5d1.mp4',
    'Jump':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/jump_labelled_djtf90.mp4',
    'Listen':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/listen_labelled_oqridg.mp4',
    'Sit':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/sit_labelled_qjmkel.mp4',
    'Think':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/think_labelled_s6wwuc.mp4',
    'Stand':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/stand_labelled_eqp833.mp4',
    'Meet':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/meet_labelled_gumy3r.mp4',
    'Dance':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/dance_labelled_esqtcb.mp4',
    'Run':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/run_labelled_yc8zzk.mp4',
    'Play':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890141/play_labelled_mqufuu.mp4',
    'Smile':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/smile_labelled_il8qfa.mp4',
    'Draw':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890141/draw_labelled_kphqz2.mp4',
    'Travel':'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890144/travel_labelled_txpf7d.mp4',
  };

  int _currentIndex = 0;

  @override
  void dispose() {
    _clearCache();
    super.dispose();
  }

    Future<void> _clearCache() async {
    final directory = await getTemporaryDirectory();
    final files = directory.listSync();
    for (var file in files) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }


  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: PageView.builder(
        onPageChanged: _onPageChanged,
        itemCount: greetingGifs.length,
        itemBuilder: (context, index) {
          final url = greetingGifs.values.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      width: screenWidth,
                      height: screenWidth * (16 / 9),
                      child: VideoWidget(
                        videoUrl: url,
                        isActive: index == _currentIndex, // Play only active video
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
