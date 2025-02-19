import 'package:SignEase/searched_video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LearningZone extends StatefulWidget {
  const LearningZone({super.key});

  @override
  State<LearningZone> createState() => _LearningZoneState();
}

class _LearningZoneState extends State<LearningZone> {
  String username = 'Loading...';
  final TextEditingController _searchController = TextEditingController();

  final Map<String, String> allWords = {
    'I write book':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839168/1_yo1wdo.mp4',
    'They work in office':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839158/3_imckgt.mp4',
    'I talk to friends':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839159/24_rgdnba.mp4',
    'I Live in a house':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/17_giamsf.mp4',
    'They look at birds':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/20_logbq8.mp4',
  };

  List<MapEntry<String, String>> filteredWords = [];

  @override
  void initState() {
    super.initState();
    _getUsername();
    _searchController.addListener(filterSuggestions);
  }

  void filterSuggestions() {
    final query = _searchController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
    setState(() {
      filteredWords = query.isEmpty
          ? []
          : allWords.entries
              .where((entry) => entry.key.toLowerCase().startsWith(query))
              .toList()
        ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

      if (filteredWords.isEmpty && query.isNotEmpty) {
        filteredWords.add(MapEntry("Not exist", ""));
      }
    });
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          username = userDoc.exists ? (userDoc['name'] ?? 'User') : 'User';
        });
      } catch (e) {
        setState(() {
          username = 'Error fetching username';
        });
        print('Error fetching username: $e');
      }
    } else {
      setState(() {
        username = 'No User';
      });
    }
  }

  // Method to build custom suggestion with bold text
  Text buildBoldText(String text, String query) {
    int startIndex = text.toLowerCase().indexOf(query.toLowerCase());
    if (startIndex != -1) {
      String match = text.substring(startIndex, startIndex + query.length);
      String beforeMatch = text.substring(0, startIndex);
      String afterMatch = text.substring(startIndex + query.length);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: beforeMatch),
            TextSpan(
                text: match, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: afterMatch),
          ],
        ),
      );
    } else {
      return Text(text); // Return regular text if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: screenWidth * 0.06, color: Colors.black),
                      children: <TextSpan>[
                        const TextSpan(text: "Hi "),
                        TextSpan(
                          text: username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.06),
                        ),
                        const TextSpan(text: " !"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type Word/Sentence to search ...",
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            String query = _searchController.text.trim();
                            if (query.isNotEmpty) {
                              final entry = filteredWords.firstWhere(
                                (entry) => entry.key
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()),
                                orElse: () => MapEntry('', ''),
                              );
                              if (entry.key.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Search_Video_Screen(
                                      word: entry.key,
                                      link: entry.value,
                                    ),
                                  ),
                                );
                              }
                              _searchController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: filteredWords.map((entry) {
                      return ListTile(
                        title: buildBoldText(entry.key, _searchController.text),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search_Video_Screen(
                                word: entry.key,
                                link: entry.value,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  // Other widgets and UI elements
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
