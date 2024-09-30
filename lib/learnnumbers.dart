import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';

class LearnNumbers extends StatefulWidget {
  const LearnNumbers({super.key});

  @override
  State<LearnNumbers> createState() => _LearnNumbersState();
}

class _LearnNumbersState extends State<LearnNumbers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's learn Numbers"),
        backgroundColor: const Color.fromARGB(255, 219, 69, 249),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 219, 69, 249),
              Color.fromARGB(255, 135, 205, 238),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: const LearnNumbersCards(),
      ),
    );
  }
}

class LearnNumbersCards extends StatefulWidget {
  const LearnNumbersCards({super.key});

  @override
  State<LearnNumbersCards> createState() => _LearnNumbersCardsState();
}

class _LearnNumbersCardsState extends State<LearnNumbersCards>
    with SingleTickerProviderStateMixin {
  List<String> numberImages = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  final ScrollController _scrollController = ScrollController();
  bool showPopup = false;
  bool popupShownBefore = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _updateLearnNumberInFirebase(20);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  void _onScroll() {
    if (!popupShownBefore && _scrollController.offset >= 10 * 300.0) {
      // User has scrolled 10 cards (assuming each card is 300 pixels wide)
      setState(() {
        showPopup = true;
      });

      // Start the animation when popup appears
      _animationController.forward().then((value) {
        // After 5 seconds, hide the popup
        _dismissPopup();
      });
    }
  }

  void _dismissPopup() {
    setState(() {
      showPopup = false;
      popupShownBefore = true;
    });
    _updateLearnNumberInFirebase(20);
  }

  Future<void> _updateLearnNumberInFirebase(int learnNumber) async {
    // Get the current user's uid from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Update Firestore with the 'learn_number' field for the user
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'learnnumber': learnNumber,
      }, SetOptions(merge: true)); // Merging to avoid overwriting other fields
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: numberImages.map((imageName) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 6.0, // Set elevation for shadow effect
                            shape: RoundedRectangleBorder(
                              // Set rounded corners
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              // Clip the image with rounded corners
                              borderRadius: BorderRadius.circular(15.0),
                              // Same value as above
                              child: SizedBox(
                                width: 300,
                                height: 300,
                                child: FutureBuilder<Uint8List>(
                                  future:
                                      _loadGif('images/Numbers/$imageName.gif'),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Image.memory(
                                        snapshot.data!,
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Container(
                                        width: 300,
                                        height: 300,
                                        color: Colors
                                            .grey, // Placeholder color while loading
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ), // GIF card
                          const SizedBox(height: 8.0), // spacing between cards
                          AlphabetPngCard(
                            imageName: imageName,
                          ), // PNG card
                          const SizedBox(height: 16.0), // spacing between cards
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        if (showPopup)
          Center(
            child: GestureDetector(
              onTap: _dismissPopup,
              child: Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.green, // Change color to green
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Wohoo! You have learned 10 Numbers.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: _dismissPopup,
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<Uint8List> _loadGif(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
}

class AlphabetPngCard extends StatelessWidget {
  final String imageName;

  const AlphabetPngCard({super.key, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        elevation: 6.0, // Set elevation for shadow effect
        shape: RoundedRectangleBorder(
          // Set rounded corners
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          // Clip the image with rounded corners
          borderRadius: BorderRadius.circular(15.0),
          // Same value as above
          child: Image.asset(
            'images/Numbers/$imageName.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
