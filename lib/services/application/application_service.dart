import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:job_board_app/model/user_model.dart';
import '../../model/application_model.dart';
import '../../utils/utils.dart';

class ApplicationService {
  static final CollectionReference applicationCollection =
      FirebaseFirestore.instance.collection('applications');
  static String downloadRef = "";

  // Add Application
  Future<void> addApplication(ApplicationModel applicantModel) async {
    try {
      // Generate a new document with a unique ID
      applicantModel.id = Utils.generateUniqueId();

      await applicationCollection
          .doc(applicantModel.id)
          .set(applicantModel.toMap());

      print('Job post added with ID: ${applicantModel.id}');
    } catch (e) {
      print('Error adding job post: $e');
      // Handle the error as needed
    }
  }

  // Search USer Information who apply
  static Stream<List<UserModel>> getUserInfo(String userId) {
    try {
      // Create a query to listen for changes on the collection with matching job_post field
      Query query = Utils.jobSeekersRef.where('id', isEqualTo: userId);

      // Return a stream that listens for changes in the query
      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => UserModel.fromDocumentSnapshot(doc))
            .toList();
      });
    } catch (e) {
      print('Error retrieving applications stream by post ID: $e');
      // Handle the error as needed
      throw e;
    }
  }

  static Stream<List<ApplicationModel>> getApplicationsByPostId(String postId) {
    try {
      // Create a query to listen for changes on the collection with matching job_post field
      Query query = applicationCollection.where('job_post', isEqualTo: postId);

      // Return a stream that listens for changes in the query
      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
            .toList().reversed.toList();
      });
    } catch (e) {
      print('Error retrieving applications stream by post ID: $e');
      // Handle the error as needed
      throw e;
    }
  }

  Stream<List<ApplicationModel>> getPostsStream() {
    return applicationCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
          .toList()
          .reversed
          .toList();
    });
  }

  // Stream method to get applications for a specific user
  static Stream<List<ApplicationModel>> getApplicationsForUser(String userId) {
    return Utils.applicationsRef
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Stream method to get applications for a specific user
  static Stream<List<ApplicationModel>> getApplicationsForCompanyAdmin(String companyId) {
    return Utils.applicationsRef
        .where('company_id', isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
          .toList().reversed.toList();
    });
  }

  // Stream method to get all applications for company and super admin
  static Stream<List<ApplicationModel>> getAllApplications() {
    return Utils.applicationsRef
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
          .toList().reversed.toList();
    });
  }

  // Check the USer is already apply a post or not
  static Future<bool> hasUserApplied(String userId, String jobId) async {
    try {
      // Create a query to check if there is any application with the given userId and jobId
      Query query = applicationCollection
          .where('user_id', isEqualTo: userId)
          .where('job_post', isEqualTo: jobId);

      // Get the documents that match the query
      QuerySnapshot querySnapshot = await query.get();

      // Return true if there is at least one document (user has applied), otherwise return false
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user has applied: $e');
      throw e;
    }
  }

  // Update Application status
  static Future<void> updateApplicationStatus(String applicationId, String newStatus) async {
    try {
      await Utils.applicationsRef.doc(applicationId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updating company status: $e');
    }
  }


  static Future<String> uploadApplicationCV(File file) async {
    try {
      //getting image file extension
      final ext = file.path.split('.').last;
      log('Extension: $ext');

      //storage file ref with path
      final ref = Utils.firestorage.ref().child(
          'CV//${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

      //uploading image
      await ref
          .putFile(file)
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
