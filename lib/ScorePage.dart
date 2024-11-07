import 'package:SignEase/Challengers_All_Weeks/challenger_week1/DetailedProgressWeek1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week3/DetailedProgressWeek3.dart';

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
      } else {
        score_challenger = null;
        score_challenger_week3=null;
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
    required int score, // Add score parameter
  }) {
    final bool isSelected = _selectedCardIndex == index;

    // Calculate percentage based on score as a value out of 1000
    double percent = score / 1000.0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? Color.fromARGB(255, 252, 133, 37) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                // Container with CircularPercentIndicator
                Container(
                  width: 100,
                  height: 100,
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
                      percent: percent.clamp(
                          0.0, 1.0), // Ensures percent is within 0-1 range
                      center: Text(
                        "${(percent * 100).toStringAsFixed(1)}%", // Display as percentage
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 233, 215),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 24, color: Colors.black),
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
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 133, 37),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Score Zone',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Click on the weeks to check your scores',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 120, // Keep the height for the card fixed
                          width: 120, // Keep the width for the card fixed
                          decoration: BoxDecoration(
                            color:
                                Colors.white, // White color for the inner card
                            borderRadius: BorderRadius.circular(
                                15), // Circular boundaries for the white card
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/scoreisl.png',
                              width: 300, // Increase the image size
                              height: 300, // Increase the image size
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (score_challenger != null || score_challenger_week3!=null)
                              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Score Board...",style: TextStyle(fontSize: 18 ,color: const Color.fromARGB(255, 113, 113, 113),fontWeight: FontWeight.bold),),
              ),

              if (score_challenger != null)
                _buildCard(
                  onTap: () => _handleCardTap(2, const DetailedProgressWeek1()),
                  color: Colors.white,
                  title: 'Week 1',
                  description:
                      'Click me ! To see the detailed score of week 1',
                  index: 2,
                  score: int.parse(score_challenger!),
                ),
              if (score_challenger_week3 != null)
                _buildCard(
                  onTap: () => _handleCardTap(1, const DetailedProgressWeek3()),
                  color: Colors.white,
                  title: 'Week 3',
                  description:
                  'Click me ! To see the detailed score of week 3',
                  index: 1,
                  score: int.parse(score_challenger_week3!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
