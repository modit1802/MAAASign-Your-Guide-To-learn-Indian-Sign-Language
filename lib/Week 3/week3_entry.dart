import 'package:SignEase/Challengers_All_Weeks/challenger_week3/challenger3.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/Week%203/pronounstart.dart';
import 'package:SignEase/Week%203/verbstart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SignEase/Week%203/nounstart.dart';



class Week3Entry extends StatefulWidget {
  const Week3Entry({super.key});

  @override
  _Week3EntryState createState() => _Week3EntryState();
}

class _Week3EntryState extends State<Week3Entry> {
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
  } // Track the selected card index

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

                  // Alphabet Circle widget - Card 1
                  _buildCard(
                    onTap: () => _handleCardTap(0, const VerbStartScreen()),
                    imagePath: 'images/verbs_init.png',
                    color: const Color.fromARGB(255, 255, 255, 255),
                    title: 'Verbs',
                    description: 'Learn and practice signing verbs',
                    index: 0,
                  ),

                  const SizedBox(height: 10),

                  // Number Circle widget - Card 2
                  _buildCard(
                    onTap: () => _handleCardTap(1, const NounStartScreen()),
                    imagePath: 'images/nouns.png',
                    color: Colors.white,
                    title: 'Nouns',
                    description: 'Learn and practice signing nouns',
                    index: 1,
                  ),

                  const SizedBox(height: 10),

                  // Number Circle widget - Card 2
                  _buildCard(
                    onTap: () => _handleCardTap(2, const PronounStartScreen()),
                    imagePath: 'images/pronouns.png',
                    color: Colors.white,
                    title: 'Pronouns',
                    description: 'Learn and practice signing pronouns',
                    index: 2,
                  ),

                  const SizedBox(height: 10),

                  // Challenger Circle widget - Card 3
                  _buildCard(
                    onTap: () => _handleCardTap(3, Challenger3(score: 0)),
                    imagePath: 'images/challenger.png',
                    color: Colors.white,
                    title: 'Challenger',
                    description: 'Challenge yourself to unlock Week 4 !',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
          if (_showGif)
            ..._buildGifOverlay(context),
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

  // Background Builder
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white],
        ),
      ),
    );
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
        color: isSelected ? const Color.fromARGB(255, 255, 145, 77): color,
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
          'images/week3_start_teacher.gif',
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

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
