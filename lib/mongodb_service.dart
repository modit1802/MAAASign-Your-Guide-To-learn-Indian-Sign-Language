import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static late Db db;
  static late DbCollection usersCollection;
  static late DbCollection followersCollection;

  // Connect to MongoDB
  static Future<void> connect() async {
    try {
      db = Db('mongodb://moditgrover2003iii:modit1346@cluster0-shard-00-00.eocm8.mongodb.net:27017,cluster0-shard-00-01.eocm8.mongodb.net:27017,cluster0-shard-00-02.eocm8.mongodb.net:27017/mydatabase?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority'); // Replace with your MongoDB URI
      await db.open();
      usersCollection = db.collection('users');
      followersCollection = db.collection('followers');
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  // Fetch all userIds excluding the current user
  static Future<List<String>> fetchAllUserIdsExceptCurrent(String currentUserId) async {
    try {
      final users = await usersCollection.find({
        'userId': {'\$ne': currentUserId} // Exclude the current user
      }).toList();

      return users.map((user) => user['userId'] as String).toList();
    } catch (e) {
      print("Error fetching userIds: $e");
      return [];
    }
  }

  // Fetch the followers document for a specific user
  static Future<Map<String, dynamic>?> getUserFollowers(String userId) async {
    try {
      final followersDoc = await followersCollection.findOne({'userId': userId});
      return followersDoc;
    } catch (e) {
      print("Error fetching followers: $e");
      return null;
    }
  }

  // Follow a user
  static Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      // Add the current user to their own following list (your own followers list)
      final currentUserFollowers = await getUserFollowers(currentUserId);
      if (currentUserFollowers == null) {
        await followersCollection.insertOne({
          'userId': currentUserId,
          'following': [targetUserId] // Add the target user to current user's following list
        });
      } else {
        await followersCollection.updateOne(
          {'userId': currentUserId},
          {
            r'$addToSet': {'following': targetUserId} // Add target user to current user's following list
          },
        );
      }

      // The target user's follower list should **not** be updated, only current user's list should be updated.
    } catch (e) {
      print("Error following user: $e");
    }
  }

  // Unfollow a user
  static Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      final currentUserFollowers = await getUserFollowers(currentUserId);
      if (currentUserFollowers != null) {
        await followersCollection.updateOne(
          {'userId': currentUserId},
          {
            r'$pull': {'following': targetUserId} // Remove target user from current user's following list
          },
        );
      }

      // Do not modify the target user's follower list.
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }
}
