import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/userCases/usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/repositories/auth_repo.dart';
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
