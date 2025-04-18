import 'package:flutter/material.dart';

class BalanceScaleGame extends StatefulWidget {
  @override
  _BalanceScaleGameState createState() => _BalanceScaleGameState();
}

class _BalanceScaleGameState extends State<BalanceScaleGame> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> leftItems = [];
  List<Map<String, dynamic>> rightItems = [];
  int totalScore = 0;
  bool showCelebration = false;
  double tiltAngle = 0.0;

  final List<Map<String, dynamic>> islNumbers = [
    {'value': 0, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716936/0_e1tfib.png'},
    {'value': 1, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/1_ypmmhh.png'},
    {'value': 2, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/2_tb6h2y.png'},
    {'value': 3, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/3_tbfqjk.png'},
    {'value': 4, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/4_hltwy4.png'},
    {'value': 5, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264002/5_nofsuk.png'},
    {'value': 6, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264003/6_ireutv.png'},
    {'value': 7, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/7_msy2e3.png'},
    {'value': 8, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/8_kabrqo.png'},
    {'value': 9, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/9_mgaajm.png'},
    {'value': 10, 'image': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/10_qkdwqf.png'},
  ];

  int getLeftWeight() => leftItems.fold(0, (sum, item) => sum + (item['value'] as int));
  int getRightWeight() => rightItems.fold(0, (sum, item) => sum + (item['value'] as int));

  void resetPans() {
    setState(() {
      leftItems.clear();
      rightItems.clear();
      tiltAngle = 0.0;
    });
  }

  void checkBalance() {
    int left = getLeftWeight();
    int right = getRightWeight();

    setState(() {
      tiltAngle = (left - right) * 0.02; // subtle tilt
    });

    if (left == right && left != 0 && right != 0) {
      setState(() {
        totalScore += 100;
        showCelebration = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showCelebration = false;
        });
        resetPans();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEFD8),
      appBar: AppBar(
        title: const Text('🪙 Balance Game', style: TextStyle(fontSize: 19),),
        backgroundColor: Colors.orange,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Score: $totalScore',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                totalScore = 0;
                resetPans();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    '🎯 Drag ISL numbers to balance the scale!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  buildAnimatedScale(),
                  const SizedBox(height: 20),
                  const Divider(indent: 40, endIndent: 40),
                  buildDraggableItems(),
                ],
              ),
            ),
          ),
          if (showCelebration)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🎉 Balanced!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('+100 Points', style: TextStyle(fontSize: 20, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAnimatedScale() {
    return AnimatedRotation(
      duration: const Duration(milliseconds: 300),
      turns: tiltAngle, // Tilt based on difference
      child: buildScale(),
    );
  }

  Widget buildScale() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildScalePan(leftItems, 'Left'),
        const SizedBox(width: 20),
        const Icon(Icons.balance_outlined, size: 50, color: Color.fromARGB(255, 165, 74, 17)),
        const SizedBox(width: 20),
        buildScalePan(rightItems, 'Right'),
      ],
    );
  }

  Widget buildScalePan(List<Map<String, dynamic>> items, String side) {
    return DragTarget<Map<String, dynamic>>(
      onAccept: (data) {
        setState(() {
          if (side == 'Left') {
            leftItems.add(data);
          } else {
            rightItems.add(data);
          }
          checkBalance();
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 140,
          height: 220,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            border: Border.all(color: Color.fromARGB(255, 165, 74, 17), width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '$side\nTotal: ${side == 'Left' ? getLeftWeight() : getRightWeight()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(item['image'], height: 40),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDraggableItems() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(12),
      color: Colors.grey[100],
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(), // no scrolling
        children: islNumbers.map((item) {
          return Draggable<Map<String, dynamic>>(
            data: item,
            feedback: Material(
              color: Colors.transparent,
              child: Image.network(item['image'], height: 60),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: Image.network(item['image'], height: 60),
            ),
            child: Image.network(item['image'], height: 60),
          );
        }).toList(),
      ),
    );
  }
}
