// TODO Implement this library.
import 'package:flutter/material.dart';

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
      home: const CompoundSentences(),
    );
  }
}

class CompoundSentences extends StatelessWidget {
  const CompoundSentences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Let's Learn Compound Greetings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 142, 45, 226),
        elevation: 0,
      ),
      body: const GreetingGifs(),
    );
  }
}

class GreetingGifs extends StatelessWidget {
  const GreetingGifs({super.key});

  final Map<String, String> greetingGifs = const {
    'hello': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729779713/Hello_zgvlfu.gif',
    'hy': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729779714/Hy_pihzlx.gif',
    'goodbye': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729779723/GoodBye_gepcer.gif',
    'namaste': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729780741/Namaste_rfiiu5.gif',
    'welcome': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729779712/Welcome_ojt24g.gif',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 142, 45, 226),
            Color.fromARGB(255, 74, 0, 224),
            Color.fromARGB(255, 185, 85, 255),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: greetingGifs.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: 180, // Aspect ratio of 9:16
                          height: 320,
                          child: Image.network(
                            entry.value,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
