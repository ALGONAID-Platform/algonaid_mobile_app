// lib/core/providers/app_providers.dart

import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:algonaid/features/lesson_detail/domain/usecases/get_lesson_detail.dart'; // Added
import 'package:algonaid/features/lesson_detail/domain/usecases/update_lesson_progress.dart';
import 'package:algonaid/features/lesson_detail/presentation/providers/lesson_detail_provider.dart'; // Added
import 'package:algonaid/features/onboard/presentation/providers/onboarding_provider.dart';
import 'package:algonaid/core/theme/theme_provider.dart'; // Added
import 'package:algonaid/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid/features/downloads/presentation/providers/downloads_provider.dart';
import 'package:algonaid/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid/features/practice_exams/presentation/providers/practice_exams_provider.dart';
import 'package:algonaid/features/downloads/presentation/providers/active_downloads_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthServiceProvider>()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Added
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(
          create: (_) => GetCoursesProvider(
            enrollmentUseCase: getIt(),
            coursesUsecase: getIt(),
            myCoursesUsecase: getIt(),
            courseProgressUsecase: getIt(), getCachedCoursesUsecase:getIt() , getCachedMyCoursesUsecase: getIt(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<LastAccessedModuleProvider>(),
        ),
        Provider<GetLessonDetail>(
          // Added
          create: (_) => getIt<GetLessonDetail>(),
        ),
        Provider<UpdateLessonProgress>(
          // Added
          create: (_) => getIt<UpdateLessonProgress>(),
        ),
        ChangeNotifierProvider<LessonDetailProvider>(
          // Added
          create: (context) => LessonDetailProvider(
            context.read<GetLessonDetail>(),
            context.read<UpdateLessonProgress>(),
            getIt<GetModuleLessons>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ModulesListProvider(getIt(), getIt())),
        ChangeNotifierProvider(create: (_) => LessonsListProvider(getIt(), getIt())),
        ChangeNotifierProvider(create: (_) => DownloadsProvider()),
        ChangeNotifierProvider(create: (_) => ActiveDownloadsProvider()),
        ChangeNotifierProvider(
          create: (_) => getIt<ExcellenceCoursesProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PracticeExamsProvider>()),
      ],
      child: child,
    );
  }
}
