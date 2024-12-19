import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mongodb_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  String? currentUserId;
  List<String> userIds = [];
  Map<String, String> userNames = {}; // Map to hold userIds and their corresponding user names
  Map<String, String> userPhotoUrls = {}; // Map to hold userIds and their corresponding user photo URLs
  Map<String, List<dynamic>> userFollowing = {}; // To track who the user is following

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      await MongoDBService.connect();
      await fetchUserIds();
    }
  }

  // Fetch all userIds excluding the current user
  Future<void> fetchUserIds() async {
    userIds = await MongoDBService.fetchAllUserIdsExceptCurrent(currentUserId!);
    for (var userId in userIds) {
      await fetchUserName(userId);
      await fetchUserPhotoUrl(userId); // Fetch the photo URL
      await fetchUserFollowing(userId);
    }
    setState(() {});
  }

  // Fetch username from Firebase using userId
  Future<void> fetchUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          userNames[userId] = userDoc['name']; // Assuming 'name' field exists in Firestore
        });
      }
    } catch (e) {
      print("Error fetching userName: $e");
    }
  }

  // Fetch photo URL from Firebase using userId
  Future<void> fetchUserPhotoUrl(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc['photoUrl'] != null) {
        setState(() {
          userPhotoUrls[userId] = userDoc['photoUrl']; // Assuming 'photoUrl' field exists in Firestore
        });
      } else {
        setState(() {
          userPhotoUrls[userId] = ''; // Default to empty string if no photoUrl is found
        });
      }
    } catch (e) {
      print("Error fetching user photo: $e");
    }
  }

  // Fetch the list of users the current user is following
  Future<void> fetchUserFollowing(String userId) async {
    try {
      final followersDoc = await MongoDBService.getUserFollowers(userId);
      if (followersDoc != null) {
        setState(() {
          userFollowing[userId] = List.from(followersDoc['followers']);
        });
      }
    } catch (e) {
      print("Error fetching user following: $e");
    }
  }

  // Check if the current user is following the target user
  bool isFollowing(String targetUserId) {
    return userFollowing[currentUserId!] != null && userFollowing[currentUserId!]!.contains(targetUserId);
  }

  // Toggle follow/unfollow
  Future<void> toggleFollow(String targetUserId) async {
    if (userFollowing[currentUserId!] == null) {
      // Initialize the list if it's null
      userFollowing[currentUserId!] = [];
    }

    if (isFollowing(targetUserId)) {
      // Unfollow the user
      await MongoDBService.unfollowUser(currentUserId!, targetUserId);
      setState(() {
        // Remove from current user's following list
        userFollowing[currentUserId!]!.remove(targetUserId);
      });
    } else {
      // Follow the user
      await MongoDBService.followUser(currentUserId!, targetUserId);
      setState(() {
        // Add to current user's following list
        userFollowing[currentUserId!]!.add(targetUserId);
      });
    }
  }

  // Follow Button UI
  Widget _buildFollowButton(String targetUserId) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing(targetUserId) ? Colors.red : Colors.blue, // Change color based on follow/unfollow
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () => toggleFollow(targetUserId),
      child: Text(
        isFollowing(targetUserId) ? 'Unfollow' : 'Follow',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      appBar: AppBar(title: Text('Find your friends'),backgroundColor: const Color.fromARGB(255, 250, 233, 215),),
      body: userIds.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            
              itemCount: userIds.length,
              itemBuilder: (context, index) {
                final userId = userIds[index];
                final userName = userNames[userId] ?? 'Loading...';
                final userPhotoUrl = userPhotoUrls[userId] ?? ''; // Default to empty string if no photo

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: userPhotoUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userPhotoUrl),
                              radius: 25,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 25,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                      title: Text(
                        userName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: _buildFollowButton(userId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
