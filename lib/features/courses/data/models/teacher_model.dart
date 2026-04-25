import 'package:hive/hive.dart'; // 🌟
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart'
    show UserModel;
import 'package:algonaid_mobail_app/features/courses/domain/entities/teacher_entity.dart';

part 'teacher_model.g.dart'; // 🌟

@HiveType(typeId: 2) // 🌟 اختر رقم فريد (مثلاً 2)
class TeacherModel extends TeacherEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String specialization;
  @HiveField(2)
  final String? bio;
  @HiveField(3)
  final int experience;
  @HiveField(4)
  final int userId;
  @HiveField(5)
  final UserModel user;

  TeacherModel({
    required this.id,
    required this.specialization,
    this.bio,
    required this.experience,
    required this.userId,
    required this.user,
  }) : super(
         id: id,
         specialization: specialization,
         bio: bio,
         experience: experience,
         userId: userId,
         user: user,
       );

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as int,
      specialization: json['specialization'] as String,
      bio: json['bio'] as String?,
      experience: json['experience'] as int,
      userId: json['userId'] as int,
      user: UserModel.fromJson(json['user']),
    );
  }

  factory TeacherModel.fromEntity(TeacherEntity entity) {
    return TeacherModel(
      id: entity.id,
      specialization: entity.specialization,
      bio: entity.bio,
      experience: entity.experience,
      userId: entity.userId,
      user: UserModel.fromEntity(entity.user),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialization': specialization,
      'bio': bio,
      'experience': experience,
      'userId': userId,
      'user': user.toJson(),
    };
  }

  TeacherEntity toEntity() {
    return TeacherEntity(
      id: id,
      specialization: specialization,
      bio: bio,
      experience: experience,
      userId: userId,
      user: user.toEntity(),
    );
  }
}
