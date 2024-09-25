import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';

class LearnNumbers extends StatelessWidget {
  const LearnNumbers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's learn Numbers"),
      ),
      body: learnnumberscards(),
    );
  }
}

class learnnumberscards extends StatefulWidget {
  @override
  State<learnnumberscards> createState() => _learnnumberscardsState();
}

class _learnnumberscardsState extends State<learnnumberscards>
    with SingleTickerProviderStateMixin {
  List<String> alphabetImages = [
    '0','1','2','3','4','5','6','7','8','9','10'
  ];

  ScrollController _scrollController = ScrollController();
  bool showPopup = false;
  bool popupShownBefore = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
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
                  children: alphabetImages.map((imageName) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                                  future: _loadGif('images/Numbers/$imageName.gif'),
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
                                        color: Colors.grey, // Placeholder color while loading
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ), // GIF card
                          SizedBox(height: 8.0), // spacing between cards
                          AlphabetPngCard(
                            imageName: imageName,
                          ), // PNG card
                          SizedBox(height: 16.0), // spacing between cards
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
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.green, // Change color to green
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Wohoo! You have learned 10 Numbers.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: _dismissPopup,
                        child: Text('OK'),
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

  const AlphabetPngCard({Key? key, required this.imageName}) : super(key: key);

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
