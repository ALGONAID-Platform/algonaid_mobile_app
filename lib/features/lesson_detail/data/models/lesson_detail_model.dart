import 'package:algonaid_mobile_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';

class LessonDetailModel {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final ExamModel? exam;
  final bool isReading;
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
    this.isReading = false,
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      moduleId:
          (json['moduleId'] as num?)?.toInt() ??
          (json['module_id'] as num?)?.toInt() ??
          0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      content: json['content'] as String?,
      videoUrl: json['videoUrl'] as String? ?? json['video_url'] as String?,
      pdfUrl: json['pdfUrl'] as String? ?? json['pdf_url'] as String?,
      exam: json['exam'] != null
          ? ExamModel.fromJson(json['exam'] as Map<String, dynamic>)
          : null,
      isReading: json['isReading'] == true || 
                 json['is_reading'] == true || 
                 json['isReading'] == 1 || 
                 json['is_reading'] == 1 ||
                 ((json['videoUrl']?.toString() ?? json['video_url']?.toString() ?? '').isEmpty),
      order: (json['order'] as num?)?.toInt() ?? 0,
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
      'isReading': isReading,
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
      isReading: isReading,
      order: order,
    );
  }
}
