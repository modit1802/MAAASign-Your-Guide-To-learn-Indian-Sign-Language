import 'package:flutter/material.dart';

// ignore: camel_case_types
class Tutorial_screen_for_challenger_Week4 extends StatelessWidget {
  const Tutorial_screen_for_challenger_Week4({super.key, required Null Function() onBackPressed});

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<String> content,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color.fromARGB(255, 158, 81, 13), size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 158, 81, 13),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color.fromARGB(255, 158, 81, 13), thickness: 1.2),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content
                  .map(
                    (point) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromARGB(255, 240, 230, 255),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: Color.fromARGB(255, 97, 33, 122), size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Simple Sentence Construction",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 97, 33, 122),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color.fromARGB(255, 97, 33, 122), thickness: 1.2),
            const SizedBox(height: 8),
            const Text(
              "This week, we will start with easy vocabulary to establish familiarity with ISL’s structure. Focus is on SOV order.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              "Examples:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildExampleText("English: 'I am a student.'", "ISL: 'I student.'"),
            _buildExampleText("English: 'They are watching TV.'", "ISL: 'They TV watch.'"),
            _buildExampleText("English: 'She likes bananas.'", "ISL: 'She banana like.'"),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleText(String english, String isl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(english, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(isl, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 233, 215),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color.fromARGB(255, 158, 81, 13), size: 36),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionCard(
              icon: Icons.notes,
              title: "Basic Structural Differences between ISL and English",
              content: [
                "Subject-Object-Verb (SOV) Order: ISL uses an SOV order, whereas English generally uses an SVO order.",
                "Omission of Articles: Words like 'a,' 'an,' and 'the' are usually omitted.",
                "Time Indicators First: ISL typically places time indicators at the beginning of sentences.",
              ],
              backgroundColor: const Color.fromARGB(255, 255, 245, 235),
            ),
            _buildSectionCard(
              icon: Icons.face,
              title: "Expressiveness Techniques in ISL using Non-Manual Markers (NMMs)",
              content: [
                "Eyebrows: Raised for yes/no questions, lowered for wh-questions.",
                "Head Movements and Eye Gaze: Indicate agreement, emphasis, or attention.",
                "Facial Expressions: Essential for showing emotion and tone (e.g., happy, sad, surprised).",
              ],
              backgroundColor: const Color.fromARGB(255, 235, 255, 245),
            ),
            _buildExampleCard(context),
          ],
        ),
      ),
    );
  }
}
