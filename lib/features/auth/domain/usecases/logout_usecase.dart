import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/usecase.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase {
  final AuthRepo authRepo;

  LogoutUsecase({required this.authRepo});

  Future<Either<Failure, void>> call() {
    return authRepo.logout();
  }
}
