import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signin({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String username,
    required String password,
    required UserRole role,
  });
  Future<Either<Failure, void>> logout(); // Added
}
