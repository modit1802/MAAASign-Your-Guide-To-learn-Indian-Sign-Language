import 'package:flutter/material.dart';
import 'package:SignEase/Week%202/relations_learn.dart'; // Import the SentenceStartscreen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Colors.transparent,
        ),
      ),
      home: const LearnRelations(), // Set the initial screen
    );
  }
}

class LearnRelations extends StatelessWidget {
  const LearnRelations({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to SentenceStartscreen when LearnRelations is built
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SentenceStartscreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while redirecting
      ),
    );
  }
}
