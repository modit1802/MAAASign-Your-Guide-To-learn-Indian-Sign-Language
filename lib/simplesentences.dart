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
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Simple Greetings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
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
    'hello': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hello_u_hmbf7y.mp4',
    'hy': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/hy_u_dfsvt4.mp4',
    'goodbye': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266605/good_bye_u_hz6peg.mp4',
    'namaste': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/namaste_u_iptdsn.mp4',
    'welcome': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/welcome_u_np7ibt.mp4',
	'good_morning': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266607/good_morning_u_ug5jxg.mp4',
    'good_afternoon': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266601/good_afternoon_u_wwhvia.mp4',
    'good_night': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266600/good_night_u_sgogpu.mp4',
    'see_you_again': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266603/see_you_again_u_jfm6yv.mp4',
    'see_you_tomorrow': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730266608/see_you_tomorrow_u_wqcfwu.mp4',
  };


  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
      });
      if (widget.isActive) _controller.play();
    });
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? VideoPlayer(_controller)
        : const Center(child: CircularProgressIndicator());
  }
}
