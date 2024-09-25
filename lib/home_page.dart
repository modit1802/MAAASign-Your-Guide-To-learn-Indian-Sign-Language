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
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _showAnimation = false;
  User? _currentUser;
  String username = "";
  String score = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchScore();
    _currentUser = _auth.currentUser;
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void fetchScore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference scoreref =
          _database.ref().child('score').child(user.uid).child('score');
      DatabaseEvent event = await scoreref.once();
      setState(() {
        score = event.snapshot.value.toString();
      });
    }
    else{
      setState(() {
        score="?";
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
                                        "Home",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                221, 255, 255, 255),
                                            fontSize: 40),
                                      ),
                                      Image.asset(
                                        'assets/hello.gif', // Adjust the path as per your project structure
                                        width: 150,
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: _currentUser != null
                                      ? Text(
                                          "Welcome back, $username! ,  $score", // Display user's display name if available
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  221, 234, 249, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      : const SizedBox(), // Handle case when _currentUser is null
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
                                    duration:
                                        const Duration(milliseconds: 1400),
                                    child: _buildGridDashboard(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Description',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
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

  // Widget to build the grid dashboard
  Widget _buildGridDashboard() {
    return GridDashboard();
  }
}

class GridDashboard extends StatelessWidget {
  final Items item1 = Items(
    title: "Level 1",
    subtitle: "Learn ISL",
    event: "",
    img: "images/calendar.png",
  );

  final Items item2 = Items(
    title: "Level 2",
    subtitle: "Learn ISL",
    event: "",
    img: "images/food.png",
  );
  final Items item3 = Items(
    title: "Level 3",
    subtitle: "Learn ISL",
    event: "",
    img: "images/map.png",
  );
  final Items item4 = Items(
    title: "Level 4",
    subtitle: "Learn ISL",
    event: "",
    img: "images/festival.png",
  );
  final Items item5 = Items(
    title: "Level 5",
    subtitle: "Learn ISL",
    event: "",
    img: "images/todo.png",
  );
  final Items item6 = Items(
    title: "Level 6",
    subtitle: "Learn ISL",
    event: "",
    img: "images/setting.png",
  );

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = const Color(0xFFE6E6E6); // Light gray color for glassy effect
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: myList.map((data) {
        return GestureDetector(
          onTap: () {
            if (data.title == "Level 1") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewScreen()));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: color
                  .withOpacity(0.9), // Adjust opacity for transparency effect
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white
                      .withOpacity(0.3), // Adjust shadow color and transparency
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
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
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data.event,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
  late String title;
  late String subtitle;
  late String event;
  late String img;

  Items({
    required this.title,
    required this.subtitle,
    required this.event,
    required this.img,
  });
}
