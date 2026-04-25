// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/userCases/usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class SignupUsecase extends UseCase<UserEntity, SignupParams> {
  AuthRepo authRepo;
  SignupUsecase({required this.authRepo});

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return authRepo.signup(
      email: params.email,
      username: params.username,
      password: params.password,
      role: params.role,
    );
  }
}

class SignupParams {
  String username;
  String email;
  String password;
  UserRole role;
  SignupParams({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });
}
