import 'package:hive/hive.dart'; // 🌟
import 'package:algonaid_mobail_app/features/courses/domain/entities/user_entity.dart';

part 'user_model.g.dart'; // 🌟

@HiveType(typeId: 3) // 🌟 اختر رقم فريد
class UserModel extends UserEntity {
  @HiveField(0) // 🌟
  final String name;

  @HiveField(1) // 🌟
  final String email;

  UserModel({required this.name, required this.email})
    : super(name: name, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  UserEntity toEntity() => UserEntity(name: name, email: email);

  // دالة مساعدة للتحويل من Entity لموديل عند الكاش
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(name: entity.name, email: entity.email);
  }
}
