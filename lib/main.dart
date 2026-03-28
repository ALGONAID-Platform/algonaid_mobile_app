import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lessons_list_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await TokenStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => Dio()),
        Provider<ApiService>(
          create: (context) => ApiService(context.read<Dio>()),
        ),
        Provider<LessonRemoteDataSource>(
          create: (context) => LessonRemoteDataSourceImpl(
            context.read<ApiService>(),
          ),
        ),
        Provider<LessonRepository>(
          create: (context) => LessonRepositoryImpl(
            context.read<LessonRemoteDataSource>(),
          ),
        ),
        Provider<GetModuleLessons>(
          create: (context) => GetModuleLessons(
            context.read<LessonRepository>(),
          ),
        ),
        Provider<GetLessonDetail>(
          create: (context) => GetLessonDetail(
            context.read<LessonRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Algonaid Lessons',
        debugShowCheckedModeBanner: false,
        theme: ThemeApp.lightTheme,
        darkTheme: ThemeApp.darkTheme,
        themeMode: ThemeMode.system,
        home: const LessonsListPage(
          moduleId: 4,
          moduleTitle: 'دروس الوحدة الرابعة',
        ),
      ),
    );
  }
}
