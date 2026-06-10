import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/userCases/usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase {
  final AuthRepo authRepo;

  LogoutUsecase({required this.authRepo});

  Future<Either<Failure, void>> call() {
    return authRepo.logout();
  }
}
