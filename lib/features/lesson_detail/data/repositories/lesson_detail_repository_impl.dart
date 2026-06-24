import 'package:flutter/foundation.dart';
import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/datasources/lesson_detail_local_data_source.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/datasources/lesson_detail_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/repositories/lesson_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonDetailRepositoryImpl implements LessonDetailRepository {
  final LessonDetailRemoteDataSource remoteDataSource;
  final LessonDetailLocalDataSource localDataSource;

  LessonDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId) async {
    final localModel = localDataSource.getLessonDetail(lessonId);
    final isOffline = await hasNoInternet();

    if (isOffline) {
      if (localModel != null) {
        return Right(localModel.toEntity());
      }
      return Left(
        ServerFailure('لا يوجد اتصال بالإنترنت ولا توجد تفاصيل محفوظة لهذا الدرس.'),
      );
    }

    try {
      final LessonDetailModel model = await remoteDataSource.fetchLessonDetail(
        lessonId,
      );
      await localDataSource.saveLessonDetail(model);

      final entity = model.toEntity();

      return Right(entity);
    } catch (e) {
      if (localModel != null) {
        return Right(localModel.toEntity());
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(const ServerFailure('حدث خطأ غير متوقع أثناء تحميل تفاصيل الدرس.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLessonProgress(int lessonId, bool isCompleted) async {
    try {
      await remoteDataSource.updateLessonProgress(lessonId, isCompleted);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(const ServerFailure('حدث خطأ غير متوقع أثناء تحديث تقدم الدرس.'));
    }
  }
}
