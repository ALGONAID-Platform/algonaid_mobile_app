import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:algonaid_mobail_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  // 1. Core (الأدوات الأساسية)
  getIt.registerLazySingleton<ApiService>(() => ApiService(Dio()));

  // 2. Data Sources (تعتمد على ApiService)
  getIt.registerLazySingleton<AuthRemoteDatasourse>(
    () => AuthRemoteDatasourseImp(apiService: getIt()),
  );

  // 3. Repositories (تعتمد على Data Sources)
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authRemotDataSource: getIt()),
  );

  // 4. Use Cases (تعتمد على Repositories)
  getIt.registerLazySingleton<SigninUsecase>(
    () => SigninUsecase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(authRepo: getIt()),
  );

  // 5. Providers (تعتمد على Use Cases) 
  getIt.registerFactory<AuthServiceProvider>(
    () => AuthServiceProvider(
      signInUseCase: getIt<SigninUsecase>(), 
      signUpUseCase: getIt<SignupUsecase>(),
    ),
  );
}