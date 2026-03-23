// import 'package:clean_architecture/core/network/api_service.dart';
// import 'package:clean_architecture/features/auth/data/data_sourse/auth_remote_data_source.dart';
// import 'package:clean_architecture/features/auth/data/repo/auth_repo_impl.dart';
// import 'package:clean_architecture/features/auth/domain/repo/auth_repo.dart';
// import 'package:clean_architecture/features/auth/domain/user_cases/login_usecase.dart';
// import 'package:clean_architecture/features/auth/domain/user_cases/register_usecase.dart';
// import 'package:clean_architecture/features/auth/presentaion/manger/auth_cubit.dart';
// import 'package:clean_architecture/features/home/data/data_sources/home_local_data_source.dart';
// import 'package:clean_architecture/features/home/data/data_sources/remote_data_source.dart';
// import 'package:clean_architecture/features/home/data/repos/home_repo_impl.dart';
// import 'package:clean_architecture/features/home/domain/user_cases/fetch_books_use_case.dart';
// import 'package:clean_architecture/features/home/domain/user_cases/fetch_newest_use_case.dart';
// import 'package:clean_architecture/features/home/domain/user_cases/fetch_quick_read_books_use_case.dart';
// import 'package:clean_architecture/features/home/domain/user_cases/fetch_top_rated_books_use_case.dart';
// import 'package:clean_architecture/features/home/domain/user_cases/fetch_trending_books_use_case.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/manager/quick_read_books_cubit/quick_read_books_cubit_cubit.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/manager/selected_book_cubit.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/manager/topRatedBooksCubit/top_rated_books_cubit.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/manager/newsBooksCubit/news_books_cubit.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/manager/trendingBooks/trendin_books_cubit.dart';
// import 'package:clean_architecture/features/readingProgress/data/data_course/reading_progress_local_data_source.dart';
// import 'package:clean_architecture/features/readingProgress/data/data_course/reading_progress_remote_data_source.dart';
// import 'package:clean_architecture/features/readingProgress/data/repo/reading_progress_repo_impl.dart';
// import 'package:clean_architecture/features/readingProgress/domain/repo/reading_progress_repo.dart';
// import 'package:clean_architecture/features/readingProgress/presentaion/manager/reading_progress/reading_progress_cubit.dart';
// import 'package:clean_architecture/features/search/data/data_source/remote_search_books.dart';
// import 'package:clean_architecture/features/search/data/repo/search_books_repo.dart';
// import 'package:clean_architecture/features/search/domain/repo/search_book_repo.dart';
// import 'package:clean_architecture/features/search/domain/useCasees/search_book_use_case.dart';
// import 'package:clean_architecture/features/search/precentation/manager/search_books/search_books_cubit.dart';
// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';

// import '../../features/readingProgress/domain/useCase/get_last_read_book_use_case.dart';
// import '../../features/readingProgress/domain/useCase/save_reading_progress_use_case.dart';

// final getIt = GetIt.instance;

// void setupServiceLocator() {
//   // Core
//   getIt.registerLazySingleton<ApiService>(() => ApiService(Dio()));

//   //========================================================
//   //Feature Auth
//   //========================================================

//   getIt.registerFactory<AuthCubit>(
//     () => AuthCubit(loginUseCase: getIt(), registerUseCase: getIt()),
//   );

//   getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
//   getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()));
//   getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
//   getIt.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(getIt()),
//   );

//   //========================================================
//   //Feature Home Page
//   //========================================================

//   // 1. Data Sources
//   getIt.registerLazySingleton<HomeLocalDataSource>(
//     () => HomeLocalDataSourceImpl(),
//   );
//   getIt.registerLazySingleton<HomeRemoteDataSource>(
//     () => HomeRemoteDataSourceImpl(apiService: getIt()),
//   );

