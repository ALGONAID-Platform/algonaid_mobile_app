import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ResendVerificationUsecase extends UseCase<String, ResendVerificationParams> {
  final AuthRepo authRepo;

  ResendVerificationUsecase({required this.authRepo});

  @override
  Future<Either<Failure, String>> call(ResendVerificationParams params) {
    return authRepo.resendVerificationEmail(email: params.email);
  }
}

class ResendVerificationParams {
  final String email;
  ResendVerificationParams({required this.email});
}
