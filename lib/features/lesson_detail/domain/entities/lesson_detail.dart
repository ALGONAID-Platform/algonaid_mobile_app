import 'package:algonaid/features/exams/domain/entities/exam_entities.dart';
import 'package:equatable/equatable.dart';

class LessonDetail extends Equatable {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final Exam? exam;
  final bool isReading;

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
    this.isReading = false,
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
        isReading,
        order,
      ];
}
