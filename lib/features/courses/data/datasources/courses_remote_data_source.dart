import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/courseProgress_model.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';

abstract class CoursesRemoteDataSource {
  Future<List<CourseEntity>> fetchCourses();
  Future<List<CourseEntity>> fetchMyCourses();
  Future<CourseProgressEntity> fetchCourseProgress({required int courseId});
  Future<bool> enrollInCourse(int courseId);
}

class CoursesRemoteDataSourceImp extends CoursesRemoteDataSource {
  final ApiService apiService;

  CoursesRemoteDataSourceImp({required this.apiService});

  @override
  Future<List<CourseEntity>> fetchCourses() async {
    var data = await apiService.get(endpoint: EndPoint.courses);
    List<CourseModel> courses = (data as List).map((json) {
      return CourseModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return courses;
  }

  @override
  Future<List<CourseEntity>> fetchMyCourses() async {
    var data = await apiService.get(endpoint: EndPoint.myCourses);
    List<CourseModel> courses = (data as List).map((json) {
      return CourseModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return courses;
  }
  

  @override
  Future<CourseProgressEntity> fetchCourseProgress({
    required int courseId,
  }) async {
    var data = await apiService.get(
      endpoint: EndPoint.courseProgress(courseId),
    );
    return CourseProgressModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<bool> enrollInCourse(int courseId) async {
    final response = await apiService.post(
      endpoint: EndPoint.enrollment,
      data: {'courseId': courseId},
    );

    return true;
  }
}
