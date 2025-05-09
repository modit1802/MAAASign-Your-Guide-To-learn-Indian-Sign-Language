
import 'package:SignEase/Week%201/week1_entry.dart';
import 'package:SignEase/Week%202/week2_entry.dart';
import 'package:SignEase/Week%203/week3_entry.dart';
import 'package:SignEase/Week%204/week4_entry.dart';
import 'package:SignEase/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'Bonus_Week/bonus_week_entry.dart';
import 'Week 5/week5_entry.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  String username = 'Loading...';
  String? score_challenger_week1 = '0';
  String? score_challenger_week2 = '0';
   String? score_challenger_week3 = '0';
   String? score_challenger_week4 = '0';
   String? score_numbers='0';
  String? score_numbers_quiz='0';
  String? score_numbers_match='0';
   String? comingsoon = '0';
     late mongo.Db db;
  late mongo.DbCollection userCollection;

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
    _getUsername();
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
    try {
      await db.open();
      userCollection = db.collection('users');
      await fetchResultsFromMongoDB();
      print("Connected to MongoDB and result fetched!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchResultsFromMongoDB() async {
    String? userId = await getUserId();
    var result = await userCollection.findOne(mongo.where.eq('userId', userId));
    setState(() {
      if (result != null) {
        score_numbers_quiz = result['week']?['week1']?['Score_number']
        ?['score_number']?.toString()??'0';
        score_numbers_match = result['week']?['week1']?['Score_number_match']
        ?['score_number_match']?.toString()??'0';
        score_challenger_week1 = result['week']?['week1']?['Score_Challenger_week1']
                ?['score_challenger']
            ?.toString()??'0';
        int score_numbers_quiz1 = int.tryParse(score_numbers_quiz!) ?? 0;
        int score_numbers_match1 = int.tryParse(score_numbers_match!) ?? 0;

        int score_numbers_int = score_numbers_quiz1 + score_numbers_match1;
        score_numbers=score_numbers_int?.toString()??'0';
        print(score_challenger_week1);
        score_challenger_week2 = result['week']?['week2']?['Score_Challenger_Week2']
                ?['score_challenger']
            ?.toString()??'0';
        score_challenger_week3=result['week']?['week3']?['Score_Challenger_Week3']
        ?['score_challenger']
            ?.toString()??'0';
        print(score_challenger_week3);
        score_challenger_week4 = result['week']?['Week4']?['Score_Challenger_Week4']
                ?['score_challenger']
            ?.toString()??'0';
        print(score_challenger_week4);
      } else {
        score_challenger_week1 = '0';
        score_challenger_week2='0';
        score_challenger_week3='0';
        score_challenger_week4='0';
        print('No data found');
      }
    });
    await db.close();
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
  required VoidCallback onTap,
  required int scoreChallengerWeek1, // Add this parameter for score
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      // Check if the score is greater than 650
      bool isScoreAbove650 = scoreChallengerWeek1 > 650;

      return GestureDetector(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Container(
            width: screenWidth * 0.8, // Adjust width based on screen size
            padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive margin
            decoration: BoxDecoration(
              color: isScoreAbove650 ? const Color.fromARGB(255, 255, 151, 87) : Colors.white, // Background color change based on score
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
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
                  height: screenWidth * 0.6, // Responsive height for the image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive spacing
                Center(
                  child:
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,              // Disable wrapping
                    overflow: TextOverflow.ellipsis,  // Clip the text instead of showing ellipsis
                    maxLines: 1,
                  ),
                ),
                ),
              ],
            ),
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
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          color: Colors.black,
        ),
        children: <TextSpan>[
          const TextSpan(text: "Hi "),
          TextSpan(
            text: username,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.06,
              color: const Color(0xFF1E1E1E),
            ),
          ),
          const TextSpan(text: " !"),
        ],
      ),
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeaderBoard(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFC107), Color(0xFFFF8C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              "LeaderBoard",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

              SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 224, 118, 30),
                            const Color.fromARGB(255, 230, 136, 23),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: screenWidth * 0.05,
                            offset: Offset(0, screenHeight * 0.02),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Challenge Zone',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.07,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: screenWidth * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.008,
                                        horizontal: screenWidth * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.02),
                                    ),
                                    child: Text(
                                      'Challenge yourself by clicking on weeks!',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            SizedBox(
                              width: screenHeight * 0.1,
                              height: screenHeight * 0.1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.grey.shade300,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.05),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0),
                                      blurRadius: screenWidth * 0.04,
                                      offset: Offset(0, screenHeight * 0.015),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.05),
                                  child: Image.asset(
                                    'images/scoreisl.png',
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add an arrow icon
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: screenWidth * 0.04, // Responsive icon size
                    ),
                    SizedBox(width: screenWidth * 0.02), // Add spacing between text and icons
                    Text(
                      "Scroll horizontally",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02, // Responsive font size
                        color: Color.fromARGB(255, 113, 113, 113),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02), // Add spacing
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: screenWidth * 0.04, // Responsive icon size
                    ),
                  ],
                ),
              ),

              // PageView implementation
              SizedBox(
                height: screenHeight * 0.4, // Adjust the height as needed
                child: PageView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/chapter1.png'),
                        title: 'Alphabets & Numbers',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Week1Entry()),
                          );
                        },
                        scoreChallengerWeek1: int.parse(score_challenger_week1??'0')
                      ),
                    ),
                    if (score_numbers != null && int.parse(score_numbers ?? '0') > 600) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Week_bonus.png'),
                        title: 'Maths Operators',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bonus_Week_Entry()),
                          );
                        }, scoreChallengerWeek1: int.parse(score_challenger_week2??'0'),
                      ),
                    ) else Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Week_bonus.png'),
                        title: 'Maths Operators 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Can't open this bonus week yet,please score more than 600 in Numbers Section of Week 1"),
                            ),
                          );
                        },
                        scoreChallengerWeek1: int.parse(score_challenger_week2??'0'),
                      ),
                    ),
              if (score_challenger_week1 != null && int.parse(score_challenger_week1 ?? '0') > 650) Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildCustomCard(
                              image: AssetImage('images/chapter2.png'),
                              title: 'Greetings & Relations ',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Week2NewScreen()),
                                );
                              }, scoreChallengerWeek1: int.parse(score_challenger_week2??'0'),
                            ),
                          ) else Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildCustomCard(
                                image: AssetImage('images/chapter2.png'),
                                title: 'Greetings & Relations 🔒',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Can't open this week yet please score more than 650 in week 1"),
                                    ),
                                  );
                                },
                                  scoreChallengerWeek1: int.parse(score_challenger_week2??'0'),
                              ),
                            ),
                    if (score_challenger_week2 != null && int.parse(score_challenger_week2 ?? '0') > 650) Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildCustomCard(
                              image: AssetImage('images/chapter3.png'),
                              title: 'Noun,Verbs & Pronouns',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Week3Entry()),
                                );
                              }, scoreChallengerWeek1: int.parse(score_challenger_week3??'0'),
                            ),
                          ) else Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildCustomCard(
                                image: AssetImage('images/chapter3.png'),
                                title: 'Noun,Verbs & Pronouns 🔒',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Can't open this week yet please score more than 650 in week 2"),
                                    ),
                                  );
                                },
                                  scoreChallengerWeek1: int.parse(score_challenger_week3??'0'),
                              ),
                            ),
              
                   if (score_challenger_week3 != null && int.parse(score_challenger_week3 ?? '0') > 650) Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildCustomCard(
                              image: AssetImage('images/chapter4.png'),
                              title: 'Simple Sentence Formation',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Week4Entry()),
                                );
                              }, scoreChallengerWeek1: int.parse(score_challenger_week4??'0'),
                            ),
                          ) else Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildCustomCard(
                                image: AssetImage('images/chapter4.png'),
                                title: 'Simple Sentence Formation 🔒',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Can't open this week yet please score more than 650 in week 3"),
                                    ),
                                  );
                                },
                                  scoreChallengerWeek1: int.parse(score_challenger_week4??'0'),
                              ),
                            ),
                    if (score_challenger_week4 != null && int.parse(score_challenger_week4 ?? '0') > 650) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Week5.png'),
                        title: 'Adjectives and Adverbs',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Week5Entry()),
                          );
                        }, scoreChallengerWeek1: int.parse(score_challenger_week4??'0'),
                      ),
                    ) else Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Week5.png'),
                        title: 'Adjectives and Adverbs 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Can't open this week yet please score more than 650 in week 4"),
                            ),
                          );
                        },
                        scoreChallengerWeek1: int.parse(score_challenger_week4??'0'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Chapter6.png'),
                        title: 'Verb Placement and Tense 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Week 6 will be available soon"),
                            ),
                          );
                        },
                        scoreChallengerWeek1: int.parse(comingsoon!??'0'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Chapter7.png'),
                        title: 'Handling Time and Aspect 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Week 7 will be available soon"),
                                    ),
                                  );
                        },
                        scoreChallengerWeek1: int.parse(comingsoon!??'0'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Chapter8.png'),
                        title: 'Questions 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Week 8 will be available soon"),
                                    ),
                                  );
                        },
                        scoreChallengerWeek1: int.parse(comingsoon!??'0'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Chapter9.png'),
                        title: 'Negation 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Week 9 will be available soon"),
                                    ),
                                  );
                        },
                        scoreChallengerWeek1: int.parse(comingsoon!??'0'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCustomCard(
                        image: AssetImage('images/Chapter10.png'),
                        title: 'Plurals 🔒',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Week 10 will be available soon"),
                                    ),
                                  );
                        },
                        scoreChallengerWeek1: int.parse(comingsoon!??'0'),
                      ),
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
