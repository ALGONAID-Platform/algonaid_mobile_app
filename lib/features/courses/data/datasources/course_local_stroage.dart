import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_data.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/courseProgress_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart'; // 🌟 استيراد الموديل ضروري
import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

abstract class CourseLocalDataSourse {
  List<CourseEntity> getAllCourses();
  List<CourseEntity> getMyCourses();
  CourseProgressEntity getMyCourseProgress({required int courseId});

  Future<void> saveCourses(List<CourseEntity> courses);
  Future<void> saveMyCourses(List<CourseEntity> courses);
  Future<void> saveCourseProgress(CourseProgressEntity progress , int courseId);
}

class CourseLocalDataSourseImp implements CourseLocalDataSourse {
  @override
  List<CourseEntity> getAllCourses() {
    final List<CourseModel> models = getAllData<CourseModel>(
      AppConstants.boxCourses,
    );
    return models;
  }

  @override
  List<CourseEntity> getMyCourses() {
    final List<CourseModel> models = getAllData<CourseModel>(
      AppConstants.boxMyCourses,
    );
    return models;
  }

  @override
  CourseProgressEntity getMyCourseProgress({required int courseId}) {
    final CourseProgressModel? models = getSingleItem<CourseProgressModel>(
      AppConstants.boxCourseProgress,
      courseId,
    );
    return models ??
        CourseProgressModel(
          courseId: 0,
          totalLessons: 0,
          completedLessons: 0,
          progressPercentage: 0.0,
        );
  }

  @override
  Future<void> saveCourses(List<CourseEntity> courses) async {
    final List<CourseModel> models = courses
        .map((e) => CourseModel.fromEntity(e))
        .toList();
    await cacheList<CourseModel>(models, AppConstants.boxCourses);
  }

  @override
  Future<void> saveMyCourses(List<CourseEntity> courses) async {
    final List<CourseModel> models = courses
        .map((e) => CourseModel.fromEntity(e))
        .toList();
    await cacheList<CourseModel>(models, AppConstants.boxMyCourses);
  }
  
  @override
  Future<void> saveCourseProgress(CourseProgressEntity progress , int courseId) async {
    final CourseProgressModel model = CourseProgressModel.fromEntity(progress);
    return saveSingleItem<CourseProgressModel>(model, AppConstants.boxCourseProgress, courseId);
  }
}
