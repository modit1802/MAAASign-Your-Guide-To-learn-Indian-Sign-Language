import 'package:SignEase/Week%201/learnalphabet.dart';
import 'package:SignEase/Week%201/learnnumbers.dart';
import 'package:SignEase/Week%202/learngreeting.dart';
import 'package:SignEase/Week%202/learnrelations.dart';
import 'package:SignEase/Week%203/learnnoun.dart';
import 'package:SignEase/Week%203/learnpronoun.dart';
import 'package:SignEase/Week%203/learnverbs.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenWidth * 0.8,
            padding: EdgeInsets.all(screenWidth * 0.03),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
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
                  height: screenWidth * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                    maxLines: 2,
  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
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
                        text: "$username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                      const TextSpan(text: " !"),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 126, 34),
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Learning Zone',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Learn to sign in Indian Sign Language with MAAA...',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenHeight * 0.16,
                            height: screenHeight * 0.16,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: screenWidth * 0.02,
                                    offset: Offset(0, screenHeight * 0.01),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'images/childisl.png',
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
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.5,
                  child: PageView(
                    children: [
                      buildCustomCard(
                        image: AssetImage('images/alphabetcardforlearn.jpg'),
                        title: 'Learn Signing Alphabets',
                        description:
                            'Tap me to Start learning the Signs of Alphabets in Indian Sign Language.',
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
                        title: 'Learn Signing Numbers',
                        description:
                            'Tap me to Start learning the Signs of Numbers in Indian Sign Language',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnNumbers()),
                          );
                        },
                      ),
                      buildCustomCard(
                      image: AssetImage('images/greetings.png'),
                      title: 'Learn Signing Greeting',
                      description:
                          'Tap me to Start learning the Signs of Greetings in Indian Sign Language',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnGreetings()),
                        );
                      },
                    ),
                                         buildCustomCard(
                      image: AssetImage('images/Relation.jpg'),
                      title: 'Learn Signing Relation',
                      description:
                          'Tap me to Start learning the Signs of Relations in Indian Sign Language',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnRelations()),
                        );
                      },
                    ),
                                          buildCustomCard(
                      image: AssetImage('images/verbs.png'),
                      title: 'Learn Signing Verbs',
                      description:
                          'Tap me to Start learning the Signs of Verbs in Indian Sign Language',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnVerbs()),
                        );
                      },
                    ),
                                         buildCustomCard(
                      image: AssetImage('images/nouns.png'),
                      title: 'Learn Signing Nouns',
                      description:
                          'Tap me to Start learning the Signs of Nouns in Indian Sign Language',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnNouns()),
                        );
                      },
                    ),
                      buildCustomCard(
                      image: AssetImage('images/pronouns.png'),
                      title: 'Learn Signing Pronouns',
                      description:
                          'Tap me to Start learning the Signs of Pronouns in Indian Sign Language',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnPronouns()),
                        );
                      },
                    ),
                      // Add other cards similarly...
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