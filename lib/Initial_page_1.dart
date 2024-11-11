import 'package:SignEase/Learning_zone.dart';
import 'package:SignEase/ScorePage.dart';
import 'package:SignEase/about_page.dart';
import 'package:SignEase/sabse_jyada_main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SignEase/challenge_page.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InitialPage1 extends StatefulWidget {
  final int index;

  const InitialPage1({Key? key, this.index = 0}) : super(key: key);

  @override
  State<InitialPage1> createState() => _InitialPage1State();
}

class _InitialPage1State extends State<InitialPage1> {
  late int _currentIndex;
  late PageController _pageController;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
    _fetchUserPhoto();
  }

  Future<void> _fetchUserPhoto() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          _photoUrl = userDoc['photoUrl'];
        });
      }
    } catch (e) {
      print('Error fetching user photo: $e');
    }
  }

  final List<Widget> _pages = [
    LearningZone(),
    ChallengePage(),
    ScorePage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<void> _logout() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      await Future.delayed(const Duration(seconds: 4));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Sabse_Jyada_Main_page()));
    } catch (e) {
      print('Logout error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Lottie.asset(
          'assets/loading.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows the dialog to close when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                radius: 40,
              ),
              SizedBox(height: 10),
              Text(
                'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog before logging out
                  _logout();
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        );
      },
    );
  }

  // This is the WillPopScope method
  Future<bool> _onWillPop() async {
    // You can show a confirmation dialog here, for example:
    return (await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Don't exit
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
                SystemNavigator.pop();  // Exit the app
            },
          ),
        ],
      ),
    )) ??
        false; // If the user does not press any button, default to false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Add this line to handle back button press
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SignEase'),
          backgroundColor: Color.fromARGB(255, 250, 233, 215),
          actions: <Widget>[
            if (_photoUrl != null)
              GestureDetector(
                onTap: _showProfileDialog,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_photoUrl!),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 165, 74, 17),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_photoUrl != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_photoUrl!),
                          radius: 60,
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 250, 233, 215),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _onItemTapped(index);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color.fromARGB(255, 165, 74, 17),
              unselectedItemColor: const Color.fromARGB(255, 145, 141, 141),
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fact_check),
                  label: 'Test',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.score),
                  label: 'Score',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'About',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
