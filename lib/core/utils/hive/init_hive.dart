import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobile_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobile_app/features/courses/data/models/user_model.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/module_model.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/last_accessed_module_model.dart';

import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart'; // New Import

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
Future<void> clearAllUserHiveData() async {
  try {
    if (Hive.isBoxOpen(AppConstants.boxCourses)) await Hive.box<CourseModel>(AppConstants.boxCourses).clear();
    if (Hive.isBoxOpen(AppConstants.boxMyCourses)) await Hive.box<CourseModel>(AppConstants.boxMyCourses).clear();
    if (Hive.isBoxOpen(AppConstants.boxModules)) await Hive.box<ModuleModel>(AppConstants.boxModules).clear();
    if (Hive.isBoxOpen(AppConstants.boxLessons)) await Hive.box<LessonModel>(AppConstants.boxLessons).clear();
    if (Hive.isBoxOpen(AppConstants.boxLessonDetails)) await Hive.box<String>(AppConstants.boxLessonDetails).clear();

    if (Hive.isBoxOpen(AppConstants.boxLastAccessedModule)) await Hive.box<LastAccessedModuleModel>(AppConstants.boxLastAccessedModule).clear();

    // Removed clearing local_notifications_box so each user keeps their notifications
    if (Hive.isBoxOpen('user_exam_attempts')) await Hive.box<String>('user_exam_attempts').clear();
    if (Hive.isBoxOpen('module_grades')) await Hive.box<String>('module_grades').clear();
  } catch (e) {
    // Silently ignore if a box is not open or has type mismatch during logout
  }
}
