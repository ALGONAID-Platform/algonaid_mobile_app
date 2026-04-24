import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';

class LessonDetailModel {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final ExamModel? exam;
  final int order;

  LessonDetailModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    this.description,
    this.content,
    this.videoUrl,
    this.pdfUrl,
    this.exam,
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: json['id'] as int,
      moduleId: json['moduleId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      videoUrl: json['videoUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      exam: json['exam'] != null ? ExamModel.fromJson(json['exam'] as Map<String, dynamic>) : null,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'content': content,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'exam': exam?.toJson(),
      'order': order,
    };
  }

  LessonDetail toEntity() {
    return LessonDetail(
      id: id,
      moduleId: moduleId,
      title: title,
      description: description,
      content: content,
      videoUrl: videoUrl,
      pdfUrl: pdfUrl,
      exam: exam,
      order: order,
    );
  }
}
