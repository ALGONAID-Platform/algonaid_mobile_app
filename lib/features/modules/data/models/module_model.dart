import 'package:algonaid/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid/features/modules/domain/entities/module.dart';
import 'package:hive/hive.dart';

part 'module_model.g.dart';

@HiveType(typeId: 13)
class ModuleModel extends Module {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final int courseId;
  @override
  @HiveField(4)
  final List<Lesson> lessons;
  @override
  @HiveField(5)
  final int completedLessons;
  @override
  @HiveField(6)
  final double progressPercentage;
  @override
  @HiveField(7)
  final int totalLessons;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.lessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
  }) : super(
         id: id,
         title: title,
         description: description,
         courseId: courseId,
         lessons: lessons,
         completedLessons: completedLessons,
         progressPercentage: progressPercentage,
         totalLessons: totalLessons,
       );

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
