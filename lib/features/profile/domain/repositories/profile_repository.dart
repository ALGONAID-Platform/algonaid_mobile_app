import 'package:algonaid/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/total_points_entity.dart';
import '../entities/user_profile_entity.dart';
import '../entities/user_badge_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, TotalPointsEntity>> getTotalPoints();
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<UserBadgeEntity>>> getUserBadges();
  Either<Failure, List<UserBadgeEntity>> getCachedUserBadges();
  Either<Failure, UserProfileEntity> getCachedUserProfile();
  Either<Failure, TotalPointsEntity> getCachedTotalPoints();
}
