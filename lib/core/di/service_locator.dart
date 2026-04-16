import 'package:algonaid_mobail_app/core/network/api_service.dart';

import 'package:algonaid_mobail_app/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:algonaid_mobail_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:algonaid_mobail_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';

import 'package:algonaid_mobail_app/features/courses/data/datasources/course_local_stroage.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_mycourese_usecase.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';

import 'package:algonaid_mobail_app/features/modules/data/datasources/module_remote_datasource.dart';
import 'package:algonaid_mobail_app/features/modules/data/repositories/module_repository_impl.dart';
import 'package:algonaid_mobail_app/features/modules/domain/repositories/module_repository.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_modules_by_course.dart';

import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';

import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // ================= CORE =================
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(Dio()),
  );

  // ================= DATA SOURCES =================
  getIt.registerLazySingleton<AuthRemoteDatasourse>(
    () => AuthRemoteDatasourseImp(apiService: getIt()),
  );

  getIt.registerLazySingleton<CoursesRemoteDataSource>(
    () => CoursesRemoteDataSourceImp(apiService: getIt()),
  );

  getIt.registerLazySingleton<CourseLocalDataSourse>(
    () => CourseLocalDataSourseImp(),
  );

  getIt.registerLazySingleton<ModuleRemoteDataSource>(
    () => ModuleRemoteDataSourceImpl(apiService: getIt()),
  );

  getIt.registerLazySingleton<LessonRemoteDataSource>(
    () => LessonRemoteDataSourceImpl(getIt()),
  );

  // ================= REPOSITORIES =================
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authRemotDataSource: getIt()),
  );

  getIt.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(remote: getIt(), local: getIt()),
  );

  getIt.registerLazySingleton<ModuleRepository>(
    () => ModuleRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(remoteDataSource: getIt()),
  );

  // ================= USE CASES =================
  getIt.registerLazySingleton<SigninUsecase>(
    () => SigninUsecase(authRepo: getIt()),
  );

  getIt.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(authRepo: getIt()),
  );

  getIt.registerLazySingleton<GetCoursesUsecase>(
    () => GetCoursesUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetMycoureseUsecase>(
    () => GetMycoureseUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetModulesByCourse>(
    () => GetModulesByCourse(getIt<ModuleRepository>()),
  );

  getIt.registerLazySingleton<GetModuleLessons>(
    () => GetModuleLessons(getIt<LessonRepository>()),
  );

  getIt.registerLazySingleton<GetLessonDetail>(
    () => GetLessonDetail(getIt<LessonRepository>()),
  );

  // ================= PROVIDERS =================
  getIt.registerFactory<AuthServiceProvider>(
    () => AuthServiceProvider(
      signInUseCase: getIt(),
      signUpUseCase: getIt(),
    ),
  );

  getIt.registerFactory<GetCoursesProvider>(
    () => GetCoursesProvider(
      coursesUsecase: getIt(),
      myCoursesUsecase: getIt(),
    ),
  );

  getIt.registerFactory<ModulesListProvider>(
    () => ModulesListProvider(
      getIt<GetModulesByCourse>(),
    ),
  );
}