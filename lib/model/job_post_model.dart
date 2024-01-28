import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostModel {
  String id;
  int companyId;
  int categoryId;
  int cityId;
  String jobTitle;
  String description;
  String email;
  String jobType;
  String? salaryRange;
  String? careerLevel;
  String? experience;
  String? gender;
  String qualification;
  String? facility;
  String applicationDeadline;
  String? image;
  String address;
  String? mapLink;
  String status;

  JobPostModel({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.cityId,
    required this.jobTitle,
    required this.description,
    required this.email,
    required this.jobType,
    this.salaryRange,
    this.careerLevel,
    this.experience,
    this.gender,
    required this.qualification,
    this.facility,
    required this.applicationDeadline,
    this.image,
    required this.address,
    this.mapLink,
    required this.status,
  });

  factory JobPostModel.fromMap(Map<String, dynamic> map) {
    return JobPostModel(
      id: map['id'],
      companyId: map['company_id'],
      categoryId: map['category_id'],
      cityId: map['city_id'],
      jobTitle: map['job_title'],
      description: map['description'],
      email: map['email'],
      jobType: map['job_type'],
      salaryRange: map['salary_range'],
      careerLevel: map['career_level'],
      experience: map['experience'],
      gender: map['gender'],
      qualification: map['qualification'],
      facility: map['facility'],
      applicationDeadline: map['application_deadline'],
      image: map['image'],
      address: map['address'],
      mapLink: map['map_link'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'category_id': categoryId,
      'city_id': cityId,
      'job_title': jobTitle,
      'description': description,
      'email': email,
      'job_type': jobType,
      'salary_range': salaryRange,
      'career_level': careerLevel,
      'experience': experience,
      'gender': gender,
      'qualification': qualification,
      'facility': facility,
      'application_deadline': applicationDeadline,
      'image': image,
      'address': address,
      'map_link': mapLink,
      'status': status,
    };
  }

  factory JobPostModel.fromFirebaseDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JobPostModel.fromMap(data);
  }

  @override
  String toString() {
    return 'JobModel{id: $id, companyId: $companyId, categoryId: $categoryId, cityId: $cityId, jobTitle: $jobTitle, description: $description, email: $email, jobType: $jobType, salaryRange: $salaryRange, careerLevel: $careerLevel, experience: $experience, gender: $gender, qualification: $qualification, facility: $facility, applicationDeadline: $applicationDeadline, image: $image, address: $address, mapLink: $mapLink, status: $status}';
  }
}
