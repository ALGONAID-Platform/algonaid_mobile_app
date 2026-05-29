import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/data/models/excellence_course_model.dart';

abstract class ExcellenceCoursesRemoteDataSource {
  Future<List<ExcellenceCourseModel>> fetchExcellenceCourses();
}

class ExcellenceCoursesRemoteDataSourceImp implements ExcellenceCoursesRemoteDataSource {
  final ApiService apiService;

  ExcellenceCoursesRemoteDataSourceImp({required this.apiService});

  @override
  Future<List<ExcellenceCourseModel>> fetchExcellenceCourses() async {
    final response = await apiService.get(endpoint: EndPoint.excellenceCourses);
    List<ExcellenceCourseModel> courses = (response as List).map((json) {
      return ExcellenceCourseModel.fromJson(json as Map<String, dynamic>);
    }).toList();
    return courses;
  }
}
