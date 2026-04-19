import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/exams/data/datasources/exam_datasources.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobail_app/features/exams/domain/repositories/exam_repository.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamLocalDataSource localDataSource;
  final ExamRemoteDataSource remoteDataSource;

  ExamRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Exam>> getExam(String examId) async {
    try {
      final remoteExam = await remoteDataSource.getExam(examId) as ExamModel;
      await localDataSource.saveExam(remoteExam);
      return Right(remoteExam);
    } catch (e) {
      if (e is DioException || e is ServerException) {
        final localExam = await localDataSource.getExam(examId);
        if (localExam != null) {
          return Right(localExam);
        }
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<String> startExam(String examId) async {
    // Start exam is always a remote operation
    return await remoteDataSource.startExam(examId);
  }

  @override
  Future<Map<String, String>?> getExamProgress(String examId) async {
    return await localDataSource.getExamProgress(examId);
  }

  @override
  Future<void> saveExamProgress(
    String examId,
    Map<String, String> answers,
  ) async {
    await localDataSource.saveExamProgress(examId, answers);
  }

  @override
  Future<Either<Failure, ExamResult>> submitExam(
    String attemptId,
    Map<String, String> answers,
  ) async {
    try {
      final remoteResult =
          await remoteDataSource.submitExam(attemptId, answers)
              as ExamResultModel;
      await localDataSource.saveExamResult(remoteResult);
      return Right(remoteResult);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, ExamResult>> getExamResult(String attemptId) async {
    try {
      // First try to fetch from remote to get the latest result
      final remoteResult =
          await remoteDataSource.getResult(attemptId) as ExamResultModel;
      await localDataSource.saveExamResult(remoteResult);
      return Right(remoteResult);
    } catch (e) {
      if (e is DioException || e is ServerException) {
        final localResult = await localDataSource.getExamResult(attemptId);
        if (localResult != null) {
          return Right(localResult);
        }
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
