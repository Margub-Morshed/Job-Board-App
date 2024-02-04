import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_board_app/utils/utils.dart';

import '../../model/job_post_model.dart';

class FavoriteService {
  static Future<bool> checkIfFavorite(String userId, String jobId) async {
    // Query Firestore to check if the post is in the user's favorites
    // You need to implement this based on your Firestore structure
    // Return true if it's already a favorite, false otherwise
    // For simplicity, we assume a 'favorites' collection with user documents containing a 'fav_collection'
    // and each favorite having a unique ID (job ID in this case).
    // Replace with your actual Firestore structure and logic.
    DocumentSnapshot<Map<String, dynamic>> doc = await Utils.favoritesRef
        .doc(userId)
        .collection('fav_collection')
        .doc("${userId}_$jobId")
        .get();

    return doc.exists;
  }

  static Future<void> addToFavorites(String userId, String jobId) async {
    // Add the post to the user's favorites in Firestore
    // You need to implement this based on your Firestore structure
    // For simplicity, we assume a 'favorites' collection with user documents containing a 'fav_collection'.
    // Replace with your actual Firestore structure and logic.

    final createdAt = DateTime.now().millisecondsSinceEpoch;
    await Utils.favoritesRef
        .doc(userId)
        .collection('fav_collection')
        .doc("${userId}_$jobId")
        .set({'job_id': jobId, 'created_at': createdAt});
  }

  static Future<void> removeFromFavorites(String userId, String jobId) async {
    // Remove the post from the user's favorites in Firestore
    // You need to implement this based on your Firestore structure
    // For simplicity, we assume a 'favorites' collection with user documents containing a 'fav_collection'.
    // Replace with your actual Firestore structure and logic.
    await Utils.favoritesRef
        .doc(userId)
        .collection('fav_collection')
        .doc("${userId}_$jobId")
        .delete();
  }

  static Stream<List<JobPostModel>> getFavoriteJobPostsStream(String userId) {
    // Get a stream of the collection of job posts favorited by the user
    // For simplicity, we assume a 'favorites' collection with user documents containing a 'fav_collection'.
    // Each document in 'fav_collection' has a field 'jobId' representing the ID of the favorited job post.
    // Replace with your actual Firestore structure and logic.

    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = Utils
        .favoritesRef
        .doc(userId)
        .collection('fav_collection')
        .orderBy('created_at', descending: true)
        .snapshots();

    return querySnapshotStream.asyncMap((querySnapshot) async {
      List favoritedJobPostIds =
          querySnapshot.docs.map((doc) => doc['job_id']).toList();

      // Fetch the job posts from the 'jobPosts' collection using the favorited IDs
      // Replace with your actual Firestore structure and logic.

      List<JobPostModel> favoriteJobPosts = [];

      for (String jobId in favoritedJobPostIds) {
        DocumentSnapshot<Map<String, dynamic>> jobPostDoc =
            await Utils.jobPostsRef.doc(jobId).get();

        if (jobPostDoc.exists) {
          JobPostModel jobPost =
              JobPostModel.fromMap(jobPostDoc.data() as Map<String, dynamic>);
          favoriteJobPosts.add(jobPost);
        }
      }

      return favoriteJobPosts;
    });
  }
}
