import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  String id;
  String jobPost;
  String message;
  String expectedSalary;
  String cv;
  String status;

  ApplicationModel({
    required this.id,
    required this.jobPost,
    required this.message,
    required this.expectedSalary,
    required this.cv,
    required this.status,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> data) {
    return ApplicationModel(
      id: data['id'] ?? '',
      jobPost: data['job_post'] ?? '',
      message: data['message'] ?? '',
      expectedSalary: data['expected_salary'] ?? '',
      cv: data['cv'] ?? '',
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job_post': jobPost,
      'message': message,
      'expected_salary': expectedSalary,
      'cv': cv,
      'status': status,
    };
  }

  factory ApplicationModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ApplicationModel.fromMap(data);
  }

  @override
  String toString() {
    return 'Applicant{id: $id, jobPost: $jobPost, message: $message, '
        'expectedSalary: $expectedSalary, cv: $cv, status: $status}';
  }
}