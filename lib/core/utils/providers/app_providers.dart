// lib/core/providers/app_providers.dart

import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart'; // Added
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/update_lesson_progress.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart'; // Added
import 'package:algonaid_mobail_app/features/onboard/presentaion/providers/onboarding_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
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
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(
          create: (_) => GetCoursesProvider(
            enrollmentUseCase: getIt(),
            coursesUsecase: getIt(),
            myCoursesUsecase: getIt(),
            courseProgressUsecase: getIt(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<LastAccessedModuleProvider>(),
        ),
        Provider<GetLessonDetail>( // Added
          create: (_) => getIt<GetLessonDetail>(),
        ),
        Provider<UpdateLessonProgress>( // Added
          create: (_) => getIt<UpdateLessonProgress>(),
        ),
        ChangeNotifierProvider<LessonDetailProvider>( // Added
          create: (context) => LessonDetailProvider(
            context.read<GetLessonDetail>(),
            context.read<UpdateLessonProgress>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
