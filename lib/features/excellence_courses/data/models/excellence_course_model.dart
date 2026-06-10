import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';

class ExcellenceCourseModel extends ExcellenceCourseEntity {
  const ExcellenceCourseModel({
    required super.courseId,
    required super.courseTitle,
    required super.courseImage,
    required super.averagePercentage,
    required super.completedAt,
    required super.isCompleted,
  });

  factory ExcellenceCourseModel.fromJson(Map<String, dynamic> json) {
    return ExcellenceCourseModel(
      courseId: json['courseId'] ?? 0,
      courseTitle: json['courseTitle'] ?? '',
      courseImage: json['courseImage'] ?? '',
      averagePercentage: json['averagePercentage'] ?? 0.0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'courseImage': courseImage,
      'averagePercentage': averagePercentage,
      'completedAt': completedAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
