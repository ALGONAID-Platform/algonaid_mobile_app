// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';

class AuthResponse {
  final String statusCode;
  final String message;
  final AuthDataModel data;
  AuthResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: AuthDataModel.fromJson(json['data']),
    );
  }
}

class AuthDataModel {
  final UserModel user;
  final String accessToken;
  AuthDataModel({required this.user, required this.accessToken});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id, // هنا قمنا بتحويل int إلى String لراحة الـ Domain
      username: name,
      email: email,
      role: role,
    );
  }
}
