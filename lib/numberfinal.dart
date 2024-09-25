import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_login_signup/progresscheckerscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class numberfinal extends StatefulWidget {
  final int score;
  numberfinal({required this.score});
  @override
  _AlphabetFinalState createState() => _AlphabetFinalState();
}

class _AlphabetFinalState extends State<numberfinal> {
  Timer? _timer;
  bool _showRibbon = true;
  late int score2;

  @override
  void initState() {
    super.initState();
    score2 = widget.score;
    // Start the timer when the widget is initialized
    _timer = Timer(const Duration(seconds: 2), () {
      // After 5 seconds, stop the timer and hide the ribbon
      setState(() {
        _showRibbon = false;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _saveScoreToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        String uid = user.uid; // Get the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'scorenumber': score2, // Store the score
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Number Final"),
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
            // Background image (ribbon.gif)
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _showRibbon ? 1 : 0,
              child: Image.asset(
                'images/ribbon2.gif',
                fit: BoxFit.cover,
              ),
            ),
            // Congratulations message and Card
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
                      'You have completed all the alphabets',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Lets Learn Numbers !!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Card with image (week2)
                    GestureDetector(
                      onTap: () {
                        _saveScoreToFirestore();
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
                              'images/week2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing between the cards
                    // New Card for "Check your progress"
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProgressCheckerScreen()));
                      },
                      child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.4, // Half the height of week2 card
                        alignment: Alignment.center,
                        child: const Text(
                          'Check your progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    )
                  ],
                ),
              ),
            ),
            // Teacher image below the Card
            // Button at the left bottom corner
            Positioned(
              bottom: 20,
              left: 20,
              child: MaterialButton(
                onPressed: () {
                  // Action to perform when the button is pressed
                },
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
                    const SizedBox(
                        width: 8), // Add some space between icon and text
                    Text(
                      '$score2', // Display the score
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
              SystemNavigator.pop(); // Exit the app
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: numberfinal(score: 0),
  ));
}
