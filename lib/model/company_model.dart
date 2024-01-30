class CompanyModel {
  String id;
  String userId;
  String cityId;
  String password;
  String? logoImage;
  String? coverImage;
  String name;
  String email;
  String phone;
  int teamSize;
  String? socialMediaId;
  String? shortDescription;
  String? longDescription;
  String address;
  CompanyStatus status;
  String? additionalLinksId;
  String role;

  CompanyModel({
    required this.id,
    required this.userId,
    required this.cityId,
    required this.password,
    this.logoImage,
    this.coverImage,
    required this.name,
    required this.email,
    required this.phone,
    required this.teamSize,
    this.socialMediaId,
    this.shortDescription,
    this.longDescription,
    required this.address,
    required this.status,
    this.additionalLinksId,
    required this.role,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> data) {
    return CompanyModel(
      id: data['id'] ?? '', // Make sure to use the correct key for id
      userId: data['user_id'] ?? '',
      cityId: data['city_id'] ?? '',
      password: data['password'] ?? '',
      logoImage: data['logo_image'] ?? '',
      coverImage: data['cover_image'] ?? '',
      name: data['company_name'] ?? '',
      email: data['company_email'] ?? '',
      phone: data['company_phone'] ?? '',
      teamSize: data['team_size'] ?? 0,
      socialMediaId: data['social_media_id'] ?? '',
      shortDescription: data['short_description'] ?? '',
      longDescription: data['long_description'] ?? '',
      address: data['address'] ?? '',
      status: CompanyStatus.values[data['status'] ?? 0],
      additionalLinksId: data['additional_links_id'] ?? '',
      role: data['role'] ?? '',
    );
  }

  // Convert the CompanyModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'user_id': userId,
      'city_id': cityId,
      'password': password,
      'logo_image': logoImage,
      'cover_image': coverImage,
      'company_name': name,
      'company_email': email,
      'company_phone': phone,
      'team_size': teamSize,
      'social_media_id': socialMediaId,
      'short_description': shortDescription,
      'long_description': longDescription,
      'address': address,
      'status': status.index, // Convert enum to index
      'additional_links_id': additionalLinksId,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'CompanyModel{id: $id, userId: $userId, cityId: $cityId, '
        'password: $password, logoImage: $logoImage, coverImage: $coverImage, name: $name, '
        'email: $email, phone: $phone, teamSize: $teamSize, '
        'socialMediaId: $socialMediaId, shortDescription: $shortDescription, '
        'longDescription: $longDescription, address: $address, status: $status, '
        'additionalLinksId: $additionalLinksId, role: $role}';
  }
}

// Enum for CompanyStatus
enum CompanyStatus { active, disabled, suspended }
