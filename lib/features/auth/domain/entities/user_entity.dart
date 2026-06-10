// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobile_app/core/common/enums/user_role.dart';

class UserEntity {
  int id;
  String username;
  String email;
  UserRole role;
  String message;
  final String? token;
  final String? avatar;
  final String? background;
  final String? academicId;
  final String? grade;
  final String? birthDate;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.message,
    this.token,
    this.avatar,
    this.background,
    this.academicId,
    this.grade,
    this.birthDate,
    this.address,
    this.createdAt,
    this.updatedAt,
  });
}
