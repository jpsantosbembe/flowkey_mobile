class AuthorizationModel {
  final int id;
  final int keyId;
  final int userId;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final UserModel user;

  AuthorizationModel({
    required this.id,
    required this.keyId,
    required this.userId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationModel(
      id: json['id'],
      keyId: json['key_id'],
      userId: json['user_id'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
