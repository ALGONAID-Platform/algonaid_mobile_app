import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/lessons/lessons_list_page.dart';
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
