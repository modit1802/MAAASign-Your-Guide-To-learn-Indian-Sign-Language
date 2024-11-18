import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

// VideoWidget - Used to handle the video playback
class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({
    Key? key,
    required this.videoUrl,
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

      _controller.play(); // Automatically play the video when initialized

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

  void _replayVideo() {
    _controller.seekTo(Duration.zero); // Go back to the start of the video
    _controller.play(); // Play the video again

    setState(() {
      _showOverlay = false; // Remove overlay on replay click
    });
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
            : const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 238, 126, 34)),)),
        if (_showOverlay)
          GestureDetector(
            onTap: _replayVideo,
            child: Container(
              color: Colors.black.withOpacity(0.5), // Black shadow overlay
              child: Center(
                child: Icon(
                  Icons.replay,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Search_Video_Screen - Displays the word and video player
class Search_Video_Screen extends StatefulWidget {
  final String word;
  final String link;  // Video URL or PNG image URL

  const Search_Video_Screen({Key? key, required this.word, required this.link})
      : super(key: key);

  @override
  State<Search_Video_Screen> createState() => _Search_Video_ScreenState();
}

class _Search_Video_ScreenState extends State<Search_Video_Screen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the link is a video or image URL (based on the extension)
    bool isVideo = widget.link.endsWith('.mp4'); // You can extend this check for other video formats
    bool isImage = widget.link.endsWith('.png');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word), // Display the word in the app bar
        backgroundColor: const Color.fromARGB(255, 250, 233, 215), // Customize the app bar color
      ),
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container to display the word with orange color and rounded corners
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 126, 34),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                widget.word,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Check if the link is a video or an image and show accordingly
            if (isVideo)
              Card(
                elevation: 5,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Match the card's border radius
                  child: AspectRatio(
                    aspectRatio: 9 / 16, // 9:16 aspect ratio for video
                    child: VideoWidget(
                      videoUrl: widget.link,
                    ),
                  ),
                ),
              ),
            if (isImage)
              Card(
                elevation: 5,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Match the card's border radius
                  child: Image.network(
                    widget.link,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
