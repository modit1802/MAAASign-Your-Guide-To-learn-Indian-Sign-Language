import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Colors.transparent,
        ),
      ),
      home: const LearnAlphabet(),
    );
  }
}

class LearnAlphabet extends StatefulWidget {
  const LearnAlphabet({super.key});

  @override
  _LearnAlphabetState createState() => _LearnAlphabetState();
}

class _LearnAlphabetState extends State<LearnAlphabet> {// Initialize Firestore

  @override
  void initState() {
    super.initState();
    _storePoints();
  }

  Future<void> _storePoints() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        String uid = user.uid; // Get the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'learnalphabet': 20, // Store the score
          'timestamp': FieldValue.serverTimestamp(), // Store the current time
        }, SetOptions(merge: true)); // Merge with existing data if present
        print("Score saved to Firestore for user ID: $uid");
      }
    } catch (e) {
      print("Error saving score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text("Alphabets",
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: const Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  AlphabetLearn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlphabetLearn extends StatefulWidget {
  const AlphabetLearn({super.key});

  @override
  State<AlphabetLearn> createState() => _AlphabetLearnState();
}

class _AlphabetLearnState extends State<AlphabetLearn> with SingleTickerProviderStateMixin {
  List<String> alphabetImages = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z'
  ];

  // Map to store Cloudinary URLs for each alphabet (PNG and GIF)
  final Map<String, String> alphabetGifs = <String, String>{
    'A': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462628/A.gif',
    'B': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462629/B.gif',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462532/C.gif',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462636/D.gif',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462667/E.gif',
    'F': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462679/F.gif',
    'G': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462662/G.gif',
    'H': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462529/H.gif',
    'I': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462650/I.gif',
    'J': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462530/J.gif',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462524/K.gif',
    'L': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462524/L.gif',
    'M': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462526/M.gif',
    'N': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462524/N.gif',
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462525/O.gif',
    'P': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462525/P.gif',
    'Q': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462636/Q.gif',
    'R': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462526/R.gif',
    'S': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462647/S.gif',
    'T': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462642/T.gif',
    'U': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462624/U.gif',
    'V': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462625/V.gif',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462625/W.gif',
    'X': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462626/X.gif',
    'Y': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462625/Y.gif',
    'Z': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728462628/Z.gif',
  };

final Map<String, String> alphabetPngs = {
    'A': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/A-labelled_sed7ad.png',
    'B': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/B-labelled_jppjzn.png',
    'C': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/C-labelled_h4kxsi.png',
    'D': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/D-labelled_sbsek7.png',
    'E': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/E-labelled_bovjls.png',
    'F': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/F-labelled_kxce14.png',
    'G': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/G-labelled_oxmqrx.png',
    'H': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/H-labelled_lbiwjc.png',
    'I': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/I-labelled_p4zjxd.png',
    'J': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/J-labelled_k4o6y3.png',
    'K': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/K-labelled_ti6ypj.png',
    'L': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/L-labelled_vuydr9.png',
    'M': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/M-labelled_bsovuc.png',
    'N': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/N-labelled_p8wypu.png',
    'O': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/O-labelled_lhvsun.png',
    'P': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/P-labelled_fzfe3d.png',
    'Q': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/Q-labelled_gvyepx.png',
    'R': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/R-labelled_fxi6de.png',
    'S': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/S-labelled_fjph3z.png',
    'T': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-labelled_blzhjl.png',
    'U': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-labelled_blgp2r.png',
    'V': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-labelled_rndws0.png',
    'W': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-labelled_lpl5ga.png',
    'X': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-labelled_bk8rem.png',
    'Y': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/Y-labelled_najbm5.png',
    'Z': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Z-labelled_g2fqxi.png',
  };

  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Add any scroll-specific functionality here
  }

  Future<Widget> _loadGif(String url) async {
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, 50 * (1 - _animation.value)),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: alphabetImages.map((imageName) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              children: [
                                // Display GIF
                                Card(
                                  elevation: 6.0,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: Image.network(
                                                alphabetGifs[imageName]!,
                                                loadingBuilder: (context, child, loadingProgress) {
                                               if (loadingProgress == null) {
                                                      return child;
                                                } else {
                                                      return const Center(
                                                          child: CircularProgressIndicator(),
                                      );
                        }
                      },
                                        ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                // Display PNG of the same size
                                Card(
                                  elevation: 6.0,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: Image.network(
                                        alphabetPngs[imageName]!,
                                        
                                        loadingBuilder: (context, child, loadingProgress) {
                                               if (loadingProgress == null) {
                                                      return child;
                                                } else {
                                                      return const Center(
                                                          child: CircularProgressIndicator(),
                                      );
                        }
                      },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
