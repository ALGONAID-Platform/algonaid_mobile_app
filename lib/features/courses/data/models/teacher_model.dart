
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart' show UserModel;
import 'package:algonaid_mobail_app/features/courses/domain/entities/teacher_entity.dart';

class TeacherModel extends TeacherEntity {
  TeacherModel({
    required super.id,
    required super.specialization,
    super.bio,
    required super.experience,
    required super.userId,
    required super.user,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialization': specialization,
      'bio': bio,
      'experience': experience,
      'userId': userId,
      'user': (user as UserModel).toJson(),
    };
  }

  TeacherEntity toEntity() {
    return TeacherEntity(
      id: id,
      specialization: specialization,
      bio: bio,
      experience: experience,
      userId: userId,
      user: (user as UserModel).toEntity(),
    );
  }
}