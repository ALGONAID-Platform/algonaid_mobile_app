import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(Map<String, dynamic> data) async {
    return await repository.updateUserProfile(data);
  }
}
