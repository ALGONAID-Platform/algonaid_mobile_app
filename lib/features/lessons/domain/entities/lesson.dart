import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:equatable/equatable.dart';
// استيراد الـ Enum الخاص بك
// import 'package:algonaid_mobail_app/core/enums/lesson_status.dart';

class Lesson extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;
  final int moduleId;
  final int order;
  final List<LessonProgress>? lessonProgress;
  final LessonStatus status; 

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    required this.moduleId,
    required this.order,
    this.lessonProgress,
    required this.status, // إضافة المتطلب هنا
  });

  @override
  List<Object?> get props => [id, title, description, videoUrl, pdfUrl, moduleId, order, lessonProgress, status];
}