import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/domain/repositories/exam_repository.dart';
import 'package:dartz/dartz.dart';

class GetExamUseCase {
  final ExamRepository repository;
  GetExamUseCase(this.repository);

  Future<Either<Failure, Exam>> call(int examId) async {
    return await repository.getExam(examId);
  }
}

class StartExamUseCase {
  final ExamRepository repository;
  StartExamUseCase(this.repository);

  Future<Either<Failure, ExamAttempt>> call(int examId) async {
    return await repository.startExam(examId);
  }
}

class SubmitExamUseCase {
  final ExamRepository repository;
  SubmitExamUseCase(this.repository);

  Future<Either<Failure, ExamResult>> call(
    int attemptId,
    Map<int, int> answers,
  ) async {
    return await repository.submitExam(attemptId, answers);
  }
}

class SaveExamProgressUseCase {
  final ExamRepository repository;
  SaveExamProgressUseCase(this.repository);

  Future<void> call(int examId, Map<int, int> answers) async {
    await repository.saveExamProgress(examId, answers);
  }
}

class GetExamProgressUseCase {
  final ExamRepository repository;
  GetExamProgressUseCase(this.repository);

  Future<Map<int, int>?> call(int examId) async {
    return await repository.getExamProgress(examId);
  }
}

class GetExamResultUseCase {
  final ExamRepository repository;
  GetExamResultUseCase(this.repository);

  Future<Either<Failure, ExamResult>> call(int attemptId) async {
    return await repository.getExamResult(attemptId);
  }
}
