import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(WordConnectGame());
}

class WordConnectGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Connect Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WordGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordGameScreen extends StatefulWidget {
  @override
  _WordGameScreenState createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  Map<String, String> letterImageMap = {
    'A':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/A-unlabelled_igujpe.png',
    'B':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/B-unlabelled_w31a7y.png',
    'C':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/C-unlabelled_rxxbds.png',
    'D':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/D-unlabelled_wtzvac.png',
    'E':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/E-unlabelled_blw8z3.png',
    'F':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/F-unlabelled_snbfpt.png',
    'G':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/G-unlabelled_s2gkov.png',
    'H':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/H-unlabelled_ly0uji.png',
    'I':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/I-unlabelled_ony1yb.png',
    'J':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/J-unlabelled_oyfo82.png',
    'K':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/K-unlabelled_xrrfnn.png',
    'L':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/L-unlabelled_hhwzsw.png',
    'M':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/M-unlabelled_wjswwl.png',
    'N':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/N-unlabelled_rxq0j5.png',
    'O':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/O-unlabelled_y5juiu.png',
    'P':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/P-unlabelled_wqndna.png',
    'Q':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/Q-unlabelled_vcixdp.png',
    'R':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/R-unlabelled_gpraqs.png',
    'S':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/S-unlabelled_oasqu9.png',
    'T':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-unlabelled_lqapym.png',
    'U':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-unlabelled_kvzsbn.png',
    'V':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-unlabelled_ffi7tv.png',
    'W':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-unlabelled_vnlcoq.png',
    'X':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-unlabelled_ufoyeu.png',
    'Y':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Y-unlabelled_qwzmjd.png',
    'Z':'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Z-unlabelled_afrfch.png',
  };

  final List<String> words = [
    'COW',
    'HOME',
    'EASY',
    'HAND',
    'BOOK',
    'BAG',
    'DOG',
    'PEN',
    'COOK',
    'CAT',
    'TAP'
  ];

  int currentWordIndex = 0;
  List<Offset> positions = [];
  List<Offset> lineOffsets = [];
  List<int> selectedIndices = [];
  String displayedWord = '';
  String currentWord = '';
  List<String> letters = [];
  Color boxColor = Colors.white;
  Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    words.shuffle(Random());
    _loadCurrentWord();
  }

  void _loadCurrentWord() {
    if (currentWordIndex < 0 || currentWordIndex >= words.length) return;

    currentWord = words[currentWordIndex];
    letters = currentWord.split('');
    letters.shuffle(Random());
    lineOffsets.clear();
    selectedIndices.clear();
    displayedWord = '';
    boxColor = Colors.white;
    textColor = Colors.black;
    positions = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final centerX = size.width / 2;
      final centerY = size.height / 2;
      final innerRadius = 80;

      setState(() {
        positions = List.generate(letters.length, (index) {
          double angle = (index / letters.length) * 2 * pi;
          return Offset(
            centerX + innerRadius * cos(angle),
            centerY + innerRadius * sin(angle) + 110,
          );
        });
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (positions.isEmpty || letters.isEmpty) return;

    setState(() {
      lineOffsets.clear();
      selectedIndices.clear();
      displayedWord = '';

      for (int i = 0; i < positions.length; i++) {
        if ((details.localPosition - positions[i]).distance < 50) {
          lineOffsets.add(positions[i]);
          selectedIndices.add(i);
          displayedWord += letters[i];
          break;
        }
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (positions.isEmpty || letters.isEmpty) return;

    setState(() {
      for (int i = 0; i < positions.length; i++) {
        if (!selectedIndices.contains(i) &&
            (details.localPosition - positions[i]).distance < 50) {
          lineOffsets.add(positions[i]);
          selectedIndices.add(i);
          displayedWord += letters[i];
          break;
        }
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (displayedWord == currentWord) {
        boxColor = Colors.green;
        textColor = Colors.white;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            currentWordIndex++;
            if (currentWordIndex >= words.length) {
              currentWordIndex = 0;
            }
            _loadCurrentWord();
          });
        });
      } else {
        boxColor = Colors.red;
        textColor = Colors.white;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            boxColor = Colors.white;
            textColor = Colors.black;
            lineOffsets.clear();
            selectedIndices.clear();
            displayedWord = '';
          });
        });
      }
    });
  }

 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final isSmallScreen = screenWidth < 600; // Threshold for small screens

  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 250, 233, 215),
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ladder.png'),
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
        ),
        Container(
          height: screenHeight * 0.35, // Adjust height dynamically
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 252, 133, 37),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.12),
                  child: Text(
                    
                    'Word Chain!',
                    style:TextStyle(
                                fontFamily:
                                    'Courgette', // Use the custom font family
                                fontSize: isSmallScreen
                                    ? 46
                                    : 48, // Font size adjustment
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
        Positioned(
          left: screenWidth / 2 - (screenWidth * 0.40),
          top: screenHeight / 2 - (screenHeight * 0.06),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 250, 233, 215),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 149, 67, 1).withOpacity(0.5),
                  blurRadius: screenHeight * 0.05,
                  spreadRadius: screenWidth * 0.01,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.41,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          top: screenHeight / 2 - (screenHeight * 0.22),
          left: screenWidth / 2 - (screenWidth * 0.25),
          child: Material(
            elevation: 8,
            shadowColor: Colors.orange.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: screenWidth * 0.5,
              height: screenHeight * 0.12,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 252, 133, 37),
                  width: screenWidth * 0.01,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                displayedWord,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            painter: LinePainter(lineOffsets: lineOffsets),
            child: Stack(
              children: [
                for (int i = 0; i < letters.length; i++)
                  Positioned(
                    left: positions.isNotEmpty ? positions[i].dx - (screenWidth * 0.11) : 0,
                    top: positions.isNotEmpty ? positions[i].dy - (screenWidth * 0.14) : 0,
                    child: Material(
                      elevation: 8,
                      shape: CircleBorder(),
                      shadowColor: Colors.black.withOpacity(0.4),
                      child: Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedIndices.contains(i)
                                ? Colors.yellow[900]!
                                : Colors.transparent,
                            width: screenWidth * 0.005,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            letterImageMap[letters[i]] ??
                                'https://via.placeholder.com/100',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: screenHeight / 2 + (screenHeight * 0.35),
          left: screenWidth / 2 - (screenWidth * 0.28),
          child: Center(
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.12,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: screenWidth * 0.15,
                      color: Colors.orange,
                    ),
                    onPressed: _goToPreviousWord,
                  ),
                ),
                SizedBox(width: screenWidth * 0.1),
                CircleAvatar(
                  radius: screenWidth * 0.12,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: screenWidth * 0.15,
                      color: Colors.orange,
                    ),
                    onPressed: _goToNextWord,
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

  void _goToNextWord() {
  setState(() {
    currentWordIndex++;
    if (currentWordIndex >= words.length) {
      currentWordIndex = 0;
      words.shuffle(Random()); // Reshuffle words when all are used
    }
    _loadCurrentWord();
  });
}


  void _goToPreviousWord() {
    setState(() {
      currentWordIndex =
          (currentWordIndex - 1 + words.length) % words.length;
      _loadCurrentWord();
    });
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> lineOffsets;

  LinePainter({required this.lineOffsets});

  @override
  void paint(Canvas canvas, Size size) {
    if (lineOffsets.isEmpty || lineOffsets.length < 2) return;

    final paint = Paint()
      ..color = Colors.yellow[900]!
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < lineOffsets.length - 1; i++) {
      canvas.drawLine(lineOffsets[i], lineOffsets[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
