// موديل فرعي للتعامل مع بيانات التقدم
import 'package:algonaid/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:hive/hive.dart';

part 'lessonProgress_model.g.dart'; // the command in cmd: flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 11)
class LessonProgressModel extends LessonProgress {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final bool isCompleted;
  @override
  @HiveField(2)
  final DateTime? completedAt;
  @override
  @HiveField(3)
  final int studentId;
  @override
  @HiveField(4)
  final int lessonId;

  const LessonProgressModel({
    required this.id,
    required this.isCompleted,
    this.completedAt,
    required this.studentId,
    required this.lessonId,
  }) : super(
         id: id,
         isCompleted: isCompleted,
         completedAt: completedAt,
         studentId: studentId,
         lessonId: lessonId,
       );

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
