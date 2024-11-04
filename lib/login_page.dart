import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/signup_page.dart'; // Import your SignupPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isObscure = true;
  bool _isSigningIn = false;
  bool _showAnimation = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _login() async {
    setState(() {
      _isSigningIn = true;
      _showAnimation = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Simulate a minimum loading time of 5 seconds using a Timer
      Timer(const Duration(seconds: 5), () {
        setState(() {
          _showAnimation = false;
        });
        // Navigate to home page or dashboard after successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InitialPage1()),

        );
      });
    } catch (e) {
      print('Login Error: $e');
      // Handle login error
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Please check your email and password.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        _isSigningIn = false;
        _showAnimation = false;
      });
    }
  }

 void _googleLogin() async {
  setState(() {
    _isSigningIn = true;
    _showAnimation = true;
  });

  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    // Check if the user has canceled the sign-in
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

    // Sign in to Firebase with the Google credentials
    await _auth.signInWithCredential(credential);
    
    // Now you can access user details from the googleUser object
    String userName = googleUser.displayName ?? "User";
    String userEmail = googleUser.email;
    
    // Optionally store user information in Firestore or local state management
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'name': userName,
      'email': userEmail,
      'photoUrl': googleUser.photoUrl, // Optional
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

    // Navigate to the home page after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InitialPage1()),
    );

  } catch (e) {
    print('Google Login Error: $e');
    // Handle login error
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


  void _goToSignupPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
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
          _buildBackground(),
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
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
                                "Login",
                                style: TextStyle(
                                    color: Color.fromARGB(221, 255, 255, 255),
                                    fontSize: 40),
                              ),
                              Image.asset(
                                'assets/hello.gif',
                                width: 150,
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: const Text(
                            "Welcome Back!!",
                            style: TextStyle(
                                color: Color.fromARGB(221, 248, 248, 248),
                                fontSize: 18),
                          ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(243, 207, 236, 0.973),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                                          hintText: "Email",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      obscureText: _isObscure,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                            child: Icon(
                                              _isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          hintText: "Password",
                                          hintStyle: const TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: _isSigningIn
                                ? const CircularProgressIndicator()
                                : MaterialButton(
                                    onPressed: _login,
                                    height: 50,
                                    color: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 30),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: GestureDetector(
                              onTap: _googleLogin, // Call Google login on tap
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.login, color: Colors.blueAccent),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Login with Google",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: GestureDetector(
                              onTap: _goToSignupPage,
                              child: const Text(
                                "Don't have an account? Sign up!",
                                style: TextStyle(
                                    color: Color.fromARGB(221, 2, 204, 251),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showAnimation)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Lottie.asset('assets/loading.json'), // Your Lottie animation
            ),
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
