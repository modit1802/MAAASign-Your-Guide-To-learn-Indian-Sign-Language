import 'package:SignEase/Challengers_All_Weeks/challenger_week2/challenger2.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%202/greetingstartscreen.dart';
import 'package:SignEase/Week%202/relationstartscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Week2NewScreen extends StatefulWidget {
  const Week2NewScreen({super.key});

  @override
  _Week2NewScreenState createState() => _Week2NewScreenState();
}

class _Week2NewScreenState extends State<Week2NewScreen> {
  bool _showGif = false;
  int? _selectedCardIndex;
  int _currentIndex = 0; // This keeps track of the selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex =index; // Update the current index to highlight the selected tab
    });

    // You can add navigation or specific actions based on the selected index
    switch (index) {
      case 0:
        // Navigate to the Home screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 0),
          ),
        ); // Replace with your actual route
        break;
      case 1:
        // Navigate to the Test screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 1),
          ),
        ); // Replace with your actual route
        break;
      case 2:
        // Navigate to the Score screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 2),
          ),
        );  // Replace with your actual route
        break;
      case 3:
        // Navigate to the About screen or perform any action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage1(index: 3),
          ),
        );  // Replace with your actual route
        break;
      default:
        break;
    }
  }
  // Track the selected card index

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
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
    child: BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 165, 74, 17),
                size: 30, // Adjust size here (default is 24)
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(
                Icons.fact_check,
                color: Color.fromARGB(255, 165, 74, 17),
                size: 30, // Adjust size here
              ),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(
                Icons.score,
                color: Color.fromARGB(255, 165, 74, 17),
                size: 30, // Adjust size here
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Color.fromARGB(255, 165, 74, 17),
                size: 30, // Adjust size here
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    ),
  ),
),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight*0.14),
                  

                  // Greeting Circle widget - Card 1
                  _buildCard(
                    onTap: () => _handleCardTap(0, const GreetingStartscreen()),
                    imagePath: 'images/greetings.png',
                    color: const Color.fromARGB(255, 255, 255, 255),
                    title: 'Greetings',
                    description:
                        'Learn Greetings with learning material, quizzes & guess games!',
                    index: 0,
                  ),

                  const SizedBox(height: 10),

                  // Relation Circle widget - Card 2
                  _buildCard(
                    onTap: () => _handleCardTap(1, const RelationStartscreen()),
                    imagePath: 'images/Relation.png',
                    color: Colors.white,
                    title: 'Relations',
                    description:
                        'Learn Relations with learning material, quizzes & guess games!',
                    index: 1,
                  ),

                  const SizedBox(height: 10),

                  // Challenger Circle widget - Card 3
                  _buildCard(
                    onTap: () => _handleCardTap(2, Challenger2(score: 0)),
                    imagePath: 'images/challenger.png',
                    color: Colors.white,
                    title: 'Challenger',
                    description:
                        'Challenge yourself to Pass Week 2 and Go to Week 3!',
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.065,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
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
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle Card Tap with index and navigation
  void _handleCardTap(int index, Widget nextPage) {
    setState(() {
      _selectedCardIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      ).then((_) => setState(() {
            _selectedCardIndex = null; // Reset after navigation
          }));
    });
  }


  // Card Builder for consistency
  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77) : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 140,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // GIF Overlay Builder
  List<Widget> _buildGifOverlay(BuildContext context) {
    return [
      Container(color: Colors.black.withOpacity(0.92)),
      Center(
        child: Image.asset(
          'images/teacher_week.gif',
          height: 350,
          fit: BoxFit.contain,
        ),
      ),
      Positioned(
        top: 60,
        right: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showGif = false;
            });
          },
          child: const Icon(
            Icons.close,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    ];
  }

  // Bottom Buttons
  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBottomButton(
                icon: Icons.home,
                onTap: () => _navigateToPage(const InitialPage1(
                      index: 0,
                    ))),
            const SizedBox(width: 20),
            _buildBottomButton(
                icon: Icons.fact_check,
                onTap: () => _navigateToPage(const InitialPage1(
                      index: 1,
                    ))),
            const SizedBox(width: 20),
            _buildBottomButton(
                icon: Icons.score,
                onTap: () => _navigateToPage(const InitialPage1(index: 2))),
            const SizedBox(width: 20),
            _buildBottomButton(
                icon: Icons.info,
                onTap: () => _navigateToPage(const InitialPage1(index: 3))),
          ],
        ),
      ),
    );
  }

  // Bottom Button Builder for consistency
  Widget _buildBottomButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
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
        child: Icon(
          icon,
          size: 30,
          color: const Color.fromARGB(255, 165, 74, 17),
        ),
      ),
    );
  }

  // Navigation Helper
  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
