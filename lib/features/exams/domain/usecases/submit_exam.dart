import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/domain/repositories/exam_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SubmitExam extends UseCase<ExamResult, SubmitExamParams> {
  final ExamRepository repository;

  SubmitExam(this.repository);

  @override
  Future<Either<Failure, ExamResult>> call(SubmitExamParams params) async {
    return await repository.submitExam(params.attemptId, params.answers);
  }
}

class SubmitExamParams extends Equatable {
  final int attemptId;
  final Map<int, int> answers;

  const SubmitExamParams({required this.attemptId, required this.answers});

  @override
  List<Object?> get props => [attemptId, answers];
}
