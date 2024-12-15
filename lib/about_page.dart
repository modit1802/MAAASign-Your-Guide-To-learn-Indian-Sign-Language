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
                'Learn Indian Sign Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Unlock communication with our structured and interactive sign language learning app, designed for all skill levels! Start from basics and progress to conversational fluency with engaging, culturally-rich lessons that fit your schedule.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),

              // Key Features Section
              Text(
                'Key Features',
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
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.school, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Step-by-Step Lessons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Begin with the alphabet and basic words, and advance to full conversations.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 2 Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.assignment, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Interactive Practice',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Solidify your learning with quizzes, exercises, and real-life scenarios.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 3 Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.trending_up, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Progress Tracking',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Monitor your achievements with personalized progress reports.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 4 Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.public, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Cultural Insights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Understand the culture behind the signs for a deeper connection.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 5 Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.access_time, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'Flexible Learning',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Enjoy bite-sized lessons that adapt to your available time.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Feature 6 Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.group, color: Color.fromARGB(255, 165, 74, 17)),
                  title: Text(
                    'For All Ages',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Perfect for families, students, and professionals.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),

              Divider(),
              SizedBox(height: 16),

              // Why Learn Section
              Text(
                'Why Learn Sign Language?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 74, 17),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Sign language builds bridges. Whether you\'re connecting with the deaf and hard-of-hearing community, adding a valuable skill to your resume, or simply learning something new, this app makes your journey easy and enjoyable. Start learning today and experience the impact of sign language in your life and the lives of those around you!',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
