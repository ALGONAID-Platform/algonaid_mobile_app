import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_badge_entity.dart';
import '../repositories/profile_repository.dart';

class GetCachedUserBadgesUseCase {
  final ProfileRepository repository;

  GetCachedUserBadgesUseCase(this.repository);

  Either<Failure, List<UserBadgeEntity>> call() {
    return repository.getCachedUserBadges();
  }
}
