import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/application_model.dart';
import '../../utils/utils.dart';

class ApplicationService {
  final CollectionReference applicationCollection = FirebaseFirestore.instance.collection('application');
  static String downloadRef = "";

  // Add Application
  Future<void> addApplication(ApplicationModel applicantModel) async {
    try {
      // Generate a new document with a unique ID
      applicantModel.id = Utils.generateUniqueId();

      await applicationCollection.doc(applicantModel.id).set(applicantModel.toMap());

      print('Job post added with ID: ${applicantModel.id}');
    } catch (e) {
      print('Error adding job post: $e');
      // Handle the error as needed
    }
  }

  // Search Application by post id
  // Stream<List<ApplicantModel>> getApplicationsInfo(String applicantId) {
  //   try {
  //     // Create a query to listen for changes on the collection with matching job_post field
  //     Query query = applicationCollection.where('job_post', isEqualTo: postId);
  //
  //     // Return a stream that listens for changes in the query
  //     return query.snapshots().map((snapshot) {
  //       return snapshot.docs
  //           .map((doc) => ApplicantModel.fromDocumentSnapshot(doc))
  //           .toList();
  //     });
  //   } catch (e) {
  //     print('Error retrieving applications stream by post ID: $e');
  //     // Handle the error as needed
  //     throw e;
  //   }
  // }

  Stream<List<ApplicationModel>> getApplicationsByPostId(String postId) {
    try {
      // Create a query to listen for changes on the collection with matching job_post field
      Query query = applicationCollection.where('job_post', isEqualTo: postId);

      // Return a stream that listens for changes in the query
      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ApplicationModel.fromDocumentSnapshot(doc))
            .toList();
      });
    } catch (e) {
      print('Error retrieving applications stream by post ID: $e');
      // Handle the error as needed
      throw e;
    }
  }




  Stream<List<ApplicationModel>> getPostsStream() {
    return applicationCollection
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ApplicationModel.fromDocumentSnapshot(doc)).toList().reversed.toList();
    });
  }

}
