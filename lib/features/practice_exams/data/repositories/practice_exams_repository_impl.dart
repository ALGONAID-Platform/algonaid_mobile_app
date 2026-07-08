import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/features/practice_exams/data/datasources/practice_exams_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/entities/practice_exam_entity.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/repositories/practice_exams_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PracticeExamsRepositoryImpl implements PracticeExamsRepository {
  final PracticeExamsRemoteDataSource remoteDataSource;

  PracticeExamsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PracticeExamEntity>>> getPracticeExams(int courseId) async {
    try {
      final exams = await remoteDataSource.getPracticeExams(courseId);
      return Right(exams);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع أثناء جلب نماذج الاختبارات"));
    }
  }
}
