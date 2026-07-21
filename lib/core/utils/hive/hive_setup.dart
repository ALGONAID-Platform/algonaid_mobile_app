import 'package:algonaid/core/constants/app_constants.dart';
import 'package:algonaid/features/courses/data/models/courseProgress_model.dart';

import 'package:algonaid/features/courses/data/models/course_model.dart';
import 'package:algonaid/features/courses/data/models/teacher_model.dart';
import 'package:algonaid/features/courses/data/models/user_model.dart';
import 'package:algonaid/features/lessons/data/models/lessonProgress_model.dart';
import 'package:algonaid/features/modules/data/models/last_accessed_module_model.dart'; // Added
import 'package:algonaid/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid/features/modules/data/models/module_model.dart';
import 'package:algonaid/features/exams/data/models/exam_models.dart';

import 'package:algonaid/core/common/enums/lesson_status.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<TeacherModel>(TeacherModelAdapter());
    Hive.registerAdapter<CourseModel>(CourseModelAdapter());
    Hive.registerAdapter<LastAccessedModuleModel>(
      LastAccessedModuleModelAdapter(),
    ); // Added
    Hive.registerAdapter<CourseProgressModel>(CourseProgressModelAdapter());
    Hive.registerAdapter<LessonModel>(LessonModelAdapter()); // typeId: 4
    Hive.registerAdapter<ModuleModel>(ModuleModelAdapter()); // typeId: 13
    Hive.registerAdapter<ExamModel>(ExamModelAdapter()); // typeId: 6
    Hive.registerAdapter<QuestionModel>(QuestionModelAdapter()); // typeId: 7
    Hive.registerAdapter<OptionModel>(OptionModelAdapter()); // typeId: 8
    Hive.registerAdapter<ExamAttemptModel>(
      ExamAttemptModelAdapter(),
    ); // typeId: 9
    Hive.registerAdapter<LessonProgressModel>(
      LessonProgressModelAdapter(),
    ); // typeId: 9
    Hive.registerAdapter<ExamResultModel>(
      ExamResultModelAdapter(),
    ); // typeId: 10
    Hive.registerAdapter<LessonStatus>(LessonStatusAdapter()); // typeId: 20

    await _safeOpenBox(AppConstants.boxAuthTokenName);
    await _safeOpenBox<CourseModel>(AppConstants.boxCourses);
    await _safeOpenBox<CourseModel>(AppConstants.boxMyCourses);
    await _safeOpenBox<LastAccessedModuleModel>(
      AppConstants.boxLastAccessedModule,
    ); // Added
    await _safeOpenBox<CourseProgressModel>(AppConstants.boxCourseProgress);
    await _safeOpenBox<LessonModel>(AppConstants.boxLessons);
    await _safeOpenBox<String>(AppConstants.boxLessonDetails);
    await _safeOpenBox<ModuleModel>(AppConstants.boxModules);
    await _safeOpenBox<LessonProgressModel>(AppConstants.boxLessonProgress);
    await _safeOpenBox<String>(AppConstants.boxReadingProgress);
    await _safeOpenBox<ExamModel>(AppConstants.boxExams);
    await _safeOpenBox<ExamResultModel>(AppConstants.boxExamResults);
  }

  static Future<Box<T>> _safeOpenBox<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName);
    }
  }
}
