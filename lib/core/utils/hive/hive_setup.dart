import 'package:algonaid_mobail_app/core/constants/app_constants.dart';

import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/user_model.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<TeacherModel>(TeacherModelAdapter());
    Hive.registerAdapter<CourseModel>(CourseModelAdapter());

    await Hive.openBox(AppConstants.boxAuthTokenName);
    await Hive.openBox<CourseModel>(AppConstants.boxCourses);
    await Hive.openBox<CourseModel>(AppConstants.boxMyCourses);
  }
}
