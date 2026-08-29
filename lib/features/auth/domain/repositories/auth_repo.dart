import 'package:algonaid/core/common/enums/user_role.dart';
import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/auth/domain/entities/user_entity.dart';
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
    required String idToken,
  });
  Future<Either<Failure, void>> logout(); // Added
  Future<Either<Failure, String>> forgotPassword({required String email});
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  });
  
  // ==================== Email Verification ====================
  Future<Either<Failure, String>> verifyEmail({required String token});
  Future<Either<Failure, String>> resendVerificationEmail({required String email});
}
