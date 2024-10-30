import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:SignEase/Week 2/learngreeting.dart';
import 'package:SignEase/Week 2/learnrelations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SignEase/learnalphabet.dart';
import 'package:SignEase/learnnumbers.dart';
import 'package:lottie/lottie.dart';
import 'package:SignEase/login_page.dart'; // Assuming this is the file for LoginPage

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _showAnimation = false;
  User? _currentUser;
  String username = "";
  int scoreAlpha = 0;
  int scoreNumber = 0;
  int learnalphabet = 0;
  int learnnumber = 0;

  @override
  void initState() {
    super.initState();
    _fetchScoreFromFirebase();
    fetchUserName();
    _currentUser = _auth.currentUser;
  }

  Future<void> _fetchScoreFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (snapshot.exists) {
          setState(() {
            scoreAlpha = snapshot.get('scorealpha') ?? 0;
            scoreNumber = snapshot.get('scorenumber') ?? 0;
            learnalphabet = snapshot.get("learnalphabet") ?? 0;
            learnnumber = snapshot.get('learnnumber') ?? 0;
          });
        } else {
          print("No document found for user.");
        }
      }
    } catch (e) {
      print("Error fetching scores: $e");
    }
  }

  void _logout() async {
    setState(() {
      _showAnimation = true;
    });

    try {
      await _auth.signOut();
      Timer(const Duration(seconds: 5), () {
        setState(() {
          _showAnimation = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    } catch (e) {
      print('Logout Error: $e');
      setState(() {
        _showAnimation = false;
      });
    }
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        username = userDoc['name'];
      });
    }
  }

  // Add the pull-to-refresh logic here
  Future<void> _refreshLearnPage() async {
    await _fetchScoreFromFirebase(); // Refresh scores when the user pulls down
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: RefreshIndicator(
              // Add RefreshIndicator
              onRefresh: _refreshLearnPage, // Trigger refresh logic
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Learning Zone",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  221, 255, 255, 255),
                                              fontSize: 40),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1300),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: _currentUser != null
                                          ? Text(
                                              " $username  Learn ISL by clicking on the card",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 231, 240, 255),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(60),
                                      topRight: Radius.circular(60))),
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 20),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 1400),
                                      child: LearnDashboard(
                                          learnAlphabetScore: learnalphabet,
                                          learnNumberScore: learnnumber),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showAnimation) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 219, 69, 249),
            Color.fromARGB(255, 135, 205, 238),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Lottie.asset(
          'assets/loading.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}


class LearnDashboard extends StatefulWidget {
  final int learnAlphabetScore;
  final int learnNumberScore;

  const LearnDashboard(
      {super.key, required this.learnAlphabetScore, required this.learnNumberScore});

  @override
  _LearnDashboardState createState() => _LearnDashboardState();
}

class _LearnDashboardState extends State<LearnDashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Learn Alphabet Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnAlphabet()),
              ).then((_) {
                setState(() {});
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Learn text at the top
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                      'Learn Alphabet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Image container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: const DecorationImage(
                        image: AssetImage('images/alphabet_learn.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (widget.learnAlphabetScore <= 0)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.95),
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                          ),
                        if (widget.learnAlphabetScore == 20)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(201, 250, 180, 1).withOpacity(0.7),
                              backgroundBlendMode: BlendMode.modulate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Tap to Learn text at the bottom
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Tap to Learn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Learn Numbers Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnNumbers()),
              ).then((_) {
                setState(() {});
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Learn text at the top
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                      'Learn Numbers',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Image container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: const DecorationImage(
                        image: AssetImage('images/numbercardforlearn.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (widget.learnNumberScore <= 0)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.95),
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                          ),
                        if (widget.learnNumberScore == 20)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(201, 250, 180, 1).withOpacity(0.7),
                              backgroundBlendMode: BlendMode.modulate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Tap to Learn text at the bottom
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Tap to Learn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Learn Greetings Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnGreetings()),
              ).then((_) {
                setState(() {});
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Learn text at the top
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                      'Learn Greetings',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Image container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: const DecorationImage(
                        image: AssetImage('images/greetings.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (widget.learnNumberScore <= 0)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.95),
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                          ),
                        if (widget.learnNumberScore == 20)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(201, 250, 180, 1).withOpacity(0.7),
                              backgroundBlendMode: BlendMode.modulate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Tap to Learn text at the bottom
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Tap to Learn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Learn Relations Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnRelations()),
              ).then((_) {
                setState(() {});
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Learn text at the top
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                      'Learn Relations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Image container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: const DecorationImage(
                        image: AssetImage('images/Relation.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (widget.learnNumberScore <= 0)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.95),
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                          ),
                        if (widget.learnNumberScore == 20)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(201, 250, 180, 1).withOpacity(0.7),
                              backgroundBlendMode: BlendMode.modulate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Tap to Learn text at the bottom
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Tap to Learn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
