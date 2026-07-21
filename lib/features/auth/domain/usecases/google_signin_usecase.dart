// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class GoogleSigninUsecase extends UseCase<UserEntity, GoogleSigninParams> {
  AuthRepo authRepo;
  GoogleSigninUsecase({required this.authRepo});

  @override
  Future<Either<Failure, UserEntity>> call(GoogleSigninParams params) {
    return authRepo.googleSignin(idToken: params.idToken);
  }
}

class GoogleSigninParams {
  final String idToken;
  GoogleSigninParams({required this.idToken});
}
