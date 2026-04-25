// موديل فرعي للتعامل مع بيانات التقدم
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:hive/hive.dart';

part 'lessonProgress_model.g.dart'; // the command in cmd: flutter packages pub run build_runner build --delete-conflicting-outputs

class LessonProgressModel extends LessonProgress {
  const LessonProgressModel({
    required super.id,
    required super.isCompleted,
    super.completedAt,
    required super.studentId,
    required super.lessonId,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      id: json['id'] as int,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      studentId: json['studentId'] as int,
      lessonId: json['lessonId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'studentId': studentId,
      'lessonId': lessonId,
    };
  }
}
