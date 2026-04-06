import 'package:algonaid_mobail_app/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  const CoursesRepositoryImpl(this._remote);

  final CoursesRemoteDataSource _remote;

  @override
  Future<List<Course>> getCatalog() async {
    final models = await _remote.fetchCatalog();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ContinueLearningCourse?> getContinueLearning() async {
    final model = await _remote.fetchContinueLearning();
    return model?.toEntity();
  }
}
