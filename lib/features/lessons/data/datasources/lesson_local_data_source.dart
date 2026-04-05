import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LessonLocalDataSource {
  Future<void> cacheLessons(int moduleId, List<Lesson> lessons);
  Future<List<LessonModel>> getCachedLessons(int moduleId);
  Future<void> cacheLessonDetail(LessonDetail lesson);
  Future<LessonDetailModel?> getCachedLessonDetail(int lessonId);
}

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  const LessonLocalDataSourceImpl();

  @override
  Future<void> cacheLessons(int moduleId, List<Lesson> lessons) async {
    final box = await _openBox(AppConstants.boxLessonsCache);
    final data = lessons.map(_lessonToMap).toList();
    await box.put(_moduleKey(moduleId), data);
  }

  @override
  Future<List<LessonModel>> getCachedLessons(int moduleId) async {
    final box = await _openBox(AppConstants.boxLessonsCache);
    final cached = box.get(_moduleKey(moduleId));
    if (cached is List) {
      return cached
          .whereType<Map>()
          .map((item) => LessonModel.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheLessonDetail(LessonDetail lesson) async {
    final box = await _openBox(AppConstants.boxLessonDetailsCache);
    await box.put(lesson.id, _lessonDetailToMap(lesson));
  }

  @override
  Future<LessonDetailModel?> getCachedLessonDetail(int lessonId) async {
    final box = await _openBox(AppConstants.boxLessonDetailsCache);
    final cached = box.get(lessonId);
    if (cached is Map) {
      return LessonDetailModel.fromJson(
        cached.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    return null;
  }

  Future<Box<dynamic>> _openBox(String boxName) async {
    return Hive.isBoxOpen(boxName)
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
  }

  String _moduleKey(int moduleId) => 'module_$moduleId';

  Map<String, dynamic> _lessonToMap(Lesson lesson) {
    return {
      'id': lesson.id,
      'moduleId': lesson.moduleId,
      'title': lesson.title,
      'description': lesson.description,
      'order': lesson.order,
      'videoUrl': lesson.videoUrl,
    };
  }

  Map<String, dynamic> _lessonDetailToMap(LessonDetail lesson) {
    return {
      'id': lesson.id,
      'moduleId': lesson.moduleId,
      'title': lesson.title,
      'description': lesson.description,
      'content': lesson.content,
      'videoUrl': lesson.videoUrl,
      'pdfUrl': lesson.pdfUrl,
      'exam': lesson.exam,
      'order': lesson.order,
    };
  }
}
