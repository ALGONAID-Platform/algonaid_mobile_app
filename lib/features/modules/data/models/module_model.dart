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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      courseId: int.tryParse(json['courseId']?.toString() ?? json['course_id']?.toString() ?? '0') ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.where((e) => e != null)
              .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completedLessons: int.tryParse(json['completedLessons']?.toString() ?? json['completed_lessons']?.toString() ?? '0') ?? 0,
      progressPercentage: double.tryParse(json['progressPercentage']?.toString() ?? json['progress_percentage']?.toString() ?? '0.0') ?? 0.0,
      totalLessons: int.tryParse(json['totalLessons']?.toString() ?? json['total_lessons']?.toString() ?? '0') ?? 0,
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
