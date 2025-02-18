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
  final Map<String, String> adverbGifs = const {
    'Quickly': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890316/quickly_l_lfzjwa.mp4',
    'Hard': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739889429/hard_l_ihtrjs.mp4',
    'Now': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890312/now_l_tnom21.mp4',
    'Soon': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890313/soon_l_km8cr8.mp4',
    'Tomorrow': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890242/tomorrow_l_zryue2.mp4',
    'Today': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890250/today_l_n0sasm.mp4',
    'Yesterday': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890222/yesterday_l_buidwj.mp4',
    'Here': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890250/here_l_sp6nte.mp4',
    'There': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890241/there_l_v2lz4e.mp4',
    'Always': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890250/always_l_iloz1c.mp4',
    'Often': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890315/often_l_nurme5.mp4',
    'Sometimes': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890312/sometimes_l_id1uz7.mp4',
    'Rarely': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890313/rarely_l_czma80.mp4',
    'Never': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890299/never_l_ene69b.mp4',
    'Very': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890311/very_l_oycivk.mp4',
    'Enough': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890310/enough_l_hszrfy.mp4',
    'Already': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1739890249/already_l_qmrf0k.mp4',
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
        itemCount: adverbGifs.length,
        itemBuilder: (context, index) {
          final url = adverbGifs.values.elementAt(index);
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
