import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Initial_page_1.dart'; // Replace with your actual homepage file path
import 'signup_page.dart'; // Replace with your actual signup page file path

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isPasswordVisible = false;
  bool _isSigningIn = false;
  bool _showAnimation = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Add listeners for focus changes
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Login with email and password
  // Login with email and password
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

      // Successful login - navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialPage1()),
      );
    } catch (e) {
      print('Login Error: $e');

      showDialog(
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
    } finally {
      // Ensure to hide the animation once done
      setState(() {
        _isSigningIn = false;
        _showAnimation = false;
      });
    }
  }

// Login with Google
  void _googleLogin() async {
    setState(() {
      _isSigningIn = true;
      _showAnimation = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isSigningIn = false;
          _showAnimation = false;
        });
        return; // User canceled the login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
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

  // Navigate to Signup Page
  void _goToSignupPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('images/Maleisl.png', height: 250),
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
          
                    // Email TextField
                    // Email TextField
                    TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      style: TextStyle(
                        color: _isEmailFocused
                            ? const Color.fromARGB(255, 252, 133, 37)
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: _isEmailFocused
                              ? const Color.fromARGB(255, 252, 133, 37)
                              : Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 252, 133, 37),
                            width:
                                2.0, // Optional: Increase width for a clearer effect
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black, // Black when not focused
                          ),
                        ),
                      ),
                      cursorColor: const Color.fromARGB(255, 252, 133, 37),
                    ),
                    const SizedBox(height: 16),
          
          // Password TextField
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                        color: _isPasswordFocused
                            ? const Color.fromARGB(255, 252, 133, 37)
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 69, 69, 69),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle password visibility
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          color: _isPasswordFocused
                              ? const Color.fromARGB(255, 252, 133, 37)
                              : Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 252, 133, 37),
                            width:
                                2.0, // Optional: Increase width for a clearer effect
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.black, // Black when not focused
                          ),
                        ),
                      ),
                      cursorColor: const Color.fromARGB(255, 252, 133, 37),
                    ),
          
                    const SizedBox(height: 10),
          
                    // Remember me and Forgot password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                              activeColor: const Color.fromARGB(255, 252, 133, 37),
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Add forgot password logic here
                          },
                          child: const Text(
                            'Forgot Password?',
                            style:
                                TextStyle(color: Color.fromARGB(255, 252, 133, 37)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
          
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color.fromARGB(255, 252, 133, 37),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
          
                    // Google login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _googleLogin, // You can use the same login function
                        icon: Image.asset('images/google_icon.png', height: 24),
                        label: const Text(
                          'Login with Google',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 252, 133, 37)), // Set the text color
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor:
                              Colors.white, // Set the button background color
                          foregroundColor: Color.fromARGB(
                              255, 252, 133, 37), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: const BorderSide(
                                color: Color.fromARGB(
                                    255, 255, 255, 255)), // Optional: border color
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
          
                    // Sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: _goToSignupPage,
                          child: const Text(
                            'Sign Up',
                            style:
                                TextStyle(color: Color.fromARGB(255, 252, 133, 37)),
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          if (_showAnimation)
                  Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
