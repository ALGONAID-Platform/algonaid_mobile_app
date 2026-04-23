import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lessonProgress_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lessonProgress_entity.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    super.videoUrl,
    super.pdfUrl,
    required super.moduleId,
    required super.order,
    super.lessonProgress,
    required super.status,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final progressRaw = json['lessonProgress'] as List<dynamic>?;
    final progressList = progressRaw
        ?.map((e) => LessonProgressModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final calculatedStatus = _determineStatus(progressList);

    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      moduleId: json['moduleId'] as int,
      order: json['order'] as int,
      lessonProgress: progressList,
      status: calculatedStatus,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'moduleId': moduleId,
      'order': order,
      // تحويل التقدم مرة أخرى إلى JSON
      'lessonProgress': lessonProgress
          ?.map((e) => (e as LessonProgressModel).toJson())
          .toList(),
    };
  }

  static LessonStatus _determineStatus(List<LessonProgress>? progress) {
    if (progress == null || progress.isEmpty) {
      return LessonStatus.notStarted;
    }

    return progress.first.isCompleted
        ? LessonStatus.completed
        : LessonStatus.inProgress;
  }
}
