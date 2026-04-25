import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/courseProgress_model.dart';

import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lessonProgress_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/last_accessed_module_model.dart'; // Added
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<TeacherModel>(TeacherModelAdapter());
    Hive.registerAdapter<CourseModel>(CourseModelAdapter());
    Hive.registerAdapter<LastAccessedModuleModel>(LastAccessedModuleModelAdapter()); // Added
     Hive.registerAdapter<CourseProgressModel>(CourseProgressModelAdapter());
    Hive.registerAdapter<LessonModel>(LessonModelAdapter()); // typeId: 4
    Hive.registerAdapter<ModuleModel>(ModuleModelAdapter()); // typeId: 13
    Hive.registerAdapter<ExamModel>(ExamModelAdapter()); // typeId: 6
    Hive.registerAdapter<QuestionModel>(QuestionModelAdapter()); // typeId: 7
    Hive.registerAdapter<OptionModel>(OptionModelAdapter()); // typeId: 8
    Hive.registerAdapter<ExamAttemptModel>(ExamAttemptModelAdapter()); // typeId: 9
    Hive.registerAdapter<LessonProgressModel>(LessonProgressModelAdapter()); // typeId: 9
    Hive.registerAdapter<ExamResultModel>(
      ExamResultModelAdapter(),
    ); // typeId: 10

    await Hive.openBox(AppConstants.boxAuthTokenName);
    await Hive.openBox<CourseModel>(AppConstants.boxCourses);
    await Hive.openBox<CourseModel>(AppConstants.boxMyCourses);
    await Hive.openBox<LastAccessedModuleModel>(AppConstants.boxLastAccessedModule); // Added
     await Hive.openBox<CourseProgressModel>(AppConstants.boxCourseProgress);
    await Hive.openBox<LessonModel>(AppConstants.boxLessons);
    await Hive.openBox<String>(AppConstants.boxLessonDetails);
    await Hive.openBox<ModuleModel>(AppConstants.boxModules);
    await Hive.openBox<LessonProgressModel>(AppConstants.boxLessonProgress);
    await Hive.openBox<String>(AppConstants.boxReadingProgress);
    await Hive.openBox<ExamModel>(AppConstants.boxExams);
    await Hive.openBox<ExamResultModel>(AppConstants.boxExamResults);
  }
}
