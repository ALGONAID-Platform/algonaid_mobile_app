import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUsecase extends UseCase<String, ForgotPasswordParams> {
  final AuthRepo authRepo;
  ForgotPasswordUsecase({required this.authRepo});

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) {
    return authRepo.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;
  ForgotPasswordParams({required this.email});
}
