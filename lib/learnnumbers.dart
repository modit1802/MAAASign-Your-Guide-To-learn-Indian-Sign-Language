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
      appBar: AppBar(
        title: const Text("Numbers",
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: const Color.fromARGB(255, 219, 69, 249),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromARGB(255, 255, 255, 255),
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
                  children: numberGifs.keys.map((imageName) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 6.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: SizedBox(
                                width: 300,
                                height: 300,
                                child: Image.network(
                                  numberGifs[imageName]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          NumberPngCard(imageName: imageName, numberPngs: numberPngs),
                          const SizedBox(height: 16.0),
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
                          color: Colors.green,
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
