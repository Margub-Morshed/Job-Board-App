import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String? name;
  String email;
  String? phoneNumber;
  String? userAvatar;
  String? coverImage;
  String password;
  String role;

  UserModel({
    required this.id,
    required this.username,
    this.name,
    required this.email,
    this.phoneNumber,
    this.userAvatar,
    this.coverImage,
    required this.password,
    required this.role,
  });

  // Factory method to create UserModel object from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      userAvatar: map['user_avatar'] ?? '',
      coverImage: map['cover_image'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }

  // Convert UserModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'user_avatar': userAvatar,
      'cover_image': coverImage,
      'password': password,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, name: $name, email: $email, phoneNumber: $phoneNumber, userAvatar: $userAvatar, coverImage: $coverImage, password: $password, role: $role}';
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }
}
