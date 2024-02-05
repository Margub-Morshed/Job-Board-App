import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  String id;
  String userId;
  String jobPost;
  String message;
  String expectedSalary;
  String cv;
  String status;
  String createdAt;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.jobPost,
    required this.message,
    required this.expectedSalary,
    required this.cv,
    required this.status,
    String? createdAt,
  }) : createdAt = DateTime.now().millisecondsSinceEpoch.toString();

  factory ApplicationModel.fromMap(Map<String, dynamic> data) {
    return ApplicationModel(
      id: data['id'] ?? '',
      userId: data['user_id'] ?? '',
      jobPost: data['job_post'] ?? '',
      message: data['message'] ?? '',
      expectedSalary: data['expected_salary'] ?? '',
      cv: data['cv'] ?? '',
      status: data['status'] ?? '',
      createdAt: data['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'job_post': jobPost,
      'message': message,
      'expected_salary': expectedSalary,
      'cv': cv,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory ApplicationModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ApplicationModel.fromMap(data);
  }

  @override
  String toString() {
    return 'Applicant{id: $id,userId: $userId, jobPost: $jobPost, message: $message, '
        'expectedSalary: $expectedSalary, cv: $cv, status: $status, created_at: $createdAt}';
  }
}
