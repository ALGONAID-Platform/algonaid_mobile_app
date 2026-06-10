import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/total_points_entity.dart';
import '../repositories/profile_repository.dart';

class GetTotalPointsUseCase {
  final ProfileRepository repository;

  GetTotalPointsUseCase(this.repository);

  Future<Either<Failure, TotalPointsEntity>> call() async {
    return await repository.getTotalPoints();
  }
}
