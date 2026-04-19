import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_data.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart'; // 🌟 استيراد الموديل ضروري
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

abstract class CourseLocalDataSourse {
  List<CourseEntity> getAllCourses();
  List<CourseEntity> getMyCourses();

  Future<void> saveCourses(List<CourseEntity> courses);
  Future<void> saveMyCourses(List<CourseEntity> courses);
}

class CourseLocalDataSourseImp implements CourseLocalDataSourse {
  @override
  List<CourseEntity> getAllCourses() {
    // 🌟 نجلب البيانات كموديلات ثم نحولها لـ Entities
    final List<CourseModel> models = getAllData<CourseModel>(
      AppConstants.boxCourses,
    );
    return models; // بما أن Model يرث من Entity، سيعمل هذا مباشرة
  }

  @override
  List<CourseEntity> getMyCourses() {
    final List<CourseModel> models = getAllData<CourseModel>(
      AppConstants.boxMyCourses,
    );
    return models;
  }

  @override
  Future<void> saveCourses(List<CourseEntity> courses) async {
    // 🌟 السر هنا: تحويل الـ Entities إلى Models قبل إرسالها للـ Generic Function
    final List<CourseModel> models = courses
        .map((e) => CourseModel.fromEntity(e))
        .toList();

    // الآن نرسلها لـ cacheList بالنوع الصريح <CourseModel>
    await cacheList<CourseModel>(models, AppConstants.boxCourses);
  }

  @override
  Future<void> saveMyCourses(List<CourseEntity> courses) async {
    final List<CourseModel> models = courses
        .map((e) => CourseModel.fromEntity(e))
        .toList();

    await cacheList<CourseModel>(models, AppConstants.boxMyCourses);
  }
}
