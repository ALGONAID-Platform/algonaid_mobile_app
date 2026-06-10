import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ExcellenceCoursesRepository {
  Future<Either<Failure, List<ExcellenceCourseEntity>>> getExcellenceCourses();
  Future<Either<Failure, List<ExcellenceModuleEntity>>> getExcellenceModules(int courseId);
}
