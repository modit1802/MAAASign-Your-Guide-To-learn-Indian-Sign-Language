import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_signup/newscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_login_signup/login_page.dart'; // Assuming this is the file for LoginPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _showAnimation = false;
  User? _currentUser;
  String username = "";
  int scoreAlpha = 0;
  int scoreNumber = 0;

  @override
  void initState() {
    super.initState();
    _fetchScoreFromFirebase();
    fetchUserName();
    _currentUser = _auth.currentUser;
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

  void _logout() async {
    setState(() {
      _showAnimation = true;
    });

    try {
      await _auth.signOut();
      Timer(const Duration(seconds: 5), () {
        setState(() {
          _showAnimation = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    } catch (e) {
      print('Logout Error: $e');
      setState(() {
        _showAnimation = false;
      });
    }
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        username = userDoc['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(), // Background gradient
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Challenge Zone",
                                        style: TextStyle(
                                            color: Color.fromARGB(221, 255, 255, 255),
                                            fontSize: 40),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _currentUser != null
                                        ? Text(
                                            " $username  Test your knowledge by clicking on Week number", // Display user's display name if available
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 231, 240, 255),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        : const SizedBox(),
                                  ), // Handle case when _currentUser is null
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 60),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 1400),
                                    child: GridDashboard(scoreAlpha: scoreAlpha, scoreNumber: scoreNumber),
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
              ],
            ),
          ),
          if (_showAnimation) _buildLoadingOverlay(), // Show loading overlay
        ],
      ),
    );
  }

  // Widget to build the background gradient
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 219, 69, 249),
            Color.fromARGB(255, 135, 205, 238),
          ],
        ),
      ),
    );
  }

  // Widget to build the Lottie animation overlay
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Lottie.asset(
          'assets/loading.json', // Replace with your Lottie animation file
          width: 200, // Adjust the width as per your requirement
          height: 200, // Adjust the height as per your requirement
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class GridDashboard extends StatelessWidget {
  final int scoreAlpha;
  final int scoreNumber;

   GridDashboard({Key? key, required this.scoreAlpha, required this.scoreNumber}) : super(key: key);

  final Items item1 = Items(
    title: "Week 1",
    subtitle: "Learn Alphabets and Numbers in Indian Sign language",
    event: "",
    img: "images/calendar.png",
  );

  final Items item2 = Items(
    title: "Week 2",
    subtitle: "Learn Greetings and etiquettes in Indian Sign language",
    event: "",
    img: "images/food.png",
  );

  final Items item3 = Items(
    title: "Week 3",
    subtitle: "Learn Parents' names and emotions in Indian Sign language",
    event: "",
    img: "images/map.png",
  );

  final Items item4 = Items(
    title: "Week 4",
    subtitle: "Learn colors and animal names in Indian Sign language",
    event: "",
    img: "images/festival.png",
  );

  final Items item5 = Items(
    title: "Week 5",
    subtitle: "Learn bird names and sentence joiners in Indian Sign language",
    event: "",
    img: "images/todo.png",
  );

  final Items item6 = Items(
    title: "Week 6",
    subtitle: "Learn a mix of all weeks in Indian Sign language",
    event: "",
    img: "images/setting.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var defaultColor = const Color(0xFFE6E6E6); // Light gray color for glassy effect
    var selectedColor = Colors.green; // Green color when condition is met
    var textColor = Colors.white; // White text color when condition is met

    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: myList.map((data) {
        bool isWeek1Selected = (data.title == "Week 1") && (scoreAlpha + scoreNumber > 1200);

        return GestureDetector(
          onTap: () {
            if (data.title == "Week 1") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isWeek1Selected
                  ? selectedColor.withOpacity(0.9)
                  : defaultColor.withOpacity(0.9), // Adjust opacity for transparency effect
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3), // Adjust shadow color and transparency
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(data.img, width: 42),
                const SizedBox(height: 14),
                Text(
                  data.title,
                  style: TextStyle(
                    color: isWeek1Selected ? textColor : Colors.black, // Change to white when selected
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding for the subtitle
                  child: Text(
                    data.subtitle,
                    textAlign: TextAlign.center, // Center align the subtitle
                    style: TextStyle(
                      color: isWeek1Selected ? textColor : Colors.black, // Change to white when selected
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class Items {
  final String title;
  final String subtitle;
  final String event;
  final String img;

  Items({required this.title, required this.subtitle, required this.event, required this.img});
}



