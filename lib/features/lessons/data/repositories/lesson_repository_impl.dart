import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource _remote;

  const LessonRepositoryImpl(this._remote);

  @override
  Future<List<Lesson>> getLessonsByModule(int moduleId) {
    return _remote.fetchLessonsByModule(moduleId);
  }

  @override
  Future<LessonDetail> getLessonDetail(int lessonId) {
    return _remote.fetchLessonDetail(lessonId);
  }
}
