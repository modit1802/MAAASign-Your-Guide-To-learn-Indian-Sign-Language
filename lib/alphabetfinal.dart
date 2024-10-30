import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/numberstartscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlphabetFinal extends StatefulWidget {
  final int score;
  const AlphabetFinal({super.key, required this.score});
  @override
  _AlphabetFinalState createState() => _AlphabetFinalState();
}

class _AlphabetFinalState extends State<AlphabetFinal> {
  Timer? _timer;
  bool _showRibbon = true;
  bool _showTeacher = false;
  late int score;

  @override
  void initState() {
    super.initState();
    score = widget.score;

    // Start the timer when the widget is initialized
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showRibbon = false;
        _showTeacher = true;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // Function to save score to Firestore database
  Future<void> _saveScoreToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        String uid = user.uid; // Get the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'scorealpha': score, // Store the score
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Alphabet Final"),
          backgroundColor: const Color.fromARGB(255, 207, 238, 252),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 207, 238, 252),
                    Color.fromARGB(255, 242, 222, 246),
                    Colors.white
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _showRibbon ? 1 : 0,
              child: Image.asset(
                'images/ribbon2.gif',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You have completed all the alphabets !!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Let\'s Learn Numbers!!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _saveScoreToFirestore(); // Save score to Firestore
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NumberStartScreen()),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            child: Image.asset(
                              'images/number.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _showTeacher ? 1 : 0,
                child: Image.asset(
                  'images/teacher.gif',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.transparent,
                elevation: 0,
                shape: const CircleBorder(),
                child: Row(
                  children: [
                    Image.asset(
                      'images/trophy.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 49, 89),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to leave?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InitialPage1()));
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    ).then((value) {
      return false;
    });
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AlphabetFinal(score: 0),
  ));
}
