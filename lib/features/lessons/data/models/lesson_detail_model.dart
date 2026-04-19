import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';

class LessonDetailModel {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final String? exam;
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
      id: json['id'],
      moduleId: json['moduleId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      videoUrl: json['videoUrl'],
      pdfUrl: json['pdfUrl'],
      exam: json['exam'],
      order: json['order'],
    );
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
