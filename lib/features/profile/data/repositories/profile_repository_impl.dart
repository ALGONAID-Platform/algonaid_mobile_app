import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:algonaid_mobail_app/core/network/check_internet.dart';
import '../../domain/entities/total_points_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/user_badge_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/total_points_model.dart';
import '../models/user_profile_model.dart';
import 'package:flutter/foundation.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TotalPointsEntity>> getTotalPoints() async {
    final isOffline = await hasNoInternet();

    if (isOffline) {
      try {
        final localPoints = await localDataSource.getTotalPoints();
        if (localPoints != null) {
          return Right(localPoints);
        }
      } catch (_) {}
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت ولا توجد نقاط محفوظة.'));
    }

    try {
      final result = await remoteDataSource.getTotalPoints();
      await localDataSource.saveTotalPoints(result as TotalPointsModel);
      return Right(result);
    } catch (e) {
      try {
        final localPoints = await localDataSource.getTotalPoints();
        if (localPoints != null) {
          return Right(localPoints);
        }
      } catch (_) {}
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    final isOffline = await hasNoInternet();
    
    if (isOffline) {
      try {
        final localProfile = await localDataSource.getUserProfile();
        if (localProfile != null) {
          return Right(localProfile);
        }
      } catch (_) {}
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت ولا توجد بيانات محفوظة.'));
    }

    try {
      final result = await remoteDataSource.getUserProfile();
      try {
        // Here we attempt to cache the data
          await localDataSource.saveUserProfile(result);
       
      } catch (e) {
        debugPrint('Failed to save profile locally: $e');
      }
      return Right(result);
    } catch (e) {
      try {
        final localProfile = await localDataSource.getUserProfile();
        if (localProfile != null) {
          return Right(localProfile);
        }
      } catch (_) {}
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(Map<String, dynamic> data) async {
    final isOffline = await hasNoInternet();
    if (isOffline) {
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت.'));
    }
    try {
      final result = await remoteDataSource.updateUserProfile(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserBadgeEntity>>> getUserBadges() async {
    final isOffline = await hasNoInternet();
    if (isOffline) {
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت.'));
    }
    try {
      final result = await remoteDataSource.getUserBadges();
      // Ensure the list is typed as List<UserBadgeEntity>
      return Right(result.map((e) => e as UserBadgeEntity).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
