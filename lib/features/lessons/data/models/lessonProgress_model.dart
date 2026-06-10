// موديل فرعي للتعامل مع بيانات التقدم
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lessonProgress_entity.dart';
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      isCompleted: json['isCompleted'] == true || json['is_completed'] == true,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : (json['completed_at'] != null
                ? DateTime.tryParse(json['completed_at'].toString())
                : null),
      studentId:
          int.tryParse(
            json['studentId']?.toString() ??
                json['student_id']?.toString() ??
                '0',
          ) ??
          0,
      lessonId:
          int.tryParse(
            json['lessonId']?.toString() ??
                json['lesson_id']?.toString() ??
                '0',
          ) ??
          0,
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
