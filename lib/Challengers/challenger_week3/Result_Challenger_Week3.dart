import 'package:SignEase/Challengers/challenger_week3/DetailedProgressWeek3.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/week3_start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:percent_indicator/percent_indicator.dart';

class Result_Challenger_Week3 extends StatefulWidget {
  final int score;
  final List<Map<String, dynamic>> incorrectquestions;
  const Result_Challenger_Week3({Key?key, required this.score, required this.incorrectquestions}): super(key: key);


  @override
  State<Result_Challenger_Week3> createState() =>
      _Result_Challenger_Week3State();
}

class _Result_Challenger_Week3State extends State<Result_Challenger_Week3> {
  int? _selectedCardIndex;
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  late int score;
  late List<Map<String,dynamic>> incorrect;

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
    score = widget.score;
    incorrect=widget.incorrectquestions;
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
    try {
      await db.open();
      userCollection = db.collection('users');
      await saveResultToMongoDB();
      print("Connected to MongoDB and result saved!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

    Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> saveResultToMongoDB() async {
  // Get the user ID from Firebase
  String? userId = await getUserId();
  if (userId != null) {
    // Check if user already exists in the collection
    var userDoc = await userCollection.findOne(mongo.where.eq('userId', userId));

    // Define the week key
    String weekKey = 'week3';

    if (userDoc == null) {
      // If user doesn't exist, insert new document with only Score_number
      await userCollection.insert({
        'userId': userId,
        'week': {
          weekKey: {
            'Score_Challenger_week3': {
              'score_challenger': widget.score,
              'Incorrect_challenges':widget.incorrectquestions,
            }
          }
        }
      });
    } else {
      // If user exists, add or update only the Score_number field inside Week3
      await userCollection.update(
        mongo.where.eq('userId', userId),
        mongo.modify.set('week.$weekKey.Score_Challenger_Week3', {
          'score_challenger': widget.score,
          'Incorrect_challenges':widget.incorrectquestions,
        }),
      );
    }

    print("Data inserted/updated for user ID: $userId, week key: $weekKey");
  }
}

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData iconData,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: SizedBox(
            height: 110,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: const Color.fromARGB(255, 252, 133, 37),
                    child: Center(
                      child: Icon(
                        iconData,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 12), // Reduced spacing between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.justify,
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
            _selectedCardIndex = null; // Reset after navigation
          }));
    });
  }

 @override
Widget build(BuildContext context) {
  // Calculate the percentage based on the score and total of 1000
  double percentage = (score / 1000).clamp(0.0, 1.0); // Ensure it's between 0.0 and 1.0
  String percentageText = "${(percentage * 100).toStringAsFixed(1)}%"; // Format to one decimal place

  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 250, 233, 215),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 20.0,
              animation: true,
              percent: percentage, // Use calculated percentage
              center: Text(
                percentageText, // Display percentage text
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Color.fromARGB(255, 189, 74, 2),
            ),
            const SizedBox(height:10),
            Text(
              "Score based on Week 3 Challenger Performance", // Footer text
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height:10),
            _buildCard(
              onTap: () => _handleCardTap(
                0,
                widget.score > 600
                    ? const InitialPage1()
                    : Week3(), // Navigate based on score
              ),
              iconData: Icons.festival,
              color: const Color.fromARGB(255, 255, 255, 255),
              title: widget.score > 600
                  ? "Go to Week 4"
                  : "Practice again Week 3",
              description: widget.score > 600
                  ? "Congratulations! You have completed week 3, now it's time to jump to week 4. Press me to directly go to week 4."
                  : "Based on your performance in week 3, we recommend you to practice again. Press me to restart week 3.",
              index: 0,
            ),
            const SizedBox(height: 8), // Added to adjust the space between cards
            _buildCard(
              onTap: () => _handleCardTap(1, const DetailedProgressWeek3()),
              iconData: Icons.report,
              color: const Color.fromARGB(255, 255, 255, 255),
              title: 'Week 3 Progress Report',
              description: "Click me! to check the detailed progress report of week 3",
              index: 1,
            ),
          ],
        ),
      ),
    ),
  );
}

}
