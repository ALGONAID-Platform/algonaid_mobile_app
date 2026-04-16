
import 'package:algonaid_mobail_app/features/courses/domain/entities/user_entity.dart';

class TeacherEntity {
  final int id;
  final String specialization;
  final String? bio; // يمكن أن يكون null كما هو موضح في الـ JSON
  final int experience;
  final int userId;
  final UserEntity user;

  TeacherEntity({
    required this.id,
    required this.specialization,
    this.bio,
    required this.experience,
    required this.userId,
    required this.user,
  });
}