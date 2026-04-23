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
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;

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
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
  });

  CourseEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? thumbnail,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? instructorId,
    TeacherEntity? teacher,
    List<String>? moduleTitles,
    int? modulesCount,
    bool? isEnrolled,
    int? totalLessons,
    int? completedLessons,
    double? progressPercentage,
  }) {
    return CourseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      instructorId: instructorId ?? this.instructorId,
      teacher: teacher ?? this.teacher,
      moduleTitles: moduleTitles ?? this.moduleTitles,
      modulesCount: modulesCount ?? this.modulesCount,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }
}
