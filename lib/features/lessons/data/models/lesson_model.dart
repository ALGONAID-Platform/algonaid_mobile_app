import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lessonProgress_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 4) // Starting from 4 as per instructions
class LessonModel extends Lesson {
  const LessonModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.title,
    @HiveField(2) required super.description,
    super.videoUrl, // Exclude from Hive storage
    super.pdfUrl, // Exclude from Hive storage
    @HiveField(3) required super.moduleId,
    @HiveField(4) required super.order,
    @HiveField(5) required super.lessonProgress,
    @HiveField(6) required super.status,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final progressRaw =
        json['lessonProgress'] as List<dynamic>? ??
        json['lesson_progress'] as List<dynamic>?;
    final progressList = progressRaw
        ?.map((e) => LessonProgressModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final calculatedStatus = _determineStatus(progressList);

    return LessonModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? json['video_url']?.toString(),
      pdfUrl: json['pdfUrl']?.toString() ?? json['pdf_url']?.toString(),
      moduleId: int.tryParse(json['moduleId']?.toString() ?? json['module_id']?.toString() ?? '0') ?? 0,
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      lessonProgress: progressList,
      status: calculatedStatus,
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
