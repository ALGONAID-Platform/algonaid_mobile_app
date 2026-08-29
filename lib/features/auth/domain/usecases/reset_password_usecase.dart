import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUsecase extends UseCase<String, ResetPasswordParams> {
  final AuthRepo authRepo;
  ResetPasswordUsecase({required this.authRepo});

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) {
    return authRepo.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordParams {
  final String token;
  final String newPassword;
  ResetPasswordParams({required this.token, required this.newPassword});
}
