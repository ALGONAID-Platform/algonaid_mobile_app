import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';

class LessonDetailModel extends LessonDetail {
  const LessonDetailModel({
    required super.id,
    required super.moduleId,
    required super.title,
    required super.order,
    super.description,
    super.content,
    super.videoUrl,
    super.pdfUrl,
    super.exam,
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: json['id'] ?? 0,
      moduleId: json['moduleId'] ?? 0,
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      content: json['content']?.toString(),
      videoUrl: json['videoUrl']?.toString(),
      pdfUrl: json['pdfUrl']?.toString(),
      exam: json['exam']?.toString(),
      order: json['order'] ?? 0,
    );
  }
}
