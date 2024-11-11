import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'initial_page_1.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the SpinKit package

class Sabse_Jyada_Main_page extends StatefulWidget {
  const Sabse_Jyada_Main_page({super.key});

  @override
  State<Sabse_Jyada_Main_page> createState() => _Sabse_Jyada_Main_pageState();
}

class _Sabse_Jyada_Main_pageState extends State<Sabse_Jyada_Main_page> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSigningIn = false;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 250, 233, 215),
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _googleLogin() async {
    setState(() {
      _isSigningIn = true;
      _showAnimation = true;
    });

    // Simulate a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2)); // Simulate a 4 seconds delay

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isSigningIn = false;
          _showAnimation = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      String userName = googleUser.displayName ?? "User";
      String userEmail = googleUser.email;

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': userName,
        'email': userEmail,
        'photoUrl': googleUser.photoUrl,
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialPage1()),
      );

    } catch (e) {
      print('Google Login Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Failed to sign in with Google.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
        _showAnimation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/femaleteacherisl.png',
                      width: width * 0.8,
                      height: width * 0.8,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: Text(
                        'Welcome to Interactive Indian Sign Language Learning app. Explore the new way of learning sign language with interactive games and quizzes.',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          height: height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 252, 133, 37),
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(fontSize: width * 0.045),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width * 0.7,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            child: const Text('Signup'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 252, 133, 37),
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(fontSize: width * 0.045),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'or continue with',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(width * 0.02),
                      child: IconButton(
                        onPressed: _googleLogin,
                        icon: Image.asset(
                          'images/google_icon.png',
                          width: 44,
                          height: 44,
                        ),
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading animation overlay
          if (_showAnimation) 
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 80.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
