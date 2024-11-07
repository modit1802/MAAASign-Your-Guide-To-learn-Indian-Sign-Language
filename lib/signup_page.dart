import 'dart:async';
import 'dart:io';
import 'package:SignEase/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Initial_page_1.dart'; // Replace with your actual homepage file path
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isObscure = true;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isSigningUp = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _showAnimation = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final String _defaultPhotoUrl = 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730905633/person.256x242_h6w7hk.png';
  final FocusNode _nameFocusNode = FocusNode();
    final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isnameFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _nameFocusNode.addListener(() {
      setState(() {
        _isnameFocused = _nameFocusNode.hasFocus;
      });
    });

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


  Future<String> _uploadProfileImage(File imageFile) async {
    try {
      String fileName = '${_auth.currentUser!.uid}.jpg';
      Reference storageReference = _storage.ref().child('profile_pictures/$fileName');
print('Starting image upload...');
UploadTask uploadTask = storageReference.putFile(imageFile);
TaskSnapshot taskSnapshot = await uploadTask;
print('Upload complete, getting download URL...');
String downloadUrl = await taskSnapshot.ref.getDownloadURL();
print('Download URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('Image upload error: $e');
      return _defaultPhotoUrl;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  Future<void> _signup() async {
    setState(() {
      _isSigningUp = true;
      _showAnimation = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String photoUrl = _defaultPhotoUrl;
      if (_selectedImage != null) {
        photoUrl = await _uploadProfileImage(_selectedImage!);
      }

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'photoUrl': photoUrl,
      });


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialPage1()),
      );
    } catch (e) {
      print('Signup Error: $e');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Signup Failed'),
          content: const Text('Please check your information and try again.'),
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
        _isSigningUp = false;
        _showAnimation = false;
      });
    }
  }

  void _googleSignup() async {
    setState(() {
      _isSigningUp = true;
      _showAnimation = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isSigningUp = false;
          _showAnimation = false;
        });
        return; // User canceled the signup
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      String userName = googleUser.displayName ?? "User";
      String userEmail = googleUser.email;

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': userName,
        'email': userEmail,
        'photoUrl': googleUser.photoUrl,
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialPage1()),
      );
    } catch (e) {
      print('Google Signup Error: $e');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Signup Failed'),
          content: const Text('Failed to sign up with Google.'),
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
        _isSigningUp = false;
        _showAnimation = false;
      });
    }
  }

    Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : NetworkImage(_defaultPhotoUrl) as ImageProvider,
                        child: _selectedImage == null
                            ? const Icon(Icons.add_a_photo, size: 30,color: Color.fromARGB(255, 252, 133, 37))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      style: TextStyle(
                        color: _isnameFocused
                            ? const Color.fromARGB(255, 183, 83, 2)
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: _isnameFocused
                              ? const Color.fromARGB(255, 183, 83, 2)
                              : Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 183, 83, 2),
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
                      cursorColor: const Color.fromARGB(255, 183, 83, 2),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      style: TextStyle(
                        color: _isEmailFocused
                            ? const Color.fromARGB(255, 183, 83, 2)
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: _isEmailFocused
                              ? const Color.fromARGB(255, 183, 83, 2)
                              : Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 183, 83, 2),
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
                      cursorColor: const Color.fromARGB(255, 183, 83, 2),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      focusNode: _passwordFocusNode,
                      style: TextStyle(
                        color: _isPasswordFocused
                            ? const Color.fromARGB(255, 183, 83, 2)
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 69, 69, 69),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure =
                                  !_isObscure; // Toggle password visibility
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          color: _isPasswordFocused
                              ? const Color.fromARGB(255, 183, 83, 2)
                              : Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 183, 83, 2),
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
                      cursorColor: const Color.fromARGB(255, 183, 83, 2),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 252, 133, 37),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            // Optional: border color
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _googleSignup,
                        icon: Image.asset('images/google_icon.png', height: 24),
                        label: const Text(
                          'Sign Up with Google',
                          style: TextStyle(color: Color.fromARGB(255, 252, 133, 37)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                             // Optional: border color
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Color.fromARGB(255, 252, 133, 37)),
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
