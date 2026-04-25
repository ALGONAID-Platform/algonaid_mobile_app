import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:hive/hive.dart';

part 'module_model.g.dart';

@HiveType(typeId: 13)
class ModuleModel extends Module {
  const ModuleModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.title,
    @HiveField(2) required super.description,
    @HiveField(3) required super.courseId,
    @HiveField(4) required super.lessons,
    @HiveField(5) required super.completedLessons,
    @HiveField(6) required super.progressPercentage,
    @HiveField(7) required super.totalLessons,
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
