// import 'package:flutter/material.dart';

// class ChatBot extends StatefulWidget {
//   const ChatBot({super.key});

//   @override
//   State<ChatBot> createState() => _ChatBotState();
// }

// class _ChatBotState extends State<ChatBot> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _chat = [];
//   final ScrollController _scrollController = ScrollController();

//   // Theme colors
//   static const Color _bgColor = Color.fromARGB(255, 250, 233, 215);
//   static const Color _primaryColor = Color.fromARGB(255, 165, 74, 17);
//   static const Color _userBubbleColor = Color.fromARGB(255, 255, 238, 219);
//   static const Color _botBubbleColor = Color.fromARGB(255, 235, 250, 234);

//   final Map<String, String> _islMapping = {
//     'hello': 'https://res.cloudinary.com/demo/image/upload/hello.jpg',
//     'good morning': 'https://res.cloudinary.com/demo/image/upload/goodmorning.jpg',
//     'good afternoon': 'https://res.cloudinary.com/demo/image/upload/goodafternoon.jpg',
//     'good evening': 'https://res.cloudinary.com/demo/image/upload/goodevening.jpg',
//     'thank you': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726927/watch_txuhl8.png',

    
//     // Add more mappings here
//   };

//   @override
//   void initState() {
//     super.initState();
//     // Intro message
//     _chat.add({
//       'bot': "👋 Hello! I'm MAAA Bot.\nAsk me how to say any phrase in ISL."
//     });
//     // ensure we scroll to show intro
//     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//   }

//   void _handleMessage(String message) {
//     if (message.isEmpty) return;

//     setState(() {
//       _chat.add({'user': message});
//     });
//     _scrollToBottom();

//     final lowerMsg = message.toLowerCase();
//     String? foundKey;
//     for (final word in _islMapping.keys) {
//       if (lowerMsg.contains(word)) {
//         foundKey = word;
//         break;
//       }
//     }

//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         if (foundKey != null) {
//           _chat.add({
//             'bot': 'Here is how you sign "$foundKey" in ISL:',
//             'img': _islMapping[foundKey]!,
//           });
//         } else {
//           _chat.add({'bot': "Sorry, I don't understand that yet."});
//         }
//       });
//       _scrollToBottom();
//     });

