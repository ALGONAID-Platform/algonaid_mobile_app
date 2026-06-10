import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/repositories/excellence_courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetExcellenceModulesUseCase {
  final ExcellenceCoursesRepository repository;

  GetExcellenceModulesUseCase(this.repository);

  Future<Either<Failure, List<ExcellenceModuleEntity>>> call(int courseId) async {
    return await repository.getExcellenceModules(courseId);
  }
}
