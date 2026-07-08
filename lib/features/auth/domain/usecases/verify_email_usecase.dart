import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/userCases/usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/repositories/auth_repo.dart';
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
