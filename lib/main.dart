import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/appRouters.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/providers/app_providers.dart';
import 'package:algonaid_mobail_app/core/utils/notification_service.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/global_video_state.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/native_pip_handler.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/floating_video_widget.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  
  // تهيئة تخزين التوكن
  // await TokenStorage.init();

  // Register adapters and open all Hive boxes used by the app.
  await HiveService.init();

  // Initialize Notification Service
  await NotificationService().init();

  // Initialize SharedPreferences or custom caching helper ssssfor general app data
  await CacheHelper.init();

  // Set up the Service Locator (GetIt) to handle Dependency Injection across the app
  setupServiceLocator();

  // جلب الحالة المحفوظة قبل تشغيل التطبيق لتجنب الوميض (Flicker)
  final isDark = CacheHelper.getBool(key: 'isDarkMode') ?? false;
  final colorIndex = CacheHelper.getInt(key: 'primaryColorIndex') ?? 0;
  final fontIndex = CacheHelper.getInt(key: 'fontFamilyIndex') ?? 0;
  final initTheme = isDark 
      ? ThemeApp.getDarkTheme(colorIndex: colorIndex, fontIndex: fontIndex) 
      : ThemeApp.getLightTheme(colorIndex: colorIndex, fontIndex: fontIndex);

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
              child: ValueListenableBuilder<bool>(
                valueListenable: NativePipHandler().isInPipMode,
                builder: (context, isPip, widgetChild) {
                  if (isPip && GlobalVideoState().videoPlayerController != null) {
                    return Material(
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: GlobalVideoState().videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(GlobalVideoState().videoPlayerController!),
                          ),
                        ),
                      ),
                    );
                  }
                  return ValueListenableBuilder<bool>(
                    valueListenable: GlobalVideoState().isFloatingNotifier,
                    builder: (context, isFloating, _) {
                      return Stack(
                        children: [
                          widgetChild!,
                          if (isFloating && GlobalVideoState().currentLessonId != null)
                            FloatingVideoWidget(
                              lessonId: GlobalVideoState().currentLessonId!,
                            ),
                        ],
                      );
                    },
                  );
                },
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}