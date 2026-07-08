import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lessonProgress_model.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lessonProgress_entity.dart';
import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 4) // Starting from 4 as per instructions
class LessonModel extends Lesson {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final int moduleId;
  @override
  @HiveField(4)
  final int order;
  @override
  @HiveField(5)
  final List<LessonProgress>? lessonProgress;
  @override
  @HiveField(6)
  final LessonStatus status;
  @override
  @HiveField(7)
  final String? content;
  @override
  @HiveField(8)
  final bool isReading;
  @override
  @HiveField(9)
  final bool hasExam;
  @override
  @HiveField(10)
  final bool hasTest;
  @override
  @HiveField(11)
  final String? videoUrl;
  @override
  @HiveField(12)
  final String? pdfUrl;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    required this.moduleId,
    required this.order,
    this.lessonProgress,
    required this.status,
    this.content,
    this.isReading = false,
    this.hasExam = false,
    this.hasTest = false,
  }) : super(
         id: id,
         title: title,
         description: description,
         videoUrl: videoUrl,
         pdfUrl: pdfUrl,
         moduleId: moduleId,
         order: order,
         lessonProgress: lessonProgress,
         status: status,
         content: content,
         isReading: isReading,
         hasExam: hasExam,
         hasTest: hasTest,
       );

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
      moduleId:
          int.tryParse(
            json['moduleId']?.toString() ??
                json['module_id']?.toString() ??
                '0',
          ) ??
          0,
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      lessonProgress: progressList,
      status: calculatedStatus,
      content: json['content']?.toString(),
      isReading: json['isReading'] == true || 
                 json['is_reading'] == true || 
                 json['isReading'] == 1 || 
                 json['is_reading'] == 1,
      hasExam: json['hasExam'] == true || 
               json['has_exam'] == true || 
               json['exam'] != null || 
               json['examId'] != null || 
               json['exam_id'] != null ||
               (json['exams'] != null && (json['exams'] as List).isNotEmpty),
      hasTest: json['hasTest'] == true || json['has_test'] == true,
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
      'content': content,
      'isReading': isReading,
      'hasExam': hasExam,
      'hasTest': hasTest,
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
