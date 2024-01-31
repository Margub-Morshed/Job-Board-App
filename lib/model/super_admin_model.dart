import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminModel {
  String id;
  String username;
  String name;
  String email;
  String phoneNumber;
  String userAvatar;
  String coverImage;
  String userAvatarName;
  String coverImageName;
  String password;
  String role;

  SuperAdminModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.userAvatar = '',
    this.coverImage = '',
    required this.userAvatarName,
    required this.coverImageName,
    required this.password,
    required this.role,
  });

  factory SuperAdminModel.fromMap(Map<String, dynamic> data) {
    return SuperAdminModel(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      userAvatar: data['user_avatar'] ?? '',
      coverImage: data['cover_image'] ?? '',
      userAvatarName: data['user_avatar_name'] ?? '',
      coverImageName: data['cover_image_name'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'user_avatar': userAvatar,
      'cover_image': coverImage,
      'user_avatar_name': userAvatarName,
      'cover_image_name': coverImageName,
      'password': password,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'SuperAdminModel{id: $id, username: $username, name: $name, email: $email, '
        'phone_number: $phoneNumber, user_avatar: $userAvatar, cover_image: $coverImage, '
        'user_avatar_name: $userAvatarName, cover_image_name: $coverImageName, '
        'password: $password, role: $role}';
  }

  factory SuperAdminModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SuperAdminModel.fromMap(data);
  }
}
