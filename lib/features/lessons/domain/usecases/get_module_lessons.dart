// algonaid/lib/features/lessons/domain/usecases/get_module_lessons.dart

import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/usecase/usecase.dart';
import 'package:algonaid/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:algonaid/features/lessons/domain/entities/paginated_lessons.dart';

class GetModuleLessonsParams {
  final int moduleId;
  final int page;
  final int? limit;

  GetModuleLessonsParams({required this.moduleId, this.page = 1, this.limit});
}

class GetModuleLessons extends UseCase<PaginatedLessons, GetModuleLessonsParams> {
  final LessonRepository repository;

  GetModuleLessons(this.repository);

  @override
  Future<Either<Failure, PaginatedLessons>> call(GetModuleLessonsParams params) async {
    return await repository.getModuleLessons(params.moduleId, page: params.page, limit: params.limit);
  }
}
