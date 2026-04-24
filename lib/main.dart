import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/appRouters.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/utils/providers/app_providers.dart';
import 'package:algonaid_mobail_app/core/theme/theme_provider.dart'; // Added
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // Added

void main() async {
  // Ensures that widget binding is initialized before any asynchronous operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter to support local data storage
  await Hive.initFlutter();

  // Custom initialization logic for Hive (e.g., registering adapters)

  // Initialize the TokenStorage box to manage user authentication tokens
  await TokenStorage.init();

  // Initialize SharedPreferences or custom caching helper for general app data
  await CacheHelper.init();

  // Initialize the Hive service instance for database operations
  await HiveService.init();

  // Set up the Service Locator (GetIt) to handle Dependency Injection across the app
  setupServiceLocator();

  // Launch the root widget of the application wrapped with global providers
  runApp(AppProviders(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryLight,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Algonaid Lessons',
          debugShowCheckedModeBanner: false,
          theme: ThemeApp.lightTheme,
          darkTheme: ThemeApp.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouters.routers,
        );
      },
    );
  }
}
