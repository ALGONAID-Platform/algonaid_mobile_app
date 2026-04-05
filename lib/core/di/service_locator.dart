import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:algonaid_mobail_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:algonaid_mobail_app/features/lessons/data/services/lesson_download_service.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
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
  getIt.registerLazySingleton<LessonRemoteDataSource>(
    () => LessonRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<LessonLocalDataSource>(
    () => const LessonLocalDataSourceImpl(),
  );

  // 3. Repositories (تعتمد على Data Sources)
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authRemotDataSource: getIt()),
  );
  getIt.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(getIt(), getIt()),
  );

  // 4. Use Cases (تعتمد على Repositories)
  getIt.registerLazySingleton<SigninUsecase>(
    () => SigninUsecase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<GetModuleLessons>(
    () => GetModuleLessons(getIt()),
  );
  getIt.registerLazySingleton<GetLessonDetail>(
    () => GetLessonDetail(getIt()),
  );
  getIt.registerLazySingleton<LessonDownloadService>(
    () => LessonDownloadService(getIt()),
  );

  // 5. Providers (تعتمد على Use Cases) 
  getIt.registerFactory<AuthServiceProvider>(
    () => AuthServiceProvider(
      signInUseCase: getIt<SigninUsecase>(), 
      signUpUseCase: getIt<SignupUsecase>(),
    ),
  );
}
