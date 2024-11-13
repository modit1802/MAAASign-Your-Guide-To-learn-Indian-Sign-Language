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
      home: const SimpleRelations(),
    );
  }
}

class SimpleRelations extends StatelessWidget {
  const SimpleRelations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Simple Relations",
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
  final Map<String, String> relationGifs = const {
    'baby': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125689/baby_m5j2ml.mp4',
    'mother': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125682/mother_xsdqsk.mp4',
    'father': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125688/father_shv0s8.mp4',
    'brother': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125688/brother_zrrtqr.mp4',
    'sister': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125684/sister_bxolqx.mp4',
    'people': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125684/people_jjw2bk.mp4',
    'friend': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125682/friend_kjbxg8.mp4',
    'man': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125683/man_vy9lea.mp4',
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
        itemCount: relationGifs.length,
        itemBuilder: (context, index) {
          final url = relationGifs.values.elementAt(index);
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
