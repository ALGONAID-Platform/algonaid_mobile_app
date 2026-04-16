// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/userCases/usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class SigninUsecase extends UseCase<UserEntity , SigninParams> {
  AuthRepo authRepo;
  SigninUsecase( {required this.authRepo});

  @override
  Future<Either<Failure, UserEntity>> call(SigninParams params) {
    return this.authRepo.signin(
      email: params.email,
      password: params.password,
    );
  }
}

class SigninParams {
 
  String email;
  String password;
  SigninParams({
    required this.email,
    required this.password,
  });
}
