import 'package:SignEase/Challengers/challengeralphabets/Result_Challenger_Week1.dart';
import 'package:SignEase/Challengers/challengeralphabets/tutorialscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart';

class Challenger1 extends StatelessWidget {
  final int score;

  Challenger1({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ThirdGame(score: score),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score;

  ThirdGame({required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  late int score;
  bool? isCorrectSolution;
  List<Map<String, dynamic>> incorrectQuestions = [];
  int attempts = 0;
  int maxAttempts = 3;
  int currentChallengeIndex = 0; // Track the current challenge index
  bool showMoveToNextButton = false;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> challengeData = [
    {
      'question': 'cow',
      'solution': ['C', 'O', 'W'],
      'availableLetters': ['O', 'C', 'R', 'W'],
      'urls': {
        'O':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png',
        'C':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png',
        'R':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png',
        'W':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/W_bkgjob.png',
        'cow':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/cow_acsn7t.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'bat',
      'solution': ['B', 'A', 'T'],
      'availableLetters': ['B', 'T', 'A', 'R'],
      'urls': {
        "B":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png",
        "T":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/T_i5ye3w.png",
        "A":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png",
        "R":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
        'bat':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969908/bat_hhcjp7.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'dog',
      'solution': ['D', 'O', 'G'],
      'availableLetters': ['D', 'G', 'O', 'H'],
      'urls': {
        "D":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/D_hnrexc.png",
        "G":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/G_rcvxfs.png",
        "O":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png",
        "H":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/H_hv5qdm.png",
        'dog':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/dog_rlu4zj.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'box',
      'solution': ['B', 'O', 'X'],
      'availableLetters': ['B', 'X', 'O', 'R'],
      'urls': {
        "B":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/B_nf0pwi.png",
        "O":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png",
        "X":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340551/X_kedszo.png",
        "R":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
        'box':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/box_madnit.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },
    {
      'question': 'car',
      'solution': ['C', 'A', 'R'],
      'availableLetters': ['A', 'C', 'R', 'O'],
      'urls': {
        "A":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/A_zlgdfc.png",
        "C":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/C_qsn6tc.png",
        "R":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
        "O":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340552/O_zdqyev.png",
        'car':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969890/car_ooxplt.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'pen',
      'solution': ['P', 'E', 'N'],
      'availableLetters': ['R', 'E', 'N', 'P'],
      'urls': {
        "R":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340553/R_blypku.png",
        "E":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727340550/E_tupepq.png",
        "N":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727852328/N_rvbtxz.png",
        "P":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727852327/P_xczbe3.png",
        'pen':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727969908/pen_ibwjeo.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'one',
      'solution': ['1'],
      'availableLetters': ['1', '2', '3', '4'],
      'urls': {
        '1':
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/1_tlz5st.png",
        '2':
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png",
        '3':
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/3_ywml29.png",
        '4':
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/4_xzh3hq.png",
        'one':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727718826/one_rfzmob.png',
        'correct':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif',
        'wrong':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif',
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'nine',
      'solution': ['9'],
      'availableLetters': ["6", "9", "2", "4"],
      'urls': {
        "9":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/9_gdnhiv.png",
        "6":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/6_okwpzy.png",
        "2":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png",
        "4":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/4_xzh3hq.png",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "nine":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727726266/nine_mwshmr.png",
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'six',
      'solution': ['6'],
      'availableLetters': ["2", "6", "3", "8"],
      'urls': {
        "3":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/3_ywml29.png",
        "2":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png",
        "6":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/6_okwpzy.png",
        "8":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/8_ynuzfh.png",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "six":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727726635/six_iy2km3.png",
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    {
      'question': 'two',
      'solution': ['2'],
      'availableLetters': ["9", "7", "1", "2"],
      'urls': {
        "2":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png",
        "1":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/1_tlz5st.png",
        "9":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/9_gdnhiv.png",
        "7":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/7_p3h2p5.png",
        "correct":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
        "wrong":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
        "two":
            "https://res.cloudinary.com/dfph32nsq/image/upload/v1727726887/two_k1esxb.png",
        'wooden':
            'https://res.cloudinary.com/dfph32nsq/image/upload/v1727358650/wooden_mogsrx.png'
      }
    },

    // Add 3 more challenges in similar format
  ];

  late List<String?> solution;
  late List<String> availableLetters;

  @override
  void initState() {
    super.initState();

    score = widget.score;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showtutorialscreen();
    });
    _initializeChallenge();
  }

  void _showtutorialscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tutorial_screen_for_challenger_alphabet(
          onBackPressed: () {
            Navigator.pop(
                context); // Return to the current screen on back press
          },
        ),
      ),
    );
  }

  void _initializeChallenge() {
    // Load the current challenge data based on the currentChallengeIndex
    solution = List.filled(
        challengeData[currentChallengeIndex]['solution'].length, "wooden");
    availableLetters = List.from(
      challengeData[currentChallengeIndex]['availableLetters'],
    );
  }

  void checkSolution() {
    if (const ListEquality()
        .equals(solution, challengeData[currentChallengeIndex]['solution'])) {
      setState(() {
        isCorrectSolution = true;
        showMoveToNextButton = true;
        if (attempts == 0) {
          score += 100;
        } else if (attempts == 1) {
          score += 50;
        } else if (attempts == 2) {
          score += 25;
        }
      });
      _scrollToGif();
      Future.delayed(const Duration(seconds: 2), () {
        _moveToNextChallenge();
      });
    } else {
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          solution =
              List.from(challengeData[currentChallengeIndex]['solution']);
          isCorrectSolution = false;
          showMoveToNextButton = false;
        incorrectQuestions.add({
          'question':challengeData[currentChallengeIndex]['question'],
          'solution':challengeData[currentChallengeIndex]['solution'],
          'available_letters':challengeData[currentChallengeIndex]['availableLetters'],
          'urls':challengeData[currentChallengeIndex]['urls']
        });
        } else {
          isCorrectSolution = false;
          showMoveToNextButton = false;
        }

      });
      _scrollToGif();
    }
  }

  void _moveToNextChallenge() {
    if (currentChallengeIndex < challengeData.length - 1) {
      setState(() {
        currentChallengeIndex++;
        attempts = 0;
        isCorrectSolution = null;
        showMoveToNextButton = false;
        _initializeChallenge();
      });
    } else {
      // Once all challenges are completed, navigate to Challenger2
      print("Navigating to Challenger2 with score: $score");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Result_Challenger_Week1(score: score,incorrectquestions:incorrectQuestions)),
      );
    }
  }

  void _scrollToGif() async {
    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(seconds: 1));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required String imagePath,
    required Color color,
    required String title,
    required String description,
    required int index,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 50,
                        width: 50,
                        color: const Color.fromARGB(255, 252, 133, 37),
                        child: Center(
                            child: Text(
                          imagePath,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
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
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Image.network(
                    challengeData[currentChallengeIndex]['urls']['correct'],
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.3,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Image.network(
                    challengeData[currentChallengeIndex]['urls']['wrong'],
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.3,
                  ),
                ),
              SizedBox(height: screenHeight * 0.13),
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      _buildCard(
                        onTap: () {},
                        imagePath: '${currentChallengeIndex + 1}',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        title: 'Challenger Round',
                        description:
                            "Drag the correct yellow color available boxes and drop them in to the wooden boxes as per the spelling of question. For more information press the 'tutorial button' on the top",
                        index: 2,
                      ),
                      Material(
                        elevation: screenHeight * 0.01,
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        child: Container(
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            challengeData[currentChallengeIndex]['urls'][
                                challengeData[currentChallengeIndex]
                                    ['question']],
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    challengeData[currentChallengeIndex]['solution'].length,
                    (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != "wooden" &&
                                solution[index] != null) {
                              availableLetters.add(solution[index]!);
                              solution[index] = "wooden";
                            }
                          });
                        },
                        child: Container(
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                            child: solution[index] != null
                                ? Image.network(
                                    challengeData[currentChallengeIndex]['urls']
                                        [solution[index]!]!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        if (solution[index] != "wooden" &&
                            solution[index] != null) {
                          availableLetters.add(solution[index]!);
                        }
                        solution[index] = data;
                        availableLetters.remove(data);
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.007),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter,
                    child: Image.network(
                      challengeData[currentChallengeIndex]['urls'][letter]!,
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.18,
                    ),
                    feedback: Material(
                      child: Image.network(
                        challengeData[currentChallengeIndex]['urls'][letter]!,
                        width: screenWidth * 0.17,
                        height: screenHeight * 0.09,
                      ),
                    ),
                    childWhenDragging: Container(),
                  );
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.007),
              if (!showMoveToNextButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 252, 133, 37),
                  ),
                  onPressed: checkSolution,
                  child: const Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 252, 133, 37),
                  ),
                  onPressed: _moveToNextChallenge,
                  child: const Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
// Score widget (Left side)
        Positioned(
          top: screenHeight * 0.06,
          left: screenWidth * 0.04,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Text(
              "Score: $score",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ),

// Tutorial widget (Center)
// Tutorial widget with information icon (Center)
        Positioned(
          top: screenHeight * 0.06,
          left:
              screenWidth * 0.4, // Adjust this to align properly in the center
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tutorial_screen_for_challenger_alphabet(
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Ensures the row only takes the required space
                children: [
                  Text(
                    "Tutorial",
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(
                      width: screenWidth * 0.02), // Space between text and icon
                  Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: screenWidth * 0.05, // Adjust icon size as needed
                  ),
                ],
              ),
            ),
          ),
        ),

// Chances Left widget (Right side)
        Positioned(
          top: screenHeight * 0.06,
          right: screenWidth * 0.04,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance Left",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
