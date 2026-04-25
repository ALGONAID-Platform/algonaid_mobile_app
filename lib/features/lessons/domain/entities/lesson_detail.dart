import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:equatable/equatable.dart';

class LessonDetail extends Equatable {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final Exam? exam; // Changed from String? to Exam?
  final int order;

  const LessonDetail({
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

  @override
  List<Object?> get props => [
        id,
        moduleId,
        title,
        description,
        content,
        videoUrl,
        pdfUrl,
        exam,
        order,
      ];
}
