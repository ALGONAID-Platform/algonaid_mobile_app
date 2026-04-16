// algonaid_mobail_app/lib/features/lessons/data/datasources/lesson_remote_datasource.dart

import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> getModuleLessons(int moduleId);
  Future<LessonModel> getLessonDetail(int lessonId);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiService apiService;

  LessonRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<LessonModel>> getModuleLessons(int moduleId) async {
    final response = await apiService.get(
      endpoint: EndPoint.lessonsByModule(moduleId),
    );
    final List<dynamic> lessonMaps = response as List<dynamic>;
    return lessonMaps.map((json) => LessonModel.fromJson(json)).toList();
  }

  @override
  Future<LessonModel> getLessonDetail(int lessonId) async {
    final response = await apiService.get(
      endpoint: EndPoint.lessonDetails(lessonId),
    );
    return LessonModel.fromJson(response);
  }
}
