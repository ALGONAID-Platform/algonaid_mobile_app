// algonaid_mobail_app/lib/features/lessons/data/models/lesson_model.dart

import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    super.videoUrl,
    super.pdfUrl,
    required super.moduleId,
    required super.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      moduleId: json['moduleId'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'moduleId': moduleId,
      'order': order,
    };
  }
}
