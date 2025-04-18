import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  late mongo.Db db;
  late mongo.DbCollection userCollection;
  List<Map<String, dynamic>> leaderboard = [];
  Map<String, String> userNameCache = {};
  String? currentUserId;
  int currentPage = 1;
  final int pageSize = 10;
  int totalItems = 0;
  int totalPages = 1;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    connectToMongoDB();
  }

  Future<void> connectToMongoDB() async {
    db = mongo.Db(
      'mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority',
    );

    try {
      await db.open();
      userCollection = db.collection('users');
      totalItems = await userCollection.count();
      totalPages = (totalItems / pageSize).ceil();
      await fetchPage(currentPage);
    } catch (e) {
      print("MongoDB error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCurrentUser() async {
    var user =
        FirebaseFirestore.instance; // or FirebaseAuth if you're using that
    try {
      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: 'your_current_user_email_here')
          .get(); // Update this logic based on how you're tracking logged-in user

      if (currentUser.docs.isNotEmpty) {
        setState(() {
          currentUserId = currentUser.docs.first.id;
        });
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }

  Future<void> fetchPage(int page) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await userCollection
          .find(
            mongo.where
              ..sortBy('Avg_score', descending: true)
              ..skip((page - 1) * pageSize)
              ..limit(pageSize),
          )
          .toList();

      leaderboard = results.map((e) {
        return {
          "userId": e['userId'].toString(),
          "avgScore": e['Avg_score'] != null
              ? double.tryParse(e['Avg_score'].toString()) ?? 0.0
              : 0.0,
        };
      }).toList();
    } catch (e) {
      print("Fetch page error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String> getUserName(String userId) async {
    if (userNameCache.containsKey(userId)) {
      return userNameCache[userId]!;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String name =
          userDoc.exists ? (userDoc['name'] ?? 'No Name') : 'No Name Found';
      userNameCache[userId] = name;
      return name;
    } catch (e) {
      print("Name fetch error: $e");
      return 'Error';
    }
  }

  Widget buildPagination() {
    List<Widget> buttons = [];

    if (currentPage > 1) {
      buttons.add(pageButton("‹", currentPage - 1));
    }

    for (int i = 1; i <= totalPages; i++) {
      buttons.add(pageButton(i.toString(), i, isActive: i == currentPage));
    }

    if (currentPage < totalPages) {
      buttons.add(pageButton("›", currentPage + 1));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: buttons,
      ),
    );
  }

  Widget pageButton(String label, int page, {bool isActive = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        setState(() {
          currentPage = page;
        });
        await fetchPage(currentPage);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isActive ? const Color.fromARGB(255, 255, 148, 34) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 255, 148, 34)),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: const Color.fromARGB(255, 255, 148, 34).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : const Color.fromARGB(255, 255, 148, 34),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.orange.shade50,
    appBar: AppBar(
      title: const Text("🏆 Leader Board 🏆",
          style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Lobsters")),
      centerTitle: true,
      elevation: 5,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange, // Set the color of the loader to orange
            ),
          )
        : Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "✨ Top Performers ✨",
                style: GoogleFonts.lobster(
                  fontSize: 32,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 16),

              /// Top 3 Users Display - Only on Page 1
              if (currentPage == 1) 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leaderboard.length > 1) ...[
                        // Rank 2 (left side)
                        _buildRank(1, leaderboard[1], false),
                      ],
                      if (leaderboard.isNotEmpty) ...[
                        // Rank 1 (center)
                        _buildRank(0, leaderboard[0], true),
                      ],
                      if (leaderboard.length > 2) ...[
                        // Rank 3 (right side)
                        _buildRank(2, leaderboard[2], false),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              /// Remaining Users List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: leaderboard.length - 3,
                  itemBuilder: (context, index) {
                    final entry = leaderboard[index + 3];
                    final rank = index + 4;
                    double score = entry['avgScore'] ?? 0.0;

                    return FutureBuilder<String>( 
                      future: getUserName(entry['userId']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final userName = snapshot.data!;
                        final isCurrentUser = entry['userId'] == currentUserId;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isCurrentUser
                                    ? Colors.deepOrange.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: isCurrentUser ? Colors.deepOrange : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.deepOrange.shade100,
                                child: Text(
                                  '$rank',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrentUser ? Colors.deepOrange : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Rank #$rank",
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "⭐ ${score.toStringAsFixed(2)}",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrentUser ? Colors.deepOrange : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              buildPagination(),
              const SizedBox(height: 20),
            ],
          ),
  );
}
Widget _buildRank(int index, Map entry, bool isRankOne) {
  return FutureBuilder<String>(
    future: getUserName(entry['userId']),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }
      String userName = snapshot.data!;
      double score = entry['avgScore'] ?? 0.0;

      final isFirst = isRankOne;
      final avatarSize = isFirst ? 55.0 : 40.0; // Adjusted smaller size for 1st, 2nd, and 3rd
      final medal = index == 0
          ? '🥇👑'
          : index == 1
              ? '🥈'
              : '🥉';

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isFirst
                        ? [Colors.amber.shade300, Colors.orange]
                        : index == 1
                            ? [Colors.grey.shade400, Colors.grey.shade600]
                            : [Colors.brown.shade200, Colors.brown.shade400],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: avatarSize,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    userName[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              if (isFirst) // Only for Rank 1
                Positioned(
                  top: -avatarSize * 0.75, // Move the crown higher outside the circle
                  right: -avatarSize * 0.25, // Adjust horizontal position
                  child: Text(
                    "👑", 
                    style: const TextStyle(fontSize: 32), // Adjust size for the crown
                  ),
                ),
              Positioned(
                top: 0,
                right: 0,
                child: Text(medal, style: const TextStyle(fontSize: 24)),
              )
            ],
          ),
          const SizedBox(height: 6),
          Text(userName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          Text("⭐ ${score.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14)),
        ],
      );
    },
  );
}


}
