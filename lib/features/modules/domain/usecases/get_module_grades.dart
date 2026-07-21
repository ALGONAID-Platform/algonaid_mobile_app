import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/usecase/usecase.dart';
import 'package:algonaid/features/modules/domain/entities/module_grades.dart';
import 'package:algonaid/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetModuleGrades implements UseCase<ModuleGrades, int> {
  final ModuleRepository repository;

  GetModuleGrades(this.repository);

  @override
  Future<Either<Failure, ModuleGrades>> call(int moduleId) async {
    return await repository.getModuleGrades(moduleId);
  }
}
