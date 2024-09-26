import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/Initial_page_1.dart';
import 'Quizscreen';  // Make sure to import your QuizScreen here

class NewScreen extends StatefulWidget {
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
    // Hide the teacher image after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
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
          SingleChildScrollView( // Wrap content in SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()), // Define your quiz screen widget here
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center align the Row
                  children: [
                    // Column for alphabet and number circle widgets
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center align the Column
                      children: [
                        // Alphabet Circle widget
                        const SizedBox(height: 100), 
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500), // Animation duration
                          curve: Curves.easeInOut, // Animation curve
                          height: calculateCardSize(), // Adjust height based on visibility of teacher image
                          width: calculateCardSize(), // Adjust width based on visibility of teacher image
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                            child: Image.asset(
                              'images/alphabet.png', // Adjust the path to your image
                              fit: BoxFit.fill, // Ensure the image covers the entire card, possibly distorting its aspect ratio
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Spacer between alphabet and number circle widgets
                        // Number Circle widget
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500), // Animation duration
                          curve: Curves.easeInOut, // Animation curve
                          height: calculateCardSize(), // Adjust height based on visibility of teacher image
                          width: calculateCardSize(), // Adjust width based on visibility of teacher image
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                            child: Image.asset(
                              'images/number.jpeg', // Adjust the path to your image
                              fit: BoxFit.fill, // Ensure the image covers the entire card, possibly distorting its aspect ratio
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10), // Spacer between the columns
                    // Column for teacher2.gif image
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Conditional rendering of Teacher2.gif image
                        if (showTeacherImage)
                          Image.asset(
                            'images/teacher2.gif', // Adjust the path to your image
                            height: 600, // Adjust height as needed
                            width: 170, // Adjust width as needed
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom buttons at the top center (Home, Score, Test, About)
          Positioned(
            bottom: 20, // Adjust for padding from the top
            left: 0, // Set left to 0 to utilize full width
            right: 0, // Set right to 0 to utilize full width
            child: Center( // Wrap in Center widget
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center align the Row
                children: [
                  // Home Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()), // Navigate to InitialPage1 when tapped
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10), // Add padding inside the container
                      decoration: const BoxDecoration(
                        color: Colors.white, // Background color for the circular button
                        shape: BoxShape.circle, // Make it circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Add shadow for better visibility
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home, // Home icon
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160), // Icon color
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Spacer between home button and score button

                  // Score Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()), // Navigate to HomePage when tapped
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10), // Add padding inside the container
                      decoration: const BoxDecoration(
                        color: Colors.white, // Background color for the circular button
                        shape: BoxShape.circle, // Make it circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Add shadow for better visibility
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.score, // Score icon
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160), // Icon color
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Spacer between score button and test button

                  // Test Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()), // Navigate to HomePage when tapped
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10), // Add padding inside the container
                      decoration: const BoxDecoration(
                        color: Colors.white, // Background color for the circular button
                        shape: BoxShape.circle, // Make it circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Add shadow for better visibility
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment, // Test icon
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160), // Icon color
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Spacer between test button and about button

                  // About Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InitialPage1()), // Navigate to HomePage when tapped
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10), // Add padding inside the container
                      decoration: const BoxDecoration(
                        color: Colors.white, // Background color for the circular button
                        shape: BoxShape.circle, // Make it circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Add shadow for better visibility
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.info, // About icon
                        size: 30,
                        color: Color.fromARGB(255, 0, 109, 160), // Icon color
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
