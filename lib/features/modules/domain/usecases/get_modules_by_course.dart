// algonaid_mobail_app/lib/features/modules/domain/usecases/get_modules_by_course.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetModulesByCourse extends UseCase<List<Module>, int> {
  final ModuleRepository repository;

  GetModulesByCourse(this.repository);

  @override
  Future<Either<Failure, List<Module>>> call(int courseId) async {
    return await repository.getModulesByCourse(courseId);
  }
}
