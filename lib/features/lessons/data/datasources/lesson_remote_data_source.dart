import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/network/api_service.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobile_app/core/utils/hive/token_storage.dart';

import 'package:algonaid_mobile_app/features/lessons/domain/entities/paginated_lessons.dart';

abstract class LessonRemoteDataSource {
  Future<PaginatedLessons> fetchLessonsByModule(int moduleId, {int page = 1, int? limit});
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiService _api;

  const LessonRemoteDataSourceImpl(this._api);

  @override
  Future<PaginatedLessons> fetchLessonsByModule(int moduleId, {int page = 1, int? limit}) async {
    final isGuest = TokenStorage.getToken() == null;
    final endpoint = isGuest
        ? (limit != null 
            ? EndPoint.lessonsByModuleGuest(moduleId, page: page, limit: limit)
            : EndPoint.lessonsByModuleGuest(moduleId, page: page))
        : (limit != null 
            ? EndPoint.lessonsByModule(moduleId, page: page, limit: limit)
            : EndPoint.lessonsByModule(moduleId, page: page));
    final data = await _api.get(endpoint: endpoint);

    final items = _extractList(data);
    final meta = _extractMeta(data);

    final lessons = items
        .whereType<Map<String, dynamic>>()
        .map(LessonModel.fromJson)
        .toList();

    return PaginatedLessons(lessons: lessons, meta: meta);
  }

  PaginationMeta _extractMeta(dynamic data) {
    if (data is Map<String, dynamic> && data['meta'] != null) {
      return PaginationMeta.fromJson(data['meta']);
    }
    return PaginationMeta(total: 0, page: 1, limit: 10, totalPages: 1);
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
}
