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
      home: const SimpleSentences(),
    );
  }
}

class SimpleSentences extends StatelessWidget {
  const SimpleSentences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Signing Simple Greetings",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        elevation: 0,
      ),
      body: const Simple_Sentences_links(),
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


class Simple_Sentences_links extends StatefulWidget {
  const Simple_Sentences_links({super.key});

  @override
  _Simple_Sentences_linksState createState() => _Simple_Sentences_linksState();
}

class _Simple_Sentences_linksState extends State<Simple_Sentences_links> {
  final Map<String, String> greetingGifs = const {
    'hello': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/hello_q0jqlg.mp4',
    'hy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113627/hy_ewk653.mp4',
    'goodbye': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/good_bye_fdlupb.mp4',
    'namaste': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113630/namaste_ywacpg.mp4',
    'welcome': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113634/welcome_rnwqkq.mp4',
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
