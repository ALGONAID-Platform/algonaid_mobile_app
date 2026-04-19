import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LessonLocalDataSource {
  Future<void> saveLessons(List<LessonModel> lessons);
  List<LessonModel> getLessons(int moduleId);
}

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  @override
  List<LessonModel> getLessons(int moduleId) {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    return box.values.where((lesson) => lesson.moduleId == moduleId).toList();
  }

  @override
  Future<void> saveLessons(List<LessonModel> lessons) async {
    final box = Hive.box<LessonModel>(AppConstants.boxLessons);
    await box.clear(); // Clear existing lessons to ensure fresh data
    await box.addAll(lessons);
  }
}
