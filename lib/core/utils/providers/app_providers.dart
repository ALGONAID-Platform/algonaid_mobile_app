// lib/core/providers/app_providers.dart

import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/data/services/lesson_download_service.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
      final getIt = GetIt.instance; //Service Locator

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthServiceProvider>()),
        Provider<GetModuleLessons>(create: (_) => getIt<GetModuleLessons>()),
        Provider<GetLessonDetail>(create: (_) => getIt<GetLessonDetail>()),
        Provider<LessonDownloadService>(
          create: (_) => getIt<LessonDownloadService>(),
        ),
      ],
      child: child,
    );
  }
}
