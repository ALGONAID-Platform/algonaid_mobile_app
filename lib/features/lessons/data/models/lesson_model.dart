import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.moduleId,
    required super.title,
    required super.order,
    super.description,
    super.videoUrl,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? 0,
      moduleId: json['moduleId'] ?? 0,
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      order: json['order'] ?? 0,
      videoUrl: json['videoUrl']?.toString(),
    );
  }
}
