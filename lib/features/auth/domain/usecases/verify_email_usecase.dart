import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class VerifyEmailUsecase extends UseCase<String, VerifyEmailParams> {
  final AuthRepo authRepo;

  VerifyEmailUsecase({required this.authRepo});

  @override
  Future<Either<Failure, String>> call(VerifyEmailParams params) {
    return authRepo.verifyEmail(token: params.token);
  }
}

class VerifyEmailParams {
  final String token;
  VerifyEmailParams({required this.token});
}
