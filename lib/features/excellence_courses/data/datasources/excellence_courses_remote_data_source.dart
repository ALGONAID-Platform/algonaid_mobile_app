import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/data/models/excellence_course_model.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/data/models/excellence_module_model.dart';

abstract class ExcellenceCoursesRemoteDataSource {
  Future<List<ExcellenceCourseModel>> fetchExcellenceCourses();
  Future<List<ExcellenceModuleModel>> fetchExcellenceModules(int courseId);
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

  @override
  Future<List<ExcellenceModuleModel>> fetchExcellenceModules(int courseId) async {
    final response = await apiService.get(endpoint: '${EndPoint.baseUrl}/progress/course/$courseId/excellence-modules');
    List<ExcellenceModuleModel> modules = (response as List).map((json) {
      return ExcellenceModuleModel.fromJson(json as Map<String, dynamic>);
    }).toList();
    return modules;
  }
}
