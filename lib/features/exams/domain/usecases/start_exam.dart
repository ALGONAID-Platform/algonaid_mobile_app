import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/usecase/usecase.dart';
import 'package:algonaid/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid/features/exams/domain/repositories/exam_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class StartExam extends UseCase<ExamAttempt, StartExamParams> {
  final ExamRepository repository;

  StartExam(this.repository);

  @override
  Future<Either<Failure, ExamAttempt>> call(StartExamParams params) async {
    return await repository.startExam(params.examId);
  }
}

class StartExamParams extends Equatable {
  final int examId;

  const StartExamParams({required this.examId});

  @override
  List<Object?> get props => [examId];
}
