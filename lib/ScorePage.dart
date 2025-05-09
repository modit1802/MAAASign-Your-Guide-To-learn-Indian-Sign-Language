import 'dart:io';
import 'dart:typed_data';
import 'package:SignEase/Challengers_All_Weeks/challenger_week1/DetailedProgressWeek1.dart';
import 'package:SignEase/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week3/DetailedProgressWeek3.dart';
import 'package:SignEase/Challengers_All_Weeks/challenger_week2/DetailedProgressWeek2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUsername();
    connectToMongoDB();
  }

  Future<void> calculateAndStoreAverage() async {
  String? userId = await getUserId();
  if (userId == null) {
    print("User not logged in");
    return;
  }

  // Convert scores to integers, handle nulls
  int score1 = int.tryParse(score_challenger ?? '0') ?? 0;
  int score2 = int.tryParse(score_challenger_week2 ?? '0') ?? 0;
  int score3 = int.tryParse(score_challenger_week3 ?? '0') ?? 0;
  int score4 = int.tryParse(score_challenger_week4 ?? '0') ?? 0;

  // Calculate average
  int total = score1 + score2 + score3 + score4;
  double avgScore = total / 4;

  print("Average Score: $avgScore");

  try {
    // Re-open DB if closed
    if (!db.isConnected) await db.open();

    // Update the user's document
    await userCollection.update(
      mongo.where.eq('userId', userId),
      mongo.modify.set('Avg_score', avgScore),
    );

    print("Average score updated successfully in MongoDB!");
  } catch (e) {
    print("Error updating average score: $e");
  }
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

final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _captureAndShare() async {
    try {
      // Ensure that the screenshot is captured only after the frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final Uint8List? imageBytes = await _screenshotController.capture();
        if (imageBytes == null) {
          print("Error: Screenshot capture failed.");
          return;
        }

        print("Screenshot captured successfully.");

        // Get the temporary directory to save the file
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/screenshot.png';

        // Save the image bytes to the file
        final file = File(imagePath);
        await file.writeAsBytes(imageBytes);

        // Ensure the file exists before sharing
        if (await file.exists()) {
          print("File saved at: $imagePath");

          // Share the screenshot using share_plus
          await Share.shareXFiles([XFile(imagePath)], text: 'Check out my score!');
        } else {
          print("Error: Screenshot file does not exist.");
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }



  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
    try {
      await db.open();
      userCollection = db.collection('users');
      await fetchResultsFromMongoDB();
      print("Connected to MongoDB and results fetched!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
        score_challenger_week4=result['week']?['Week4']?['Score_Challenger_Week4']
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
    await calculateAndStoreAverage();
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
    body: isLoading
          ? Center(child: CircularProgressIndicator(color:const Color.fromARGB(255, 238, 126, 34)))
          :Screenshot(
        controller: _screenshotController,
            child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,  // 4% padding from left and right
            vertical: screenHeight * 0.02,   // 2% padding from top and bottom
                    ),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Text
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

              SizedBox(height: screenHeight * 0.02), // Responsive spacing
            
              // Score Zone Container
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
                                    'Score Zone',
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
                                      'Checkout your detailed scores!',
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
                                    'images/challenger_girl.jpeg',
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

              SizedBox(height: screenHeight * 0.02), // Responsive spacing
            
              // Score Board Section
              if (score_challenger != null || score_challenger_week3 != null || score_challenger_week2 != null || score_challenger_week4 != null)
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Score Board",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02, // Responsive font size
                          color: Color.fromARGB(255, 238, 126, 34),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
            icon: Icon(
              Icons.share,
              color: Color.fromARGB(255, 238, 126, 34),
            ),
            onPressed: _captureAndShare,
            tooltip: 'Refresh Scores',
                    ),
                      Transform.translate(
                        offset: Offset(screenWidth*0.08, 0),
                        child: Text(
                                      "Refresh",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 238, 126, 34),
                                      ),
                                    ),
                      ),
                      IconButton(
            icon: Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 238, 126, 34),
            ),
            onPressed: () async {
              await connectToMongoDB(); // Refresh scores
            },
            tooltip: 'Refresh Scores',
                    ),
                    
                    ],
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
                  onTap: () => _handleCardTap(4, const DetailedProgressWeek4()),
                  color: Colors.white,
                  title: 'Week 4',
                  description:
                  'See the detailed score!',
                  index: 4,
                  score: int.parse(score_challenger_week4!),
                ),
              ],
            ),
                    ),
                  ),
          ),
    );
  }
}
