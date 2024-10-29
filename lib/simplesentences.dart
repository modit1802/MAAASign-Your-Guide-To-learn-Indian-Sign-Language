import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text(
          "Let's Learn Simple Greetings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 142, 45, 226),
        elevation: 0,
      ),
      body: const GreetingGifs(),
    );
  }
}

class GreetingGifs extends StatefulWidget {
  const GreetingGifs({super.key});

  @override
  _GreetingGifsState createState() => _GreetingGifsState();
}

class _GreetingGifsState extends State<GreetingGifs> {
  final Map<String, String> greetingGifs = const {
    'hello': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/hello_q0jqlg.mp4',
    'hy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113627/hy_ewk653.mp4',
    'goodbye': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/good_bye_fdlupb.mp4',
    'namaste': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113630/namaste_ywacpg.mp4',
    'welcome': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113634/welcome_rnwqkq.mp4',
  };

  int _currentIndex = 0;
  final List<VideoWidget> _videoWidgets = [];

  @override
  void initState() {
    super.initState();
    _videoWidgets.addAll(greetingGifs.values.map((url) => VideoWidget(videoUrl: url)).toList());
  }

  @override
  void dispose() {
    for (var videoWidget in _videoWidgets) {
      videoWidget.controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _videoWidgets[_currentIndex].controller.pause();
      _currentIndex = index;
      _videoWidgets[_currentIndex].controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 142, 45, 226),
            Color.fromARGB(255, 74, 0, 224),
            Color.fromARGB(255, 185, 85, 255),
          ],
        ),
      ),
      child: Center(
        child: PageView.builder(
          onPageChanged: _onPageChanged,
          itemCount: _videoWidgets.length,
          itemBuilder: (context, index) {
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
                        width: screenWidth, // Full width of the screen
                        height: screenWidth * (16 / 9), // Maintain 16:9 aspect ratio
                        child: _videoWidgets[index],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  late final VideoPlayerController controller;

  VideoWidget({Key? key, required this.videoUrl}) : super(key: key) {
    controller = VideoPlayerController.network(videoUrl);
  }

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  int _playCount = 0;
  bool _showReplayButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoEnd);
    widget.controller.initialize().then((_) {
      setState(() {});
      widget.controller.play();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoEnd);
    widget.controller.dispose();
    super.dispose();
  }

  void _onVideoEnd() {
    if (widget.controller.value.position == widget.controller.value.duration) {
      _playCount++;
      if (_playCount < 2) {
        widget.controller.seekTo(Duration.zero);
        widget.controller.play();
      } else {
        setState(() {
          _showReplayButton = true;
        });
      }
    }
  }

  void _replayVideo() {
    setState(() {
      _playCount = 0;
      _showReplayButton = false;
      widget.controller.seekTo(Duration.zero);
      widget.controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: VideoPlayer(widget.controller),
        )
            : const Center(child: CircularProgressIndicator()),
        if (_showReplayButton)
          Positioned.fill(
            child: GestureDetector(
              onTap: _replayVideo,
              child: Container(
                color: Colors.black54, // Translucent black overlay
                child: Center(
                  child: Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
