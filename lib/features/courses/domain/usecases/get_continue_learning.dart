import 'package:algonaid_mobail_app/features/courses/domain/entities/course.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';

class GetContinueLearning {
  const GetContinueLearning(this._repository);

  final CoursesRepository _repository;

  Future<ContinueLearningCourse?> call() =>
      _repository.getContinueLearning();
}