//   // 2. Repository
//   getIt.registerLazySingleton<HomeRepoImpl>(
//     () => HomeRepoImpl(
//       homeRemoteDataSource: getIt(),
//       homeLocalDataSource: getIt(),
//     ),
//   );

//   //3. Use cases
//   getIt.registerLazySingleton<FetchNewestUseCase>(
//     () => FetchNewestUseCase(getIt<HomeRepoImpl>()),
//   );
//   getIt.registerLazySingleton<FetchTopRatedBooksUseCase>(
//     () => FetchTopRatedBooksUseCase(getIt<HomeRepoImpl>()),
//   );
//   getIt.registerLazySingleton<FetchTrendingBooksUseCase>(
//     () => FetchTrendingBooksUseCase(getIt<HomeRepoImpl>()),
//   );
//   getIt.registerLazySingleton<FetchQuickReadBooksUseCase>(
//     () => FetchQuickReadBooksUseCase(getIt<HomeRepoImpl>()),
//   );
//   getIt.registerLazySingleton<FetchBooksUseCase>(
//     () => FetchBooksUseCase(getIt<HomeRepoImpl>()),
//   );

//   // 4. Cubit
//   getIt.registerLazySingleton<TopRatedBooksCubit>(
//     () => TopRatedBooksCubit(getIt<FetchTopRatedBooksUseCase>()),
//   );
//   getIt.registerLazySingleton<NewsBooksCubit>(
//     () => NewsBooksCubit(getIt<FetchNewestUseCase>()),
//   );
//   getIt.registerLazySingleton<TrendingBooksCubit>(
//     () => TrendingBooksCubit(getIt<FetchTrendingBooksUseCase>()),
//   );
//   getIt.registerLazySingleton<QuickReadBooksCubit>(
//     () => QuickReadBooksCubit(getIt<FetchQuickReadBooksUseCase>()),
//   );
//   getIt.registerFactory<SelectedBookCubit>(() => SelectedBookCubit());

//   //========================================================
//   //Feature Reading Progress
//   //========================================================

//   // 1. Data Sources
//   getIt.registerLazySingleton<ReadingProgressLocalDataSource>(
//     () => ReadingProgressLocalDataSourceImpl(),
//   );
//   getIt.registerLazySingleton<ReadingProgressRemoteDataSource>(
//     () => ReadingProgressRemoteDataSourceImpl(apiService: getIt()),
//   );

//   // 2. Repository
//   getIt.registerLazySingleton<ReadingProgressRepo>(
//     () => ReadingProgressRepoImpl(
//       remoteDataSource: getIt(),
//       localDataSource: getIt(),
//     ),
//   );

//   //3. Use cases
//   getIt.registerLazySingleton<SaveReadingProgressUseCase>(
//     () => SaveReadingProgressUseCase(getIt()),
//   );
//   getIt.registerLazySingleton<GetLastReadBookUseCase>(
//     () => GetLastReadBookUseCase(getIt()),
//   );

//   // 4. Cubit
//   // 4. Cubit
//   getIt.registerLazySingleton<ReadingProgressCubit>(
//     () => ReadingProgressCubit(
//       saveReadingProgressUseCase: getIt(),
//       getLastReadBookUseCase: getIt(),
//     ),
//   );

//   //========================================================
//   //Search Book Page
//   //========================================================

//   // data sourse
//   getIt.registerLazySingleton<RemoteSearchBooks>(
//     () => RemoteSearchBooksImp(apiService: getIt()),
//   );
//   //Repo
//   getIt.registerLazySingleton<SearchBooksRepo>(
//     () => SearchBooksRepoImp(remoteSearchBooks: getIt()),
//   );

//   // Use case
//   getIt.registerLazySingleton<FetchSearchBooksUseCase>(
//     () => FetchSearchBooksUseCase(getIt<SearchBooksRepo>()),
//   );

//   //Cubit
//   getIt.registerLazySingleton<SearchBooksCubit>(
//     () => SearchBooksCubit(getIt()),
//   );
// }
