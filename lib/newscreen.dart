import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/Initial_page_1.dart';
// import 'AlphabetScreen.dart';  // Import the alphabet screen
import 'numberstartscreen.dart';  // Import the number screen
import 'Quizscreen.dart';  // Import the quiz screen

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool showTeacherImage = true;

  double calculateCardSize() {
    // Calculate card size based on the visibility of the teacher image
    return showTeacherImage ? 150.0 : 250.0;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        showTeacherImage = false;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column for alphabet and number circle widgets
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      // Alphabet Circle widget
                      GestureDetector(
                        onTap: () {
                          // Navigate to the AlphabetScreen when the alphabet image is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Quiz_Screen()), // Correct way to navigate to Quiz_Screen
                          );

                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: calculateCardSize(),
                          width: calculateCardSize(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/alphabet.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Number Circle widget
                      GestureDetector(
                        onTap: () {
                          // Navigate to the NumberScreen when the number image is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NumberStartScreen()), // Change to your number screen
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: calculateCardSize(),
                          width: calculateCardSize(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/number.jpeg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  // Column for teacher2.gif image
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTeacherImage)
                        Image.asset(
                          'images/teacher2.gif',
                          height: 600,
                          width: 170,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Custom buttons at the top center (Home, Score, Test, About)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.score,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.info,
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
