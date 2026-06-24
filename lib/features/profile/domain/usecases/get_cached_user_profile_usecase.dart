import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:algonaid_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedUserProfileUsecase {
  final ProfileRepository repository;

  GetCachedUserProfileUsecase(this.repository);

  Either<Failure, UserProfileEntity> call() {
    return repository.getCachedUserProfile();
  }
}
