import 'package:SignEase/Challengers_All_Weeks/challenger_week1/Review_Incorrect_challengers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailedProgressWeek1 extends StatefulWidget {
  const DetailedProgressWeek1({super.key});

  @override
  State<DetailedProgressWeek1> createState() => _DetailedProgressWeek1State();
}

class _DetailedProgressWeek1State extends State<DetailedProgressWeek1> {
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  String? score_challenger;
  String? score_alpha;
  String? score_number;
  String? score_alphabet_match;
  String? score_number_match;
  List<Map<String, dynamic>>? incorrectQuestions;
  bool isLoading = true; // Initial state is loading

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
        'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority');
    try {
      await db.open();
      userCollection = db.collection('users');
      await fetchResultsFromMongoDB();
      print("Connected to MongoDB and result fetched!");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  Future<void> fetchResultsFromMongoDB() async {
    String? userId = await getUserId();
    var result = await userCollection.findOne(mongo.where.eq('userId', userId));
    setState(() {
      if (result != null) {
        score_challenger = result['week']?['week1']?['Score_Challenger_week1']
                ?['score_challenger']
            ?.toString();
        score_alpha = result['week']?['week1']?['Score_alphabet']
                ?['score_alphabet']
            ?.toString();
        score_number = result['week']?['week1']?['Score_number']
                ?['score_number']
            ?.toString();
        score_alphabet_match = (result?['week']?['week1']?['Score_alphabet_match']?['score_alphabet_match']?.toString());
        score_number_match = (result?['week']?['week1']?['Score_number_match']?['score_number_match']?.toString());

        var data = result['week']?['week1']?['Score_Challenger_week1']
            ?['Incorrect_challenges'];
        
        if (data != null && data is List) {
        incorrectQuestions = data.map<Map<String, dynamic>>((item) {
          return {
            'question': item['question'],
            'solution': List<String>.from(item['solution'] ?? []),
            'availableLetters': List<String>.from(item['available_letters'] ?? []),
            'urls': Map<String, String>.from(item['urls'] ?? {}),
          };
        }).toList();
      } else {
        incorrectQuestions = []; // Set to an empty list if null or not a list
      }

        // Set scores to 0 if they are null
        score_alpha ??= '0';
        score_number ??= '0';
        print(incorrectQuestions);
        print(score_alpha);
        print(score_number);
      } else {
        score_challenger = 'Please attempt the challenger';
        print('No data found');
      }
      isLoading = false;
    });
    await db.close();
  }

  Widget _buildScoreCard() {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "Quiz Scores of Week 1",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries<ScoreData, String>>[
                  ColumnSeries<ScoreData, String>(
                    dataSource: [
                      ScoreData(
                          'Alphabets', double.tryParse(score_alpha!) ?? 0),
                    ],
                    xValueMapper: (ScoreData data, _) => data.label,
                    yValueMapper: (ScoreData data, _) => data.value,
                    color: Colors.red,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  ColumnSeries<ScoreData, String>(
                    dataSource: [
                      ScoreData('Numbers', double.tryParse(score_number!) ?? 0),
                    ],
                    xValueMapper: (ScoreData data, _) => data.label,
                    yValueMapper: (ScoreData data, _) => data.value,
                    color: Colors.blue,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildScoreCard2() {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "Match Scores of Week 1",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries<ScoreData, String>>[
                  ColumnSeries<ScoreData, String>(
                    dataSource: [
                      ScoreData(
                          'Alphabets', double.tryParse(score_alphabet_match!) ?? 0),
                    ],
                    xValueMapper: (ScoreData data, _) => data.label,
                    yValueMapper: (ScoreData data, _) => data.value,
                    color: Colors.red,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  ColumnSeries<ScoreData, String>(
                    dataSource: [
                      ScoreData('Numbers', double.tryParse(score_number_match!) ?? 0),
                    ],
                    xValueMapper: (ScoreData data, _) => data.label,
                    yValueMapper: (ScoreData data, _) => data.value,
                    color: Colors.blue,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    // Set score based on score_challenger, defaulting to 0 if null
    double score = double.tryParse(score_challenger ?? '0') ?? 0.0;
    double percentage = (score / 1000)
        .clamp(0.0, 1.0); // Percentage calculation based on score_challenger

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: isLoading // Check if loading
          ? Center(
              // Center the loading indicator
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    const Color.fromARGB(255, 189, 74, 2)), // Set the color
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                    child: _buildCard3(
                      onTap: () {},
                      iconData: Icons.calendar_month,
                      color: Colors.white,
                      title: "Week 1 Progress Report",
                      index: 1,
                      height1: 35,
                      titleColor: const Color.fromARGB(255, 0, 0, 0),
                      iconColor: const Color.fromARGB(255, 189, 74, 2),
                      descriptionColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 15.0,
                      percent: percentage,
                      center: Text(
                        "${(percentage * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      progressColor: const Color.fromARGB(255, 189, 74, 2),
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildCard(
                      onTap: () {},
                      iconData: Icons.check_circle,
                      color: percentage > 0.6 ? Colors.green : Colors.red,
                      title: percentage > 0.6 ? "Success" : "Practice Needed",
                      description: percentage > 0.6
                          ? "Congratulations you have successfully completed week 1."
                          : "Practice Week 1 Again",
                      index: 1,
                      titleColor: Colors.white,
                      iconColor: percentage > 0.6 ? Colors.green : Colors.red,
                      descriptionColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildCard3(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Review_Incorrect_Challengers(incorrectChallenger:incorrectQuestions)));
                      },
                      iconData: Icons.remove_red_eye,
                      color: Colors.white,
                      title: "Review Incorrect Challengers",
                      index: 0,
                      height1: 70,
                      titleColor: const Color.fromARGB(255, 0, 0, 0),
                      descriptionColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  // Show the score card only if both score_alpha and score_number are available
                  if (score_alpha != null && score_number != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildScoreCard(),
                    ),
                  if (score_alphabet_match != null && score_number_match != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildScoreCard2(),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildNoAttemptCard() {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: const Text(
          "You have not attempted the quiz",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData iconData,
    required Color color,
    required String title,
    required String description,
    required int index,
    Color titleColor = Colors.black, // Default title color
    Color iconColor =
        const Color.fromARGB(255, 206, 109, 30), // Default icon color
    Color descriptionColor = Colors.black, // Default description color
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 135,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: Icon(iconData, color: iconColor), // Set icon color
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor, // Set title color
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: descriptionColor, // Set description color
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
    );
  }

   Widget _buildCard2({
    required VoidCallback onTap,
    required IconData iconData,
    required Color color,
    required String title,
    required String description,
    required int index,
    Color titleColor = Colors.black, // Default title color
    Color iconColor =
        const Color.fromARGB(255, 206, 109, 30), // Default icon color
    Color descriptionColor = Colors.black, // Default description color
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 120,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: Icon(iconData, color: iconColor), // Set icon color
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor, // Set title color
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: descriptionColor, // Set description color
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
    );
  }
  Widget _buildCard3({
    required VoidCallback onTap,
    required IconData iconData,
    required Color color,
    required String title,
    required int index,
    required double height1,
    Color titleColor = Colors.black, // Default title color
    Color iconColor =
    const Color.fromARGB(255, 206, 109, 30), // Default icon color
    Color descriptionColor = Colors.black, // Default description color
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(

        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: height1,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: Icon(iconData, color: iconColor), // Set icon color
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor, // Set title color
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
    );
  }

}

class ScoreData {
  ScoreData(this.label, this.value);
  final String label;
  final double value;
}
