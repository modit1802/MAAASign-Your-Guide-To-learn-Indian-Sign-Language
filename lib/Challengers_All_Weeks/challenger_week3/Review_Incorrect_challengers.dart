import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update UI when the video is initialized
      })
      ..addListener(_videoListener);
  }

  void _videoListener() {
    // Check if the video has reached the end
    if (_controller.value.position >= _controller.value.duration) {
      setState(() {
        _showOverlay = true; // Show overlay when the video completes
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showOverlay = true;
      } else {
        // Reset the overlay every time the video starts playing
        if (_controller.value.position >= _controller.value.duration) {
          _controller.seekTo(Duration.zero); // Restart from beginning if ended
        }
        _controller.play();
        _showOverlay = false; // Hide overlay on play
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        if (_showOverlay)
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                color: Colors.black.withOpacity(0.3), // Overlay color
                child: Center(
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
      ],
    )
        : const Center(child: CircularProgressIndicator());
  }
}


class Review_Incorrect_Challengers extends StatefulWidget {
  final List<Map<String, dynamic>>? incorrectChallenger;

  const Review_Incorrect_Challengers({
    Key? key,
    required this.incorrectChallenger,
  }) : super(key: key);

  @override
  State<Review_Incorrect_Challengers> createState() =>
      _Review_Incorrect_ChallengersState();
}

class _Review_Incorrect_ChallengersState extends State<Review_Incorrect_Challengers> {
  int currentChallengeIndex = 0;
  late List<String?> solutionImages;
  late List<String?> solutionVideos;
  late List<Map<String, dynamic>> challengeData;

  @override
  void initState() {
    super.initState();
    challengeData = widget.incorrectChallenger ?? [];
    if (challengeData.isNotEmpty) {
      _initializeChallenge();
    }
  }

  void _initializeChallenge() {
    setState(() {
      var currentChallenge = challengeData[currentChallengeIndex];

      var solutionList = currentChallenge['solution'] as List<dynamic>? ?? [];
      var solutionVidsList = currentChallenge['solution_vids'] as List<dynamic>? ?? [];
      var urlsMap = currentChallenge['urls'] as Map<String, String>? ?? {};

      // Update solution images and videos
      solutionImages = solutionList.map<String?>((s) => urlsMap[s as String]).toList();
      solutionVideos = solutionVidsList.map<String?>((s) => urlsMap[s as String]).toList();

      // Log to check if the correct videos are loaded
      print('Updated solution videos for challenge $currentChallengeIndex: $solutionVideos');
    });
  }



  Widget _buildChallengeContent(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Displaying solution videos
        Wrap(
          spacing: screenWidth * 0.05,
          runSpacing: screenHeight * 0.02,
          alignment: WrapAlignment.center,
          children: solutionVideos
              .map((videoUrl) =>
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: videoUrl != null
                      ? VideoWidget(
                      videoUrl: videoUrl) // Custom widget for video
                      : const SizedBox(),
                ),
              ))
              .toList(),
        ),
        SizedBox(height: screenHeight * 0.03),
        // Spacing between videos and images
        // Displaying solution images
        Wrap(
          spacing: screenWidth * 0.05,
          runSpacing: screenHeight * 0.02,
          alignment: WrapAlignment.center,
          children: solutionImages
              .map((imageUrl) =>
              Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : const SizedBox(),
                ),
              ))
              .toList(),
        ),
      ],
    );
  }

  void _moveToNextChallenge() {
    if (currentChallengeIndex < challengeData.length - 1) {
      setState(() {
        currentChallengeIndex++;
        _initializeChallenge(); // Re-initialize to load new challenge data
      });
    } else {
      Navigator.pop(context); // All challenges completed; go back
    }
  }


  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: const Color.fromARGB(255, 252, 133, 37),
                      child: Center(
                        child: Text(
                          imagePath,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
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
                            fontSize: 18,
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

  Widget _buildMediaItem(String? url) {
    if (url == null) return const SizedBox();
    if (url.endsWith(".mp4")) {
      return VideoPlayerWidget(videoUrl: url);
    } else {
      return Image.network(
        url,
        width: double.infinity,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        title: const Text("Review Incorrect Challengers"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: challengeData.isEmpty
          ? Center(
        child: Text(
          "Wohoo! There are no incorrect challengers !!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(
              onTap: () {},
              imagePath: '${currentChallengeIndex + 1}',
              color: Colors.white,
              title: 'Review Your Mistakes In Challenger Round',
              description: "Tap Next to see your mistakes one by one",
              index: 2,
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildChallengeContent(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.06),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 252, 133, 37),
              ),
              onPressed: () {
                if (currentChallengeIndex < challengeData.length - 1) {
                  _moveToNextChallenge();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentChallengeIndex < challengeData.length - 1
                      ? "Next"
                      : "Finish"),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
    class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const CircularProgressIndicator();
  }
}
