import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonDetail extends UseCase<LessonDetail, int> {
  final LessonRepository repository;

  GetLessonDetail(this.repository);

  @override
  Future<Either<Failure, LessonDetail>> call(int lessonId) {
    return repository.getLessonDetail(lessonId);
  }
}
