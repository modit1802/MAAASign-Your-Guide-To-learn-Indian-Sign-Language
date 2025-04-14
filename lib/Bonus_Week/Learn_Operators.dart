import 'package:flutter/material.dart';

class IslMathLearningPage extends StatelessWidget {
  final Map<int, String> numberImages = {
    0: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1727716936/0_e1tfib.png',
    1: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/1_ypmmhh.png',
    2: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/2_tb6h2y.png',
    3: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/3_tbfqjk.png',
    4: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264000/4_hltwy4.png',
    5: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264002/5_nofsuk.png',
    6: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730264003/6_ireutv.png',
    7: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263998/7_msy2e3.png',
    8: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/8_kabrqo.png',
    9: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/9_mgaajm.png',
    10: 'https://res.cloudinary.com/dfph32nsq/image/upload/v1730263999/10_qkdwqf.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        title: Text('Learn Signing Operations',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 165, 74, 17))),
        backgroundColor: Color.fromARGB(255, 250, 233, 215),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildSection(
            title: '➕ Addition',
            description: 'Addition means putting things together. For example, 2 + 3 means we are adding 2 and 3 together.',
            examples: [
              [2, '+', 3, '=', 5],
              [4, '+', 1, '=', 5],
              [1, '+', 2, '=', 3],
            ],
          ),
          buildSection(
            title: '➖ Subtraction',
            description: 'Subtraction means taking away. For example, 5 - 2 means we are taking 2 away from 5.',
            examples: [
              [5, '-', 2, '=', 3],
              [6, '-', 1, '=', 5],
              [4, '-', 3, '=', 1],
            ],
          ),
          buildSection(
            title: '✖️ Multiplication',
            description: 'Multiplication means repeated addition. For example, 3 × 2 means 3 added 2 times.',
            examples: [
              [3, '×', 2, '=', 6],
              [2, '×', 5, '=', 10],
              [4, '×', 2, '=', 8],
            ],
          ),
          buildSection(
            title: '➗ Division',
            description: 'Division means sharing or splitting. For example, 6 ÷ 2 means splitting 6 into 2 equal parts.',
            examples: [
              [6, '÷', 2, '=', 3],
              [8, '÷', 4, '=', 2],
              [9, '÷', 3, '=', 3],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String description,
    required List<List<dynamic>> examples,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 165, 74, 17))),
        SizedBox(height: 8),
        Text(description, style: TextStyle(fontSize: 16)),
        SizedBox(height: 12),
        Column(
          children: examples.map((e) => buildEquationRow(e)).toList(),
        ),
        SizedBox(height: 20),
        Divider(thickness: 2),
      ],
    );
  }

  Widget buildEquationRow(List<dynamic> expression) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: expression.map((item) {
          if (item is int && numberImages.containsKey(item)) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Image.network(numberImages[item]!, width: 50, height: 50),
            );
          } else if (item is String) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(item, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            );
          } else {
            return SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }
}
