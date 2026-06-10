import 'dart:convert';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LessonDetailLocalDataSource {
  Future<void> saveLessonDetail(LessonDetailModel lessonDetail);
  LessonDetailModel? getLessonDetail(int lessonId);
}

class LessonDetailLocalDataSourceImpl implements LessonDetailLocalDataSource {
  @override
  LessonDetailModel? getLessonDetail(int lessonId) {
    try {
      final box = Hive.box<String>(AppConstants.boxLessonDetails);
      final raw = box.get(lessonId.toString());
      if (raw != null && raw.isNotEmpty) {
        return LessonDetailModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } catch (_) {}

    // Fallback: Try to construct a basic LessonDetail from LessonModel in Hive box
    try {
      final boxLessons = Hive.box<LessonModel>(AppConstants.boxLessons);
      for (final lesson in boxLessons.values) {
        if (lesson.id == lessonId) {
          return LessonDetailModel(
            id: lesson.id,
            moduleId: lesson.moduleId,
            title: lesson.title,
            order: lesson.order,
            description: lesson.description,
            videoUrl: lesson.videoUrl,
            pdfUrl: lesson.pdfUrl,
          );
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<void> saveLessonDetail(LessonDetailModel lessonDetail) async {
    final box = Hive.box<String>(AppConstants.boxLessonDetails);
    await box.put(
      lessonDetail.id.toString(),
      jsonEncode(lessonDetail.toJson()),
    );
  }
}
