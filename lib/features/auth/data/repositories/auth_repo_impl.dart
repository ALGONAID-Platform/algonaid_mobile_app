// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:dio/dio.dart';

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
      await TokenStorage.saveToken(authResponse.accessToken!);

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
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      return left(ServerFailure(e.toString()));
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
      await TokenStorage.saveToken(authResponse.accessToken!);

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
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }

      return Left(
        ServerFailure("حدث خطأ غير متوقع في الخادم، يرجى المحاولة لاحقاً"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemotDataSource.logout();
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
