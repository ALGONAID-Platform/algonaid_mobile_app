import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';

class ModuleModel extends Module {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.courseId,
    required super.lessons,
    required super.completedLessons,
    required super.progressPercentage,
    required super.totalLessons,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      courseId: json['courseId'] as int? ?? 0,

      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,

      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,

      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'lessons': lessons.map((e) => (e as LessonModel).toJson()).toList(),
      'completedLessons': completedLessons,
      'progressPercentage': progressPercentage,
      'totalLessons': totalLessons,
    };
  }
}
