import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _sendBotMessage();
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedMessages = prefs.getStringList('chatHistory');
    if (storedMessages != null) {
      setState(() {
        _messages = storedMessages
            .map((message) => json.decode(message) as Map<String, String>)
            .toList();
      });
    }
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedMessages = _messages
        .map((message) => json.encode(message))
        .toList();
    prefs.setStringList('chatHistory', storedMessages);
  }

  Future<void> _deleteChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('chatHistory');
    setState(() {
      _messages.clear();
    });
  }

  Future<void> _getResponse(String query) async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://rag-chatbot-using-groq-1.onrender.com/ask';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"query": query}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final String chatbotReply = responseData['short_description'];
      final List<dynamic> sourceUrls = responseData['source_urls'];
      final String? imageUrl = responseData['image_url'];

      if (sourceUrls.isNotEmpty) {
        _messages.add({
          "sender": "bot",
          "message": chatbotReply,
          "urls": sourceUrls.join(','),
        });
      } else {
        _messages.add({"sender": "bot", "message": chatbotReply});
      }

      if (imageUrl != null && imageUrl.isNotEmpty && _isImageUrl(imageUrl)) {
        _messages.add({"sender": "bot", "message": "", "image_url": imageUrl});
      }

      await _saveChatHistory();
    } else {
      _messages.add({"sender": "bot", "message": "Sorry, I couldn't understand."});
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isImageUrl(String url) {
    return url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.gif');
  }

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
      _controller.clear();
    });

    _getResponse(userMessage);
  }

List<InlineSpan> _parseMessage(String message) {
  final regex = RegExp(r'\*\*(.*?)\*\*');
  final spans = <InlineSpan>[];
  int start = 0;

  for (final match in regex.allMatches(message)) {
    if (match.start > start) {
      spans.add(TextSpan(text: message.substring(start, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(1),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
    start = match.end;
  }

  if (start < message.length) {
    spans.add(TextSpan(text: message.substring(start)));
  }

  return spans;
}

  Widget _buildMessageBubble(String sender, String message, {String? urls, String? imageUrl}) {
    bool isUser = sender == 'user';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Colors.orange.shade300,
              child: Icon(Icons.android, color: Colors.white),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(colors: [Color(0xFFff8a3d), Color(0xFFFF7C00)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrl, height: 150, width: 200, fit: BoxFit.cover),
                    ),
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  if (urls != null) _buildVideoLinks(urls),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8),
        ],
      ),
    );
  }

Widget _buildVideoLinks(String urls) {
  List<String> urlList = urls.split(',');
  return Column(
    children: [
      // Adding the "For more information..." text above the video links
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          "For more information, you can refer to the below videos:",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      // Video links
      ...List.generate(
        urlList.length,
        (index) => GestureDetector(
          onTap: () => _navigateToVideoScreen(urlList[index]),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 224, 118, 30),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Watch Video ${index + 1}",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ],
  );
}

  void _navigateToVideoScreen(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(url: url),
      ),
    );
  }

  void _sendBotMessage() {
    setState(() {
      _messages.add({
        "sender": "bot",
        "message": "Hello! I am MAAASign chatbot 🤖. Feel free to ask anything related to ISL signs or videos!"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5EF),
      appBar: AppBar(
        backgroundColor: Color(0xFFff8a3d),
        title: Text('MAAASign Chatbot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: _deleteChatHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (ctx, index) {
                final messageData = _messages.reversed.toList()[index];
                return _buildMessageBubble(
                  messageData['sender']!,
                  messageData['message'] ?? '',
                  urls: messageData['urls'],
                  imageUrl: messageData['image_url'],
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Color(0xFFff8a3d)),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Color(0xFFff8a3d),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String url;
  const VideoScreen({super.key, required this.url});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();

    // Check if the URL is a video or image
    if (_isVideoUrl(widget.url)) {
      _isVideo = true;
      _videoPlayerController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }
  }

  // Check if the URL is for a video
  bool _isVideoUrl(String url) {
    return url.endsWith('.mp4');
  }

  @override
  void dispose() {
    super.dispose();
    if (_isVideo) {
      _videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Viewer'),
      ),
      body: Center(
        child: _isVideo
            ? _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : const CircularProgressIndicator()
            : Image.network(widget.url), // Display image if it's not a video
      ),
    );
  }
}