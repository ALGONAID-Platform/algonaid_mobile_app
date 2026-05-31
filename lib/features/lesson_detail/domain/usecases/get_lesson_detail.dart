import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/repositories/lesson_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonDetail extends UseCase<LessonDetail, int> {
  final LessonDetailRepository repository;

  GetLessonDetail(this.repository);

  @override
  Future<Either<Failure, LessonDetail>> call(int lessonId) {
    return repository.getLessonDetail(lessonId);
  }
}
