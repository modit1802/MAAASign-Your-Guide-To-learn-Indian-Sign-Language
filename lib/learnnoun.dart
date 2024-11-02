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
      home: const LearnNouns(),
    );
  }
}

class LearnNouns extends StatelessWidget {
  const LearnNouns({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Nouns",
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
    'Book': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558926/book_l_eike3i.mp4',
    'School': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558925/school_l_t98bdl.mp4',
    'Lunch': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558924/lunch_l_z6h5il.mp4',
    'Hands': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558924/hands_l_pvatyv.mp4',
    'Morning': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/morning_l_x5lnsf.mp4',
    'Deaf': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/deaf_l_k2eicr.mp4',
    'Tea': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558920/tea_l_oetesc.mp4',
    'Office': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558920/office_l_svsjwl.mp4',
    'Breakfast': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/breakfast_l_udba1y.mp4',
    'Dinner': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/dinner_l_zlsyq2.mp4',
    'Market': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/market_l_sdnjwt.mp4',
    'Work': 'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/work_l_bpj6jp.mp4',
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
      videoWidget.disposeController(); // Ensure all controllers are disposed
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _videoWidgets[_currentIndex].pauseVideo(); // Pause the current video
      _currentIndex = index;
      _videoWidgets[_currentIndex].playVideo(); // Play the new video
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
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

  void playVideo() {
    if (controller.value.isInitialized) {
      controller.play();
    }
  }

  void pauseVideo() {
    if (controller.value.isInitialized) {
      controller.pause();
    }
  }

  void disposeController() {
    if (controller.value.isInitialized) {
      controller.dispose();
    }
  }
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
