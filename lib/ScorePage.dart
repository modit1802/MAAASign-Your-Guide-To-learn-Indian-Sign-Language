import 'package:SignEase/Challengers_All_Weeks/challenger_week1/DetailedProgressWeek1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week3/DetailedProgressWeek3.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week2/DetailedProgressWeek2.dart';

import 'Challengers_All_Weeks/challenger_Week4/DetailedProgressWeek4.dart';


class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String username = 'Loading...';
  int? _selectedCardIndex;
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? score_challenger;
  String? score_challenger_week3;
  String? score_challenger_week2;
  String? score_challenger_week4;

  @override
  void initState() {
    super.initState();
    _getUsername();
    connectToMongoDB();
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
        score_challenger = result['week']?['week1']?['Score_Challenger_week1']
                ?['score_challenger']
            ?.toString();
        print(score_challenger);
        score_challenger_week3=result['week']?['week3']?['Score_Challenger_Week3']
        ?['score_challenger']
            ?.toString();
        print(score_challenger_week3);
        score_challenger_week2=result['week']?['week2']?['Score_Challenger_Week2']
        ?['score_challenger']
            ?.toString();
        print(score_challenger_week2);
        score_challenger_week4=result['week']?['week4']?['Score_Challenger_Week4']
        ?['score_challenger']
            ?.toString();
        print(score_challenger_week4);
      } else {
        score_challenger = null;
        score_challenger_week3=null;
        score_challenger_week2=null;
        score_challenger_week4=null;
        print('No data found');
      }
    });
    await db.close();
  }

  Widget _buildCard({
  required VoidCallback onTap,
  required Color color,
  required String title,
  required String description,
  required int index,
  required int score,
}) {
  final bool isSelected = _selectedCardIndex == index;
  double percent = score / 1000.0;
    double screenWidth = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 10,
      color: isSelected ? Color.fromARGB(255, 223, 123, 42) : color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 100, // Fixed height
          child: Row(
            children: [
              Container(
                width: 100, // Fixed width for the circle
                height: 100, // Fixed height for the circle
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: percent.clamp(0.0, 1.0),
                    center: Text(
                      "${(percent * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                    ),
                    progressColor: Color.fromARGB(255, 252, 133, 37),
                    backgroundColor: Colors.grey.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: isSelected ? Colors.white : Colors.black,
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
  void _handleCardTap(int index, Widget nextPage) {
    setState(() {
      _selectedCardIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      ).then((_) => setState(() {
            _selectedCardIndex = null;
          }));
    });
  }

@override
Widget build(BuildContext context) {
  // Get the screen size using MediaQuery
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Color.fromARGB(255, 250, 233, 215),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,  // 4% padding from left and right
          vertical: screenHeight * 0.02,   // 2% padding from top and bottom
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Text
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: screenHeight * 0.03,  // Responsive font size
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: "Hi "),
                  TextSpan(
                    text: "$username",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " !"),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Score Zone Container
            Center(
              child: Container(
                height: screenHeight * 0.2, // Adjusted height based on screen size
                width: screenWidth * 0.9,  // 90% of screen width
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 126, 34),
                  borderRadius: BorderRadius.circular(screenWidth * 0.01), // Responsive borderRadius
                  
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Score Zone Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Score Zone',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.025, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Score Image Container
                        Container(
                          height: screenHeight * 0.15, // Fixed height for image container
                          width: screenHeight * 0.15, // Square container based on screen height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive borderRadius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: screenWidth * 0.05, // Responsive blur radius for shadow
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/scoreisl.png',
                              width: screenWidth * 0.25, // Scaled image size
                              height: screenWidth * 0.25, // Scaled image size
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Score Board Section
            if (score_challenger != null || score_challenger_week3 != null || score_challenger_week2 != null || score_challenger_week4 != null)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Text(
                  "Score Board...",
                  style: TextStyle(
                    fontSize: screenHeight * 0.02, // Responsive font size
                    color: Color.fromARGB(255, 113, 113, 113),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (score_challenger != null)
                _buildCard(
                  onTap: () => _handleCardTap(2, const DetailedProgressWeek1()),
                  color: Colors.white,
                  title: 'Week 1',
                  description:
                      'See the detailed score!',
                  index: 2,
                  score: int.parse(score_challenger!),
                ),
              if (score_challenger_week2 != null)
                _buildCard(
                  onTap: () => _handleCardTap(3, const DetailedProgressWeek2()),
                  color: Colors.white,
                  title: 'Week 2',
                  description:
                  'See the detailed score!',
                  index: 3,
                  score: int.parse(score_challenger_week2!),
                ),
              if (score_challenger_week3 != null)
                _buildCard(
                  onTap: () => _handleCardTap(1, const DetailedProgressWeek3()),
                  color: Colors.white,
                  title: 'Week 3',
                  description:
                  'See the detailed score!',
                  index: 1,
                  score: int.parse(score_challenger_week3!),
                ),
            if (score_challenger_week4 != null)
              _buildCard(
                onTap: () => _handleCardTap(1, const DetailedProgressWeek4()),
                color: Colors.white,
                title: 'Week 4',
                description:
                'See the detailed score!',
                index: 1,
                score: int.parse(score_challenger_week4!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
