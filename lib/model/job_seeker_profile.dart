import 'package:cloud_firestore/cloud_firestore.dart';

class JobSeekerProfile {
  String id;
  String? profileImage;
  String? coverImage;
  String? cv;
  String? currentSalary;
  String? expectedSalary;
  DateTime birthDate;
  String? educationId;
  List<String> languages;
  String? description;
  String address;
  String status;

  JobSeekerProfile({
    required this.id,
    this.profileImage,
    this.coverImage,
    this.cv,
    this.currentSalary,
    this.expectedSalary,
    required this.birthDate,
    required this.educationId,
    required this.languages,
    this.description,
    required this.address,
    required this.status,
  });

  // Factory method to create UserProfile object from a Firestore document snapshot
  factory JobSeekerProfile.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return JobSeekerProfile(
      id: snapshot.id,
      profileImage: data['profile_image'] ?? '',
      coverImage: data['cover_image'] ?? '',
      cv: data['cv'] ?? '',
      currentSalary: data['current_salary'] ?? '',
      expectedSalary: data['expected_salary'] ?? '',
      birthDate: (data['birth_date'] as Timestamp).toDate(),
      educationId: data['education_id'] ?? '',
      languages: List<String>.from(data['languages'] ?? []),
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
