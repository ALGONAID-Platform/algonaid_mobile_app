import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/entities/practice_exam_entity.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/repositories/practice_exams_repository.dart';
import 'package:dartz/dartz.dart';

class GetPracticeExamsUseCase {
  final PracticeExamsRepository repository;

  GetPracticeExamsUseCase(this.repository);

  Future<Either<Failure, List<PracticeExamEntity>>> call(int courseId) async {
    return await repository.getPracticeExams(courseId);
  }
}
