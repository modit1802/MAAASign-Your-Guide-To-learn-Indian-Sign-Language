import 'package:SignEase/Week%201/learnalphabet.dart';
import 'package:SignEase/Week%201/learnnumbers.dart';
import 'package:SignEase/Week%202/learngreeting.dart';
import 'package:SignEase/Week%202/learnrelations.dart';
import 'package:SignEase/Week%203/learnnoun.dart';
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

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['name'] ?? 'User';
          });
        } else {
          setState(() {
            username = 'User';
          });
        }
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

  Widget buildCustomCard({
    required ImageProvider image,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300, // Set a fixed width for horizontal scrolling
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 8), // Add horizontal spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Scrollbar(
        thumbVisibility: true, 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(text: "Hi "),
                      TextSpan(
                        text: "$username",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " !"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 133, 37),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Learning Zone',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Click on the weeks to start learning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Transform.translate(
                              offset: const Offset(0, -20),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'images/childisl.png',
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Start Learning Indian Sign Language scroll horizontally ...",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 113, 113, 113),
                        fontWeight: FontWeight.bold),
                  ),
                ),
        
                // Horizontal scroll view for the custom cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildCustomCard(
                        image: AssetImage('images/alphabetcardforlearn.jpg'),
                        title: 'Learn Alphabets',
                        description:
                            'Tap me to Start learning the Alphabets in Indian Sign Language',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnAlphabet()),
                          );
                        },
                      ),
                      buildCustomCard(
                        image: AssetImage('images/numbers.jpg'),
                        title: 'Learn Numbers',
                        description:
                            'Tap me to Start learning the Numbers in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnNumbers()),
                          );
                        },
                      ),
                      buildCustomCard(
                        image: AssetImage('images/greetings.png'),
                        title: 'Learn Greeting',
                        description:
                            'Tap me to Start learning the Greetings in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnGreetings()),
                          );
                        },
                      ),
                      buildCustomCard(
                        image: AssetImage('images/Relation.jpg'),
                        title: 'Learn Relation',
                        description:
                            'Tap me to Start learning the Relations in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnRelations()),
                          );
                        },
                      ),
                      buildCustomCard(
                        image: AssetImage('images/verbs.png'),
                        title: 'Learn common Verbs',
                        description:
                            'Tap me to Start learning the Relations in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnRelations()),
                          );
                        },
                      ),
        
                      buildCustomCard(
                        image: AssetImage('images/nouns.png'),
                        title: 'Learn common Nouns',
                        description:
                            'Tap me to Start learning the Nouns in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnNouns()),
                          );
                        },
                      ),
        
                       buildCustomCard(
                        image: AssetImage('images/pronouns.png'),
                        title: 'Learn common Pronouns',
                        description:
                            'Tap me to Start learning the Pronouns in Indian Sign Language',
                        onTap: () {
                          // Add navigation or action for the second card here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnNouns()),
                          );
                        },
                      ),
        
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
