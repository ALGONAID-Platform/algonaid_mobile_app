import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/data/models/excellence_course_model.dart';
import 'dart:convert';

abstract class ExcellenceCoursesLocalDataSource {
  Future<void> saveExcellenceCourses(List<ExcellenceCourseModel> courses);
  Future<List<ExcellenceCourseModel>?> getExcellenceCourses();
}

class ExcellenceCoursesLocalDataSourceImp implements ExcellenceCoursesLocalDataSource {
  @override
  Future<void> saveExcellenceCourses(List<ExcellenceCourseModel> courses) async {
    final List<Map<String, dynamic>> jsonData = courses.map((e) => e.toJson()).toList();
    await CacheHelper.saveData(
      key: AppConstants.cacheExcellenceCourses,
      value: jsonEncode(jsonData),
    );
  }

  @override
  Future<List<ExcellenceCourseModel>?> getExcellenceCourses() async {
    final jsonString = CacheHelper.getString(key: AppConstants.cacheExcellenceCourses);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((e) => ExcellenceCourseModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
