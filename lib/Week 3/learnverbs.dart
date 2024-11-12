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
      home: const LearnVerbs(),
    );
  }
}

class LearnVerbs extends StatelessWidget {
  const LearnVerbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text(
          "Let's Learn Common Verbs",
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
    'Fly':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Fly_labelled_swrtnf.mp4',
    'Give':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409738/Give_labelled_n99bii.mp4',
    'Teach':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Teach_labelled_urxibn.mp4',
    'Swim':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409738/Swim_labelled_uuemob.mp4',
    'Live':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Live_labelled_im0cj3.mp4',
    'Love':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Love_labelled_flwjac.mp4',
    'See':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/See_labelled_vbmmjz.mp4',
    'Go':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Go_labelled_crsq3i.mp4',
    'Look':'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409741/Look_labelled_xp94zn.mp4',
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
