import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/profile/domain/entities/total_points_entity.dart';
import 'package:algonaid_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedTotalPointsUsecase {
  final ProfileRepository repository;

  GetCachedTotalPointsUsecase(this.repository);

  Either<Failure, TotalPointsEntity> call() {
    return repository.getCachedTotalPoints();
  }
}
