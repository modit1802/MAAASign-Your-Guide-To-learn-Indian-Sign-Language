import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About the App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This app is designed to help the deaf community learn and practice Indian Sign Language (ISL) through interactive lessons and fun games. It’s a four-week course, with each week introducing new signs and assignments to enhance learning.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),

              // Features Section
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
              SizedBox(height: 12),

              // Feature 1 Card
              Card(
                elevation: 4,
                color:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.school, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Learn the Basics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Alphabet finger-spelling and basic number signs in Week 1, greetings and relations in Week 2, and more.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 2 Card
              Card(
                elevation: 4,
                color:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.assignment, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Practice Assignments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Weekly assignments to reinforce learning and build confidence in communication.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 3 Card
              Card(
                elevation: 4,
                color:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.emoji_events, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Challenger Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Test your skills with weekly challenges and track your progress.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 4 Card
              Card(
                elevation: 4,
                color:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.video_library, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Engaging Media',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Colorful images and videos for signs, greetings, and sentence structures.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 5 Card
              Card(
                elevation: 4,
                color:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.translate, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Topic-Comment Structure',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Learn ISL grammar with topic-comment structure examples.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Closing Statement
              Text(
                'Get started on your journey to learning Indian Sign Language with our app. Practice, take on challenges, and immerse yourself in a new way to communicate!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
