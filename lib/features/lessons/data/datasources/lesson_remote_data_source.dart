import 'package:algonaid_mobail_app/core/network/end_points.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> fetchLessonsByModule(int moduleId);
  Future<LessonDetailModel> fetchLessonDetail(int lessonId);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiService _api;

  const LessonRemoteDataSourceImpl(this._api);

  @override
  Future<List<LessonModel>> fetchLessonsByModule(int moduleId) async {
    final data = await _api.get(endpoint: EndPoint.lessonsByModule(moduleId));

    final items = _extractList(data);
    return items
        .whereType<Map<String, dynamic>>()
        .map(LessonModel.fromJson)
        .toList();
  }

  @override
  Future<LessonDetailModel> fetchLessonDetail(int lessonId) async {
    final data = await _api.get(endpoint: EndPoint.lessonDetails(lessonId));

    final lessonMap = _extractLesson(data);
    return LessonDetailModel.fromJson(lessonMap);
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data['lessons'] is List) {
        return data['lessons'] as List<dynamic>;
      }
      if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        if (nested['lessons'] is List) {
          return nested['lessons'] as List<dynamic>;
        }
      }
    }
    throw Exception('Unexpected lessons response format');
  }

  Map<String, dynamic> _extractLesson(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    throw Exception('Unexpected lesson response format');
  }
}
