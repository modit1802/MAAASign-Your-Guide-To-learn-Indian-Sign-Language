import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore: camel_case_types
class Tutorial_screen_for_challenger_week3 extends StatefulWidget {
  const Tutorial_screen_for_challenger_week3({super.key, required Null Function() onBackPressed});

  @override
  State<Tutorial_screen_for_challenger_week3> createState() =>
      _Tutorial_screen_for_challenger_week3State();
}

class _Tutorial_screen_for_challenger_week3State
    extends State<Tutorial_screen_for_challenger_week3> {
  
  late VideoPlayerController _controller;

@override
void initState() {
  super.initState();
  _controller = VideoPlayerController.network(
    'https://res.cloudinary.com/dfph32nsq/video/upload/v1730454638/Videolink_zelqbp.mp4' // Replace with your video URL or asset
  )
    ..initialize().then((_) {
      setState(() {
        _controller.play(); // Start playing the video automatically
      });
    })
    ..setLooping(true);
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData iconData,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 110,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: const Color.fromARGB(255, 252, 133, 37),
                      child: Center(
                        child: Icon(
                          iconData,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildCard2({
  required VoidCallback onTap,
  required IconData iconData,
  required Color color,
  required String title,
  required List<String> descriptionPoints, // Change this to accept a list of strings
  required int index,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 410,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: const Color.fromARGB(255, 252, 133, 37),
                    child: Center(
                      child: Icon(
                        iconData,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 8),
                      ...descriptionPoints.map((point) {
                        final boldText = point.split(': ')[0]; // Extract "1" part
                        final remainingText = point.split(': ').length > 1 ? point.split(': ')[1] : '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$boldText: ', // Bold part (1, 2, 3, etc.)
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: remainingText, // Unbold part
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Color.fromARGB(255, 158, 81, 13),
              size: 40,
              weight: 2000,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              onTap: () {},
              iconData: Icons.play_arrow_rounded,
              color: const Color.fromARGB(255, 255, 255, 255),
              title: 'Tutorial to solve challenger!',
              description: "Please carefully watch the below tutorial to solve the challenger rounds. If you want to skip press the cross button present on the top of screen",
              index: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                height:550,
                child: Card(
                  color: const Color.fromARGB(255, 250, 233, 215),
                  elevation: 10,
                  margin: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : const Center(child: CircularProgressIndicator()),
                        if (!_controller.value.isPlaying)
                          IconButton(
                            icon: Icon(
                              Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.play();
                              });
                            },
                          ),
                        if (_controller.value.isPlaying)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.pause();
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            _buildCard2(
  onTap: () {},
  iconData: Icons.integration_instructions,
  color: const Color.fromARGB(255, 255, 255, 255),
  title: 'General Instructions to Solve Challenger',
  descriptionPoints: [
    "1: Please watch the video carefully.",
    "2: Drag the yellow box and drop them in wooden box",
    "3: As you can see Sign of 'D' has been dragged and putted in the first box as per spelling of 'DOG'",
    "4: Similary repeat the steps with remaining alphabets.",
    "5: Once you place all the signs in wooden box press the 'Check now' Button.",
    "6: When you complete the tutorial to make exit press the '❌' button on the top of the screen."
  ],
  index: 2,
),

          ],
        ),
      ),
    );
  }
}
