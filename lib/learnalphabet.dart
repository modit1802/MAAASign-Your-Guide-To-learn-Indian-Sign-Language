import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
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
      home: const LearnAlphabet(),
    );
  }
}

class LearnAlphabet extends StatefulWidget {
  const LearnAlphabet({super.key});

  @override
  _LearnAlphabetState createState() => _LearnAlphabetState();
}

class _LearnAlphabetState extends State<LearnAlphabet> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

  @override
  void initState() {
    super.initState();
    _storePoints();
  }

  Future<void> _storePoints() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        String uid = user.uid; // Get the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'learnalphabet': 20, // Store the score
          'timestamp': FieldValue.serverTimestamp(), // Store the current time
        }, SetOptions(merge: true)); // Merge with existing data if present
        print("Score saved to Firestore for user ID: $uid");
      }
    } catch (e) {
      print("Error saving score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Learn Alphabet"),
        backgroundColor: const Color.fromARGB(255, 219, 69, 249),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
             Color.fromARGB(255, 219, 69, 249),
            Color.fromARGB(255, 135, 205, 238),
              Colors.white
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: const Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  AlphabetLearn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlphabetLearn extends StatefulWidget {
  const AlphabetLearn({super.key});

  @override
  State<AlphabetLearn> createState() => _AlphabetLearnState();
}

class _AlphabetLearnState extends State<AlphabetLearn>
    with SingleTickerProviderStateMixin {
  List<String> alphabetImages = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z'
  ];

  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    // No popup functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, 50 * (1 - _animation.value)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: alphabetImages.map((imageName) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: [
                              Card(
                                elevation: 6.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: FutureBuilder<Widget>(
                                      future: _loadGif('images/Alphabets/$imageName.gif'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                          return snapshot.data!;
                                        } else {
                                          return Container(
                                            width: 300,
                                            height: 300,
                                            color: Colors.grey,
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              AlphabetPngCard(
                                imageName: imageName,
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> _loadGif(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    return Container(
      color: Colors.white,
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AlphabetPngCard extends StatelessWidget {
  final String imageName;

  const AlphabetPngCard({super.key, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        elevation: 6.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'images/Alphabets/$imageName.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
