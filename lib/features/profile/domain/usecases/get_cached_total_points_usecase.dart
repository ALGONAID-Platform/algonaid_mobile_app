import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/profile/domain/entities/total_points_entity.dart';
import 'package:algonaid/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedTotalPointsUsecase {
  final ProfileRepository repository;

  GetCachedTotalPointsUsecase(this.repository);

  Either<Failure, TotalPointsEntity> call() {
    return repository.getCachedTotalPoints();
  }
}
