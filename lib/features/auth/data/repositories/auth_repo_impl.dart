// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid/core/errors/exceptions.dart';
import 'package:algonaid/core/network/dio_error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:algonaid/core/common/enums/user_role.dart';
import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:algonaid/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid/features/auth/domain/repositories/auth_repo.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDatasourse authRemotDataSource;
  AuthRepoImpl({required this.authRemotDataSource});
  @override
  Future<Either<Failure, UserEntity>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await authRemotDataSource.signin(
        email: email,
        password: password,
      );
      await TokenStorage.saveToken(authResponse.accessToken);

      return Right(
        UserEntity(
          id: authResponse.user.id,
          username: authResponse.user.name,
          email: authResponse.user.email,
          role: authResponse.user.role,
          message: authResponse.message,
          token: authResponse.accessToken,
          avatar: authResponse.user.avatar,
          background: authResponse.user.background,
          academicId: authResponse.user.academicId,
          grade: authResponse.user.grade,
          birthDate: authResponse.user.birthDate,
          address: authResponse.user.address,
          createdAt: authResponse.user.createdAt,
          updatedAt: authResponse.user.updatedAt,
        ),
      );
    } catch (e) {
      if (e is ServerException) {
        return left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      return left(const ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String username,
    required String password,
    required UserRole role,
  }) async {
    try {
      final authResponse = await authRemotDataSource.signup(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      // نسجّل ما يُرجعه السيرفر لتشخيص مشكلة التوكن
      debugPrint('📦 SignUp Response: accessToken="${authResponse.accessToken}"');

      // نحفظ التوكن دائمًا إذا كان موجودًا
      if (authResponse.accessToken.isNotEmpty) {
        await TokenStorage.saveToken(authResponse.accessToken);
        debugPrint('✅ SignUp: تم حفظ التوكن: ${authResponse.accessToken.substring(0, 20)}...');
      } else {
        debugPrint('⚠️ SignUp: السيرفر لم يُرجع accessToken!');
      }

      return Right(
        UserEntity(
          id: authResponse.user.id,
          username: authResponse.user.name,
          email: authResponse.user.email,
          role: authResponse.user.role,
          message: authResponse.message,
          token: authResponse.accessToken.isNotEmpty ? authResponse.accessToken : null,
          avatar: authResponse.user.avatar,
          background: authResponse.user.background,
          academicId: authResponse.user.academicId,
          grade: authResponse.user.grade,
          birthDate: authResponse.user.birthDate,
          address: authResponse.user.address,
          createdAt: authResponse.user.createdAt,
          updatedAt: authResponse.user.updatedAt,
        ),
      );
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }

      return Left(
        ServerFailure("حدث خطأ غير متوقع في الخادم، يرجى المحاولة لاحقاً"),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> googleSignin({
    required String idToken,
  }) async {
    try {
      final authResponse = await authRemotDataSource.googleSignin(
        idToken: idToken,
      );
      await TokenStorage.saveToken(authResponse.accessToken);

      return Right(
        UserEntity(
          id: authResponse.user.id,
          username: authResponse.user.name,
          email: authResponse.user.email,
          role: authResponse.user.role,
          message: authResponse.message,
          token: authResponse.accessToken,
          avatar: authResponse.user.avatar,
          background: authResponse.user.background,
          academicId: authResponse.user.academicId,
          grade: authResponse.user.grade,
          birthDate: authResponse.user.birthDate,
          address: authResponse.user.address,
          createdAt: authResponse.user.createdAt,
          updatedAt: authResponse.user.updatedAt,
        ),
      );
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع أثناء تسجيل الدخول بجوجل"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemotDataSource.logout();
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع أثناء تسجيل الخروج"));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await authRemotDataSource.forgotPassword(email: email);
      final message =
          response['message'] as String? ??
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
      return Right(message);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await authRemotDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      final message =
          response['message'] as String? ?? 'تم إعادة تعيين كلمة المرور بنجاح';
      return Right(message);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail({required String token}) async {
    try {
      final response = await authRemotDataSource.verifyEmail(token: token);
      final message =
          response['message'] as String? ?? 'تم تأكيد بريدك الإلكتروني بنجاح';
      return Right(message);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
    }
  }

  @override
  Future<Either<Failure, String>> resendVerificationEmail({
    required String email,
  }) async {
    try {
      final response =
          await authRemotDataSource.resendVerificationEmail(email: email);
      final message =
          response['message'] as String? ?? 'تم إرسال رابط التحقق بنجاح';
      return Right(message);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(const ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
    }
  }
}
