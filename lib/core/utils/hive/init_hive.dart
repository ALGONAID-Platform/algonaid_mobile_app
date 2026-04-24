import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart'; // New Import

import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart'; // New Import

import 'package:hive/hive.dart';

Future<void> initHive() async {
  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(TeacherModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ModuleModelAdapter()); // New Registration
  Hive.registerAdapter(LessonModelAdapter()); // New Registration

  await Hive.openBox(AppConstants.boxAuthTokenName);
  await Hive.openBox<CourseModel>(AppConstants.boxCourses);
  await Hive.openBox<CourseModel>(AppConstants.boxMyCourses);
  await _openBoxSafely<ModuleModel>(AppConstants.boxModules);
  await _openBoxSafely<LessonModel>(AppConstants.boxLessons);
  await _openBoxSafely<String>(AppConstants.boxLessonDetails);
}

Future<Box<T>> _openBoxSafely<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } catch (_) {
    await Hive.deleteBoxFromDisk(name);
    return Hive.openBox<T>(name);
  }
}
