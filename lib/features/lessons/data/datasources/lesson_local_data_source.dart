import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LessonLocalDataSource {
  Future<void> saveLessons(int moduleId, List<LessonModel> lessons);
  List<LessonModel> getLessons(int moduleId);
  Future<void> clearLessons(int moduleId);
}

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  @override
  List<LessonModel> getLessons(int moduleId) {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    final lessons = box.values
        .where((lesson) => lesson.moduleId == moduleId)
        .toList();
    lessons.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.id.compareTo(b.id);
    });
    return lessons;
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
}
