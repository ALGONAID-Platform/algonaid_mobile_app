import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/appRouters.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/utils/providers/app_providers.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  
  // تهيئة تخزين التوكن
  // await TokenStorage.init();

  // Register adapters and open all Hive boxes used by the app.
  await HiveService.init();

  // Initialize SharedPreferences or custom caching helper ssssfor general app data
  await CacheHelper.init();

  // Set up the Service Locator (GetIt) to handle Dependency Injection across the app
  setupServiceLocator();

  // جلب الحالة المحفوظة قبل تشغيل التطبيق لتجنب الوميض (Flicker)
  final isDark = CacheHelper.getBool(key: 'isDarkMode') ?? false;
  final initTheme = isDark ? ThemeApp.darkTheme : ThemeApp.lightTheme;

  runApp(
    AppProviders(
      child: MyApp(initTheme: initTheme),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData initTheme;
  const MyApp({super.key, required this.initTheme});

  @override
  Widget build(BuildContext context) {
    // إعدادات شريط الحالة (Status Bar Configuration)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // شفاف ليبدو أجمل مع الأنميشن
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return ThemeProvider(
      initTheme: initTheme,
      // الـ duration هنا يتحكم في سرعة انتشار الدائرة (نفس سرعة تليجرام تقريباً)
      duration: const Duration(milliseconds: 500), 
      builder: (context, myTheme) {
        return MaterialApp.router(
          title: 'Algonaid Lessons',
          debugShowCheckedModeBanner: false,
          theme: myTheme, // يتم إدارة السمة بالكامل بواسطة ThemeProvider
          routerConfig: AppRouters.routers,
          // إضافة Builder هنا مهمة جداً لضمان عمل الـ ThemeSwitcher في الصفحات الداخلية
          builder: (context, child) {
            return ThemeSwitchingArea(
              child: child!,
            );
          },
        );
      },
    );
  }
}