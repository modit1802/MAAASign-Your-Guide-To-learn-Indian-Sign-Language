import 'package:SignEase/Challengers/challengeralphabets/challenger1.dart';
import 'package:SignEase/Initial_page_1.dart';
import 'package:SignEase/pronounstart.dart';
import 'package:SignEase/verbstart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SignEase/nounstart.dart';



class Week3 extends StatefulWidget {
  const Week3({super.key});

  @override
  _Week3State createState() => _Week3State();
}

class _Week3State extends State<Week3> {
  bool _showGif = true;
  int? _selectedCardIndex; // Track the selected card index

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 55),

                  // Alphabet Circle widget - Card 1
                  _buildCard(
                    onTap: () => _handleCardTap(0, const VerbStartScreen()),
                    imagePath: 'images/verbs_init.png',
                    color: const Color.fromARGB(255, 255, 255, 255),
                    title: 'Verbs',
                    description: 'Learn common verbs with the help of interactive learning material, quizes and exciting match games!',
                    index: 0,
                  ),

                  const SizedBox(height: 10),

                  // Number Circle widget - Card 2
                  _buildCard(
                    onTap: () => _handleCardTap(1, const NounStartScreen()),
                    imagePath: 'images/nouns.png',
                    color: Colors.white,
                    title: 'Nouns',
                    description: 'Learn Nouns with the help of interactive learning material, quizes and exciting match games!',
                    index: 1,
                  ),

                  const SizedBox(height: 10),

                  // Number Circle widget - Card 2
                  _buildCard(
                    onTap: () => _handleCardTap(2, const PronounStartScreen()),
                    imagePath: 'images/pronouns.png',
                    color: Colors.white,
                    title: 'Pronouns',
                    description: 'Learn pronouns with the help of interactive learning material, quizes and exciting match games!',
                    index: 2,
                  ),

                  const SizedBox(height: 10),

                  // Challenger Circle widget - Card 3
                  _buildCard(
                    onTap: () => _handleCardTap(3, Challenger1(score: 0)),
                    imagePath: 'images/challenger.png',
                    color: Colors.white,
                    title: 'Challenger',
                    description: 'Take on challenges and test your skills if you are master with verbs, nouns and pronouns to pass Week 3 Challenge!',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
          if (_showGif)
            ..._buildGifOverlay(context),
          _buildBottomButtons(),
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
            _buildBottomButton(icon: Icons.home, onTap: () => _navigateToPage(const InitialPage1())),
            const SizedBox(width: 20),
            _buildBottomButton(icon: Icons.score, onTap: () => _navigateToPage(const InitialPage1())),
            const SizedBox(width: 20),
            _buildBottomButton(icon: Icons.assignment, onTap: () => _navigateToPage(const InitialPage1())),
            const SizedBox(width: 20),
            _buildBottomButton(icon: Icons.info, onTap: () => _navigateToPage(const InitialPage1())),
          ],
        ),
      ),
    );
  }

  // Bottom Button Builder for consistency
  Widget _buildBottomButton({required IconData icon, required VoidCallback onTap}) {
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
