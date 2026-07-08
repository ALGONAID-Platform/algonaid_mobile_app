import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/userCases/usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/repositories/auth_repo.dart';
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
