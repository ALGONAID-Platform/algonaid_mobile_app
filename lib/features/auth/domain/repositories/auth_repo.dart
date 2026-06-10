import 'package:algonaid_mobile_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/auth/domain/entities/user_entity.dart';
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
  Future<Either<Failure, UserEntity>> googleSignin({
    required String accessToken,
  });
  Future<Either<Failure, void>> logout(); // Added
  Future<Either<Failure, String>> forgotPassword({required String email});
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  });
}
