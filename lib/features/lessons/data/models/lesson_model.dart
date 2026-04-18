// algonaid_mobail_app/lib/features/lessons/data/models/lesson_model.dart

import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 4) // Starting from 4 as per instructions
class LessonModel extends Lesson {
  const LessonModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.title,
    @HiveField(2) required super.description,
    super.videoUrl, // Exclude from Hive storage
    super.pdfUrl,   // Exclude from Hive storage
    @HiveField(3) required super.moduleId,
    @HiveField(4) required super.order,
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

