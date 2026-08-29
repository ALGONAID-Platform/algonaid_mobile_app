// algonaid/lib/features/modules/domain/usecases/get_modules_by_course.dart

import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/usecase/usecase.dart';
import 'package:algonaid/features/modules/domain/entities/module.dart';
import 'package:algonaid/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetModulesByCourse extends UseCase<List<Module>, int> {
  final ModuleRepository repository;

  GetModulesByCourse(this.repository);

  @override
  Future<Either<Failure, List<Module>>> call(int courseId) async {
    return await repository.getModulesByCourse(courseId);
  }
}
