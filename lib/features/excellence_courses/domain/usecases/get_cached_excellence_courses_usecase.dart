import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid/features/excellence_courses/domain/repositories/excellence_courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedExcellenceCoursesUseCase {
  final ExcellenceCoursesRepository repository;

  GetCachedExcellenceCoursesUseCase(this.repository);

  Either<Failure, List<ExcellenceCourseEntity>> call() {
    return repository.getCachedExcellenceCourses();
  }
}
