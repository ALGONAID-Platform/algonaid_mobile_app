import 'package:algonaid_mobail_app/core/constants/app_constants.dart';

import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<TeacherModel>(TeacherModelAdapter());
    Hive.registerAdapter<CourseModel>(CourseModelAdapter());
    Hive.registerAdapter<LessonModel>(LessonModelAdapter()); // typeId: 4
    Hive.registerAdapter<ModuleModel>(ModuleModelAdapter()); // typeId: 5
    Hive.registerAdapter<ExamModel>(ExamModelAdapter()); // typeId: 6
    Hive.registerAdapter<QuestionModel>(QuestionModelAdapter()); // typeId: 7
    Hive.registerAdapter<QuestionOptionModel>(
      QuestionOptionModelAdapter(),
    ); // typeId: 8
    Hive.registerAdapter<ExamResultModel>(
      ExamResultModelAdapter(),
    ); // typeId: 9

    await Hive.openBox(AppConstants.boxAuthTokenName);
    await Hive.openBox<CourseModel>(AppConstants.boxCourses);
    await Hive.openBox<CourseModel>(AppConstants.boxMyCourses);
    await Hive.openBox<LessonModel>(AppConstants.boxLessons);
    await Hive.openBox<ModuleModel>(AppConstants.boxModules);
    await Hive.openBox<ExamModel>(AppConstants.boxExams);
    await Hive.openBox<ExamResultModel>(AppConstants.boxExamResults);
  }
}
