import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/repositories/excellence_courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetExcellenceCoursesUseCase {
  final ExcellenceCoursesRepository repository;

  GetExcellenceCoursesUseCase(this.repository);

  Future<Either<Failure, List<ExcellenceCourseEntity>>> call() async {
    return await repository.getExcellenceCourses();
  }
}
