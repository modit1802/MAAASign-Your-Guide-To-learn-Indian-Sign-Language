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
      home: const LearnAdjectives(),
    );
  }
}

class LearnAdjectives extends StatelessWidget {
  const LearnAdjectives({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Signing Adjectives",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        elevation: 0,
      ),
      body: const Nouns_links(),
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


class Nouns_links extends StatefulWidget {
  const Nouns_links({super.key});

  @override
  _Nouns_linksState createState() => _Nouns_linksState();
}

class _Nouns_linksState extends State<Nouns_links> {
  final Map<String, String> adjectiveGifs = const {
    'Beautiful': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889441/beautiful_l_fyswqs.mp4',
    'Delicious': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889446/delicious_l_dvxq5d.mp4',
    'Intelligent': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889426/intelligent_l_pkioic.mp4',
    'Bright': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889441/bright_l_dmzrom.mp4',
    'Proud': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889430/proud_l_wsfurk.mp4',
    'Hot': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889426/hot_l_plz54g.mp4',
    'Busy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889443/busy_l_gcy4ct.mp4',
    'Fast': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889425/fast_l_zmimo8.mp4',
    'Fresh': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889425/fresh_l_dnhw6b.mp4',
    'Old(People)':'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889430/old_people__l_ked7hp.mp4',
    'Cold': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889445/cold_l_fxcmak.mp4',
    'Hot(things)':'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889430/hot_things__l_lhvqwz.mp4',
    'Bad': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889442/bad_l_ehd264.mp4',
    'Big': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889441/big_l_jeyv43.mp4',
    'Good': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889426/good_l_uomznc.mp4',
    'Tall': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889437/tall_l_hpewms.mp4  ',
    'Short': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889434/short_l_tsa2ri.mp4',
    'Old': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889432/old_l_kysccp.mp4',
    'Young': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889438/young_l_sviwcy.mp4',
    'Early': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889445/early_l_sybky6.mp4',
    'Late': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890075/late_l_myjzsf.mp4',
    'Happy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889427/happy_l_xglxlv.mp4',
    'Sad': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889433/sad_l_brohez.mp4',
    'Angry': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889438/angry_l_lqwedy.mp4',
    'Important': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889431/important_l_co5puc.mp4',
    'Weak': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889436/weak_l_xxgf1e.mp4',
    'Sick': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889435/sick_l_psqnua.mp4',
    'White': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889437/white_l_kt5slm.mp4',
    'Sweet': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889435/sweet_l_dawatv.mp4',
    'Quiet': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889433/quiet_l_hf6hxn.mp4',
    'Dark': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889446/dark_l_ezdqo1.mp4',
    'Yellow': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889438/yellow_l_k9l5fc.mp4',
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
        itemCount: adjectiveGifs.length,
        itemBuilder: (context, index) {
          final url = adjectiveGifs.values.elementAt(index);
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

