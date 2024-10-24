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
      home: const LearnRelations(),
    );
  }
}

class LearnRelations extends StatelessWidget {
  const LearnRelations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Let's Learn Relations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 142, 45, 226),
        elevation: 0,
      ),
      body: const RelationGifs(),
    );
  }
}

class RelationGifs extends StatelessWidget {
  const RelationGifs({super.key});

  final Map<String, String> relationGifs = const {
    'baby': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788460/Baby_rbccwi.gif',
    'mother': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788563/Mother_hok65t.gif',
    'father': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788458/Father_pdglue.gif',
    'brother': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788516/Brother_qae3tm.gif',
    'sister': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788460/Sister_tfciqn.gif',
    'girl_child': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788460/Girl_Child_zph4el.gif',
    'people': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788458/People_gmwkic.gif',
    'friend': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788457/Friend_byufdj.gif',
    'man': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729788457/Man_x6myyv.gif',
    'female_person': 'https://res.cloudinary.com/dfph32nsq/image/upload/v1729789179/Female_Person_dwckqh.gif',
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
            children: relationGifs.entries.map((entry) {
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
