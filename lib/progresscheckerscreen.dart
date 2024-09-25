import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressCheckerScreen extends StatefulWidget {
  const ProgressCheckerScreen({super.key});

  @override
  State<ProgressCheckerScreen> createState() => _ProgressCheckerScreenState();
}

class _ProgressCheckerScreenState extends State<ProgressCheckerScreen> {
  int scoreAlpha = 0; // To store 'scorealpha'
  int scoreNumber = 0; // To store 'scorenumber'

  @override
  void initState() {
    super.initState();
    _fetchScoreFromFirebase(); // Fetch scores when the widget initializes
  }

  Future<void> _fetchScoreFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        String uid = user.uid; // Get the user's UID
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get(); // Fetch user's document

        if (snapshot.exists) {
          setState(() {
            scoreAlpha = snapshot.get('scorealpha') ?? 0; // Fetch scorealpha, default to 0 if null
            scoreNumber = snapshot.get('scorenumber') ?? 0; // Fetch scorenumber, default to 0 if null
          });
          print("Scores fetched: scorealpha = $scoreAlpha, scorenumber = $scoreNumber");
        } else {
          print("No document found for user.");
        }
      }
    } catch (e) {
      print("Error fetching scores: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Report"),
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
                  Colors.white,
                ],
              ),
            ),
          ),
          // Background image (ribbon.gif)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/ribbon2.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align to start
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Week 1 Scores based upon performance",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 90, 121)),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4, // Adds shadow to the card
                  margin: const EdgeInsets.symmetric(horizontal: 16), // Margins for the card
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: BarChart(
                          BarChartData(
                            titlesData: const FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [
                                BarChartRodData(
                                    toY: scoreAlpha.toDouble(),
                                    color: Colors.blue,
                                    width: 30),
                              ]),
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                    toY: scoreNumber.toDouble(),
                                    color: Colors.red,
                                    width: 30),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Alphabets Score",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Numbers Score",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
