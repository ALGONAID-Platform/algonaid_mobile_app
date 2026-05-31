import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/data/models/lesson_detail_model.dart';

abstract class LessonDetailRemoteDataSource {
  Future<LessonDetailModel> fetchLessonDetail(int lessonId);
  Future<void> updateLessonProgress(int lessonId, bool isCompleted);
}

class LessonDetailRemoteDataSourceImpl implements LessonDetailRemoteDataSource {
  final ApiService _api;

  const LessonDetailRemoteDataSourceImpl(this._api);

  @override
  Future<LessonDetailModel> fetchLessonDetail(int lessonId) async {
    final data = await _api.get(endpoint: EndPoint.lessonDetails(lessonId));
    final lessonMap = _extractLesson(data);
    return LessonDetailModel.fromJson(lessonMap);
  }

  @override
  Future<void> updateLessonProgress(int lessonId, bool isCompleted) async {
    await _api.post(
      endpoint: EndPoint.progressUpdate,
      data: {
        "lessonId": lessonId,
        "isCompleted": isCompleted,
      },
    );
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
