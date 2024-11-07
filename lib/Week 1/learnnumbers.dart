import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LearnNumbers extends StatefulWidget {
  const LearnNumbers({super.key});

  @override
  State<LearnNumbers> createState() => _LearnNumbersState();
}

class _LearnNumbersState extends State<LearnNumbers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: const Text("Learn Numbers",
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
        ),),
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(

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
    '10',
  ];

  // Cloudinary GIF and PNG URLs for numbers
  Map<String, String> numberGifs = {
    '0': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468447/0_axhirl.gif',
    '1': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468449/1_ljz1ju.gif',
    '2': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468441/2_lwos6k.gif',
    '3': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468442/3_xuxqu6.gif',
    '4': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468443/4_oaa3k5.gif',
    '5': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468443/5_zldhao.gif',
    '6': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468443/6_hgxmcy.gif',
    '7': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468444/7_pm4jey.gif',
    '8': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468445/8_ppx7wc.gif',
    '9': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468446/9_fgfksn.gif',
    '10': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468447/10_fb0hxd.gif',
  };

  Map<String, String> numberPngs = {
    '0': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468140/0_num_hzxxvg.png',
    '1': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468141/1_num_exnnlu.png',
    '2': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468143/2_num_tb62qp.png',
    '3': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468140/3_num_qb0ovx.png',
    '4': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468141/4_num_vbwkaj.png',
    '5': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468142/5_num_c2sbks.png',
    '6': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468143/6_num_rygxkv.png',
    '7': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468144/7_num_iblbw8.png',
    '8': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468144/8_num_qm8gci.png',
    '9': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468139/9_num_cpzgzn.png',
    '10': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468139/10_num_k0k0h7.png',
  };

  final ScrollController _scrollController = ScrollController();
  bool showPopup = false;
  bool popupShownBefore = false;
  late Animation<double> _animation;
  late AnimationController _controller;
  late AnimationController _animationController;

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
      setState(() {
        showPopup = true;
      });

      _animationController.forward().then((value) {
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
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'learnnumber': learnNumber,
      }, SetOptions(merge: true));
    }
  }

  @override
Widget build(BuildContext context) {
  // Get the screen size
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

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
                  offset: Offset(0.0, screenHeight * 0.05 * (1 - _animation.value)), // Adjust offset based on screen height
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: numberImages.map((imageName) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02, // Adjust horizontal padding
                          ),
                          child: Column(
                            children: [
                              // Display GIF
                              Card(
                                elevation: screenHeight * 0.01, // Adjust elevation
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // Adjust border radius
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // Adjust border radius
                                  child: SizedBox(
                                    width: screenWidth * 0.8, // Adjust width dynamically
                                    height: screenHeight * 0.4, // Adjust height dynamically
                                    child: Image.network(
                                      numberGifs[imageName]!,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: screenWidth * 0.01,
                                              color: Color.fromARGB(255, 189, 74, 2), // Adjust loader size
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01), // Adjust vertical spacing
                              // Display PNG of the same size
                              Card(
                                elevation: screenHeight * 0.01, // Adjust elevation
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // Adjust border radius
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // Adjust border radius
                                  child: SizedBox(
                                    width: screenWidth * 0.8, // Adjust width dynamically
                                    height: screenHeight * 0.4, // Adjust height dynamically
                                    child: Image.network(
                                      numberPngs[imageName]!,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: screenWidth * 0.01,
                                              color: Color.fromARGB(255, 189, 74, 2), // Adjust loader size
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02), // Adjust vertical spacing
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

class NumberPngCard extends StatelessWidget {
  final String imageName;
  final Map<String, String> numberPngs;

  const NumberPngCard({super.key, required this.imageName, required this.numberPngs});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            numberPngs[imageName]!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
