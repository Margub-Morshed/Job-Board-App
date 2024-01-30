import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/job_post_model.dart';

class JobService {
  final CollectionReference jobPostsCollection = FirebaseFirestore.instance.collection('job_posts');

  Future<void> addPost(JobPostModel jobPost) async {
    try {
      // Generate a new document with a unique ID
      jobPost.id = await generateUniqueId();
      await jobPostsCollection.doc(jobPost.id).set(jobPost.toMap());

      print('Job post added with ID: ${jobPost.id}');
    } catch (e) {
      print('Error adding job post: $e');
      // Handle the error as needed
    }
  }

  Stream<List<JobPostModel>> getPostsStream() {
    return jobPostsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JobPostModel.fromFirebaseDocument(doc)).toList().reversed.toList();
    });
  }

  Future<String> generateUniqueId() async {
    // Generate a unique ID without creating a document
    DocumentReference documentReference = jobPostsCollection.doc();
    return documentReference.id;
  }
}
