import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedMessages = prefs.getStringList('chat_history');
    if (savedMessages != null) {
      setState(() {
        _messages.addAll(savedMessages.map((msg) {
          Map<String, dynamic> jsonMsg = jsonDecode(msg);
          return ChatMessage(text: jsonMsg['text'], isUser: jsonMsg['isUser']);
        }).toList());
      });
    }
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = _messages
        .map((msg) => jsonEncode({'text': msg.text, 'isUser': msg.isUser}))
        .toList();
    await prefs.setStringList('chat_history', chatHistory);
  }

  Future<void> _sendMessage() async {
    String userMessage = _textController.text.trim().toLowerCase();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _textController.clear();
      _isLoading = true;
    });

    await _saveChatHistory();

    if (!userMessage.contains("sign")) {
      setState(() {
        _messages.add(ChatMessage(
            text: "Sorry, I can only assist with Indian Sign Language.",
            isUser: false));
        _isLoading = false;
      });
      await _saveChatHistory();
      return;
    }

    const String apiKey = 'AIzaSyB6CVj-eRnnC6Ror4Hlm8tPOSppqZrGdpU';
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userMessage}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('candidates') &&
            jsonData['candidates'].isNotEmpty) {
          setState(() {
            _messages.add(ChatMessage(
              text: jsonData['candidates'][0]['content']['parts'][0]['text'],
              isUser: false,
            ));
          });
        } else {
          setState(() {
            _messages.add(ChatMessage(
                text: "Unexpected response format", isUser: false));
          });
        }
      } else {
        setState(() {
          _messages.add(ChatMessage(
              text: 'Error: ${response.statusCode}', isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error: $e', isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      await _saveChatHistory();
    }
  }

  Future<void> _clearChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAAASign ChatBot (AI Powered)',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 223, 115, 0),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 206, 124, 1),
                Color.fromARGB(255, 252, 154, 55)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _clearChat,
            tooltip: "Clear Chat",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10), // Bottom margin 20 kiya
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 3),
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Type your message...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      _isLoading
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: Colors.orange),
              ),
            )
          : GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 206, 124, 1),
                      Color(0xFFFF7043)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
    ],
  ),
),

        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 238, 126, 34) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
