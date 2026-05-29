// algonaid_mobail_app/lib/features/lessons/domain/usecases/get_module_lessons.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class GetModuleLessons extends UseCase<List<Lesson>, int> {
  final LessonRepository repository;

  GetModuleLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(int moduleId) async {
    return await repository.getModuleLessons(moduleId);
  }
}
