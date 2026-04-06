import 'package:algonaid_mobail_app/features/courses/domain/entities/course.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';

class GetCoursesCatalog {
  const GetCoursesCatalog(this._repository);

  final CoursesRepository _repository;

  Future<List<Course>> call() => _repository.getCatalog();
}
