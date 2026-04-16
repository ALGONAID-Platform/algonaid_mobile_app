import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
// import 'package:clean_architecture/core/constants/app_constants.dart';
// import 'package:clean_architecture/features/home/domain/entity/book_entity.dart';
// import 'package:clean_architecture/features/readingProgress/data/models/reading_progress_model.dart';
import 'package:hive/hive.dart';

Future<void> initHive() async {
   await Hive.openBox(AppConstants.boxAuthTokenName);
   await Hive.openBox<CourseModel>(AppConstants.boxCourses);
   await Hive.openBox<CourseModel>(AppConstants.boxMyCourses);
 
}
