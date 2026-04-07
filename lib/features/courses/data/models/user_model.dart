
import 'package:algonaid_mobail_app/features/courses/domain/entities/user_entity.dart';


class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  // دالة لتحويل الـ Model إلى Entity النقي لضمان استقلالية طبقة الـ Domain
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
    );
  }
}