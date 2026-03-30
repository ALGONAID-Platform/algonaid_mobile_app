import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';

class GetLessonDetail {
  final LessonRepository _repository;

  const GetLessonDetail(this._repository);

  Future<LessonDetail> call(int lessonId) {
    return _repository.getLessonDetail(lessonId);
  }
}
