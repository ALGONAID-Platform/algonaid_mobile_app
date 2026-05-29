import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ExcellenceCoursesRepository {
  Future<Either<Failure, List<ExcellenceCourseEntity>>> getExcellenceCourses();
}
