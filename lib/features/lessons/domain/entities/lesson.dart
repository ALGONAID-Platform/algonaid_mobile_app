import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:equatable/equatable.dart';
// استيراد الـ Enum الخاص بك
// import 'package:algonaid_mobile_app/core/enums/lesson_status.dart';

class Lesson extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;
  final String? content;
  final bool isReading;
  final int moduleId;
  final int order;
  final List<LessonProgress>? lessonProgress;
  final LessonStatus status;
  final bool hasExam;
  final bool hasTest;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    this.content,
    this.isReading = false,
    required this.moduleId,
    required this.order,
    this.lessonProgress,
    required this.status, 
    this.hasExam = false,
    this.hasTest = false,
  });

  Lesson copyWith({
    int? id,
    String? title,
    String? description,
    String? videoUrl,
    String? pdfUrl,
    String? content,
    bool? isReading,
    int? moduleId,
    int? order,
    List<LessonProgress>? lessonProgress,
    LessonStatus? status,
    bool? hasExam,
    bool? hasTest,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      content: content ?? this.content,
      isReading: isReading ?? this.isReading,
      moduleId: moduleId ?? this.moduleId,
      order: order ?? this.order,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      status: status ?? this.status,
      hasExam: hasExam ?? this.hasExam,
      hasTest: hasTest ?? this.hasTest,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        videoUrl,
        pdfUrl,
        content,
        isReading,
        moduleId,
        order,
        lessonProgress,
        status,
        hasExam,
        hasTest,
      ];
}