//     _controller.clear();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Widget _buildMessage(Map<String, String> msg) {
//     final isUser = msg.containsKey('user');
//     final text = isUser ? msg['user']! : msg['bot']!;
//     final hasImage = msg.containsKey('img');

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       child: Row(
//         mainAxisAlignment:
//             isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Bot avatar
//           if (!isUser)
//             CircleAvatar(
//               backgroundColor: _primaryColor,
//               child: const Icon(Icons.smart_toy, color: Colors.white),
//             ),
//           if (!isUser) const SizedBox(width: 8),

//           // Message bubble + optional image
//           Flexible(
//             child: Column(
//               crossAxisAlignment: isUser
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isUser ? _userBubbleColor : _botBubbleColor,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 2,
//                         offset: Offset(0, 1),
//                       )
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     text,
//                     style: const TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                 ),
//                 if (hasImage) ...[
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       msg['img']!,
//                       height: 180,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ]
//               ],
//             ),
//           ),

//           // User avatar
//           if (isUser) const SizedBox(width: 8),
//           if (isUser)
//             CircleAvatar(
//               backgroundColor: _primaryColor,
//               child: const Icon(Icons.person, color: Colors.white),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bgColor,
//       appBar: AppBar(
//         title: const Text(
//           'Ask MAAA: ISL Bot',
//           style: TextStyle(
//             color: _primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: _primaryColor),
//         elevation: 1,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//               itemCount: _chat.length,
//               itemBuilder: (_, i) => _buildMessage(_chat[i]),
//             ),
//           ),
//           const Divider(height: 1),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     textCapitalization: TextCapitalization.sentences,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       hintStyle: TextStyle(color: Colors.grey[600]),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide:
//                             const BorderSide(color: _primaryColor),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: const BorderSide(
//                             color: _primaryColor, width: 2),
//                       ),
//                     ),
//                     onSubmitted: (t) => _handleMessage(t.trim()),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: _primaryColor,
//                   radius: 24,
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white),
//                     onPressed: () =>
//                         _handleMessage(_controller.text.trim()),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _chat = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // Theme colors
  static const Color _bgColor = Color.fromARGB(255, 250, 233, 215);
  static const Color _primaryColor = Color.fromARGB(255, 165, 74, 17);
  static const Color _userBubbleColor = Color.fromARGB(255, 255, 238, 219);
  static const Color _botBubbleColor = Color.fromARGB(255, 235, 250, 234);

  final Map<String, String> _islMapping = {
    'hello': 'https://res.cloudinary.com/demo/image/upload/hello.jpg',
    'good morning': 'https://res.cloudinary.com/demo/image/upload/goodmorning.jpg',
    'good afternoon': 'https://res.cloudinary.com/demo/image/upload/goodafternoon.jpg',
    'good evening': 'https://res.cloudinary.com/demo/image/upload/goodevening.jpg',
    'thank you': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1732726927/watch_txuhl8.png',
  };

  @override
  void initState() {
    super.initState();
    _chat.add({
      'bot': "👋 Hello! I'm MAAA Bot.\nAsk me how to say any phrase in ISL.",
      'reaction': null,
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _handleMessage(String message) {
    if (message.isEmpty) return;
    setState(() {
      _chat.add({'user': message, 'reaction': null});
      _isTyping = true;
    });
    _scrollToBottom();

    final lowerMsg = message.toLowerCase();
    String? foundKey;
    for (final word in _islMapping.keys) {
      if (lowerMsg.contains(word)) {
        foundKey = word;
        break;
      }
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isTyping = false;
        if (foundKey != null) {
          _chat.add({
            'bot': 'Here is how you sign "$foundKey" in ISL:',
            'img': _islMapping[foundKey]!,
            'reaction': null,
          });
        } else {
          _chat.add({'bot': "Sorry, I don't understand that yet.", 'reaction': null});
        }
      });
      _scrollToBottom();
    });

    _controller.clear();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _chat.clear();
      _chat.add({
        'bot': "👋 Hello! I'm MAAA Bot.\nAsk me how to say any phrase in ISL.",
        'reaction': null,
      });
    });
    _scrollToBottom();
  }

  void _addReaction(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final emojis = ['👍', '❤️', '😂', '😮', '😢', '😡'];
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 10,
            children: emojis.map((e) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _chat[index]['reaction'] = e;
                  });
                  Navigator.pop(context);
                },
                child: Text(e, style: const TextStyle(fontSize: 28)),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _primaryColor,
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          const TypingIndicator(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg, int index) {
    final isUser = msg.containsKey('user');
    final text = isUser ? msg['user'] as String : msg['bot'] as String;
    final hasImage = msg.containsKey('img');
    final reaction = msg['reaction'] as String?;

    return GestureDetector(
      onLongPress: () => _addReaction(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              CircleAvatar(
                backgroundColor: _primaryColor,
                child: const Icon(Icons.smart_toy, color: Colors.white, semanticLabel: 'Bot'),
              ),
            if (!isUser) const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isUser ? _userBubbleColor : _botBubbleColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(text, style: const TextStyle(fontSize: 16)),
                  ),
                  if (hasImage) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        msg['img'] as String,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  if (reaction != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(reaction, style: const TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ),
            if (isUser) const SizedBox(width: 8),
            if (isUser)
              CircleAvatar(
                backgroundColor: _primaryColor,
                child: const Icon(Icons.person, color: Colors.white, semanticLabel: 'User'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          'Ask MAAA: ISL Bot',
          style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: _primaryColor),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, semanticLabel: 'Clear Chat'),
            tooltip: 'Clear Chat',
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: _chat.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _chat.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_chat[i], i);
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: _primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: _primaryColor, width: 2),
                      ),
                    ),
                    onSubmitted: (t) => _handleMessage(t.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Send',
                  child: CircleAvatar(
                    backgroundColor: _primaryColor,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, semanticLabel: 'Send'),
                      onPressed: () =>
                          _handleMessage(_controller.text.trim()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0, right: 16.0),
        child: Tooltip(
          message: 'Scroll to Bottom',
          child: FloatingActionButton(
            backgroundColor: _primaryColor,
            onPressed: _scrollToBottom,
            child: const Icon(Icons.arrow_downward,
                semanticLabel: 'Scroll to Bottom'),
          ),
        ),
      ),
    );
  }
}

/// A simple animated typing indicator with three bouncing dots.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animations = List.generate(3, (i) {
      return Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.2, i * 0.2 + 0.6, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return FadeTransition(
          opacity: _animations[i],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
