import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';

class AuthResponse {
  final String message;
  final UserModel user;
  final String accessToken;

  AuthResponse({
    required this.message,
    required this.user,
    required this.accessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? "",
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'] ?? "",
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final String? background;
  final String? academicId;
  final String? grade;
  final String? birthDate;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.background,
    this.academicId,
    this.grade,
    this.birthDate,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      // تحويل النص القادم من السيرفر (ADMIN) إلى Enum
      role: UserRole.values.firstWhere(
        (e) =>
            e.name.toUpperCase() ==
            (json['role'] ?? "").toString().toUpperCase(),
        orElse: () => UserRole.student,
      ),
      avatar: json['avatar'],
      background: json['background'],
      academicId: json['academicId'],
      grade: json['grade'],
      birthDate: json['birthDate'],
      address: json['address'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
