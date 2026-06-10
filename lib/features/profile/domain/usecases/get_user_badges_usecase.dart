import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_badge_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserBadgesUseCase {
  final ProfileRepository repository;

  GetUserBadgesUseCase(this.repository);

  Future<Either<Failure, List<UserBadgeEntity>>> call() async {
    return await repository.getUserBadges();
  }
}
