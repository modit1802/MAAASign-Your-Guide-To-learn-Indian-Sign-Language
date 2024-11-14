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
    'Home':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410106/Home_labelled_poqrcy.mp4',
    'Aeroplane':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410106/Aeroplane_labelled_wolg5v.mp4',
    'Fish':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410107/Fish_labelled_rp6asv.mp4',
    'Student':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410107/Student_labelled_otumhu.mp4',
    'Teacher':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410108/Teacher_labelled_q1bvpw.mp4',
    'India':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410108/India_labelled_e7hc14.mp4',
    'Birds':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410116/Birds_labelled_v8ajkw.mp4',
    'My Name Is':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410108/My_Name_Is_labelled_kk1q0p.mp4',

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
      _controller.setVolume(0.0);
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
