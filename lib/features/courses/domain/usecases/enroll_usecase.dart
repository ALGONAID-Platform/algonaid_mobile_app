import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/userCases/usecase.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';


class EnrollUsecase extends UseCase<bool ,EnrollUsecaseParams> {
  EnrollUsecase({required this.repository});

  final CoursesRepository repository;

  @override
  Future<Either<Failure, bool>> call(EnrollUsecaseParams params) {
    return repository.enrollInCourse(params.courseId);
  }
}
class EnrollUsecaseParams {
  final int courseId;

  EnrollUsecaseParams({required this.courseId});
}