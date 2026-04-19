import 'package:algonaid_mobail_app/features/courses/domain/entities/teacher_entity.dart';

class CourseEntity {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int instructorId;
  final TeacherEntity teacher;
  final List<String> moduleTitles;
  final int modulesCount;
  final bool isEnrolled;

  CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
    required this.instructorId,
    required this.teacher,
    required this.moduleTitles,
    required this.modulesCount,
    required this.isEnrolled,
  });
}
