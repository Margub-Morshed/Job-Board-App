import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/job_post_model.dart';
import '../../utils/utils.dart';

class JobService {
  static final CollectionReference jobPostsCollection =
      FirebaseFirestore.instance.collection('job_posts');
  static String downloadRef = "";

  Future<void> addPost(JobPostModel jobPost) async {
    try {
      // Generate a new document with a unique ID
      jobPost.id = Utils.generateUniqueId();
      jobPost.image = downloadRef;
      await jobPostsCollection.doc(jobPost.id).set(jobPost.toMap());

      print('Job post added with ID: ${jobPost.id}');
    } catch (e) {
      print('Error adding job post: $e');
      // Handle the error as needed
    }
  }

  Stream<List<JobPostModel>> getPostsStream() {
    return jobPostsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => JobPostModel.fromFirebaseDocument(doc))
          .toList()
          .reversed
          .toList();
    });
  }

  // get job post by company id
  static Stream<List<JobPostModel>> getJobPostsByCompanyId(String companyId) {
    try {
      // Query the job posts collection based on the company ID
      return jobPostsCollection
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .map((querySnapshot) {
        // Convert the documents into a list of JobPostModel
        return querySnapshot.docs
            .map((doc) => JobPostModel.fromFirebaseDocument(doc))
            .toList()
            .reversed
            .toList();
      });
    } catch (e) {
      print('Error getting job posts by company ID: $e');
      // Handle the error as needed
      throw e;
    }
  }

  static Future<String> updateJobPostImage(File file) async {
    try {
      //getting image file extension
      final ext = file.path.split('.').last;
      log('Extension: $ext');

      //storage file ref with path
      final ref = Utils.firestorage.ref().child(
          'job_post_images//${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

      //uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      });

      //updating image in firestore database
      downloadRef = await ref.getDownloadURL();
      return downloadRef;
    } catch (e) {
      print("Error updating profile: $e");
      throw e;
    }
  }
}
