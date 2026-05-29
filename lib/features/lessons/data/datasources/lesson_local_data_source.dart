import 'dart:convert';

import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LessonLocalDataSource {
  Future<void> saveLessons(int moduleId, List<LessonModel> lessons);
  List<LessonModel> getLessons(int moduleId);
  Future<void> clearLessons(int moduleId);
  Future<void> saveLessonDetail(LessonDetailModel lessonDetail);
  LessonDetailModel? getLessonDetail(int lessonId);
}

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  @override
  List<LessonModel> getLessons(int moduleId) {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    return box.values.where((lesson) => lesson.moduleId == moduleId).toList();
  }

  @override
  Future<void> saveLessons(int moduleId, List<LessonModel> lessons) async {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    await clearLessons(moduleId);
    await box.addAll(lessons);
  }

  @override
  Future<void> clearLessons(int moduleId) async {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    final keysToDelete = box.keys.where((key) {
      final lesson = box.get(key);
      return lesson?.moduleId == moduleId;
    }).toList();

    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }

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

    // Fallback: Try to construct a basic LessonDetail from LessonModel
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
