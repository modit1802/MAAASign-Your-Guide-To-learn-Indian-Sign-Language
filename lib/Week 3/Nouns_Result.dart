// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:io';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%203/play_incorrect_noun.dart';
import 'package:SignEase/Week%202/review_incorrect_videos.dart';
import 'package:SignEase/Week%203/noun_quiz.dart';
import 'package:SignEase/Week%203/week3_entry.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;

class Quiz_Noun_ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int correctcount;
  final int incorrectcount;
  final List<Map<String, dynamic>> incorrectQuestions;

  const Quiz_Noun_ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.incorrectQuestions,
    required this.correctcount,
    required this.incorrectcount,
  }) : super(key: key);

  @override
  State<Quiz_Noun_ResultScreen> createState() =>
      _Quiz_Noun_ResultScreenState();
}

class _Quiz_Noun_ResultScreenState
    extends State<Quiz_Noun_ResultScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? userId;
  @override
  void initState() {
    super.initState();
    connectToMongoDB();
    print("Correct count: ${widget.correctcount}");
    print("Incorrect count: ${widget.incorrectcount}");
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

  Future<void> saveResultToMongoDB() async {
    // Get the user ID from Firebase
    String? userId = await getUserId();
    if (userId != null) {
      // Check if user already exists in the collection
      var userDoc = await userCollection.findOne(mongo.where.eq('userId', userId));

      // Define the week key
      String weekKey = 'week3';

      if (userDoc == null) {
        // If user doesn't exist, insert new document with only Score_noun
        await userCollection.insert({
          'userId': userId,
          'week': {
            weekKey: {
              'Score_noun': {
                'score_noun': widget.score,
                'incorrectQuestions_noun': widget.incorrectQuestions,
                'incorrectcount1':widget.incorrectcount,
              }
            }
          }
        });
      } else {
        // If user exists, add or update only the Score_noun field inside week1
        await userCollection.update(
          mongo.where.eq('userId', userId),
          mongo.modify.set('week.$weekKey.Score_noun', {
            'score_noun': widget.score,
            'incorrectQuestions_noun': widget.incorrectQuestions,
          }),
        );
      }

      print("Data inserted/updated for user ID: $userId, week key: $weekKey");
    }
  }

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }


  Future<void> _shareScore() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot.png';

      // Save the image to the file system
      File(imagePath).writeAsBytesSync(image);

      // Share the screenshot file using shareXFiles
      await Share.shareXFiles([XFile(imagePath)],
          text: 'Check out my score: ${widget.score} points!');
    }
  }

  Future<void> _generateAndSharePDF() async {
    final pdf = pw.Document();

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text("Quiz Result",
                style:
                pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Score: ${widget.score} points",
                style: const pw.TextStyle(fontSize: 18)),
            pw.Text("Total Questions: ${widget.totalQuestions}",
                style: const pw.TextStyle(fontSize: 18)),
            pw.Text("Correct Answers: ${widget.correctcount}",
                style: const pw.TextStyle(fontSize: 18)),
            pw.Text("Incorrect Answers: ${widget.incorrectcount}",
                style: const pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final pdfFile = File("${output.path}/result.pdf");
    await pdfFile.writeAsBytes(await pdf.save());

    // Share the PDF
    await Share.shareXFiles([XFile(pdfFile.path)],
        text: 'Check out my quiz result!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 252, 133, 37),
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 176, 111),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 249, 147, 63),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Score",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${widget.score}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 183, 83, 2),
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
                Transform.translate(
                  offset: const Offset(0, -130),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 450,
                      height: 250,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildStatItem("100%", "Completion",
                                    const Color.fromARGB(255, 247, 136, 44)),
                                _buildStatItem(
                                    "${widget.totalQuestions}",
                                    "Total Questions",
                                    const Color.fromARGB(255, 247, 136, 44)),
                                _buildStatItem("${widget.correctcount}",
                                    "Correct", Colors.green),
                                _buildStatItem("${widget.incorrectcount}",
                                    "Wrong", Colors.red),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -180),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewIncorrectSolution(
                                          incorrectQuestions:
                                          widget.incorrectQuestions,
                                        )));
                          },
                          child: _buildCircularButton(Icons.visibility,
                              "Review Mistakes", Colors.brown),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PLay_Incorrect_Nouns(
                                          incorrectQuestions:
                                          widget.incorrectQuestions,
                                          score1: widget.score,
                                        )));
                          },
                          child: _buildCircularButton(Icons.assessment_outlined,
                              "Retry Mistakes", Colors.grey),
                        ),
                        GestureDetector(
                          onTap: _shareScore,
                          child: _buildCircularButton(
                              Icons.share, "Share Score", Colors.blue),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NounQuiz()));
                            },
                            child: _buildCircularButton(
                                Icons.refresh, "Play Again", Colors.teal)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Week3Entry()));
                          },
                          child: _buildCircularButton(
                              Icons.arrow_back, "Week 3", Colors.pink),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InitialPage1()));
                          },
                          child: _buildCircularButton(
                              Icons.home, "Home", Colors.purple),
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
    );
  }

  Widget _buildCircularButton(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 25,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget _buildStatItem(String value, String label, Color color) {
  return Row(
    children: [
      const SizedBox(width: 6),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ],
  );
}
