import 'package:algonaid/core/di/service_locator.dart';
import 'package:algonaid/core/routes/appRouters.dart';
import 'package:algonaid/core/theme/theme.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/utils/hive/hive_setup.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:algonaid/core/utils/providers/app_providers.dart';
import 'package:algonaid/core/utils/notification_service.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/theme/theme_provider.dart'
    as app_theme;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:algonaid/features/lesson_detail/presentation/controllers/global_video_state.dart';
import 'package:algonaid/features/lesson_detail/presentation/controllers/native_pip_handler.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/floating_video_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/core/routes/navigatorKey.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إيقاف طباعة السجلات والـ Debug Logs تلقائياً في نسخة المتجر النهائية لحماية البيانات وتحسين الأداء
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // تهيئة أداة التحميل بالخلفية لضمان عملها بشكل مستقل عن حالة التطبيق
  if (!kIsWeb) {
    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  // تهيئة تخزين التوكن
  // await TokenStorage.init();

  // Register adapters and open all Hive boxes used by the app.
  await HiveService.init();

  // Initialize Notification Service
  await NotificationService().init();

  // Initialize SharedPreferences or custom caching helper ssssfor general app data
  await CacheHelper.init();
  await TokenStorage.init();

  // Set up the Service Locator (GetIt) to handle Dependency Injection across the app
  setupServiceLocator();

  // جلب الحالة المحفوظة قبل تشغيل التطبيق لتجنب الوميض (Flicker)
  final isDark = CacheHelper.getBool(key: 'isDarkMode') ?? false;
  final colorIndex = CacheHelper.getInt(key: 'primaryColorIndex') ?? 0;
  final fontIndex = CacheHelper.getInt(key: 'fontFamilyIndex') ?? 0;
  final initTheme = isDark
      ? ThemeApp.getDarkTheme(colorIndex: colorIndex, fontIndex: fontIndex)
      : ThemeApp.getLightTheme(colorIndex: colorIndex, fontIndex: fontIndex);

  runApp(AppProviders(child: MyApp(initTheme: initTheme)));
}

class MyApp extends StatefulWidget {
  final ThemeData initTheme;
  const MyApp({super.key, required this.initTheme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // User is active, so cancel any scheduled retention notifications
    NotificationService().cancelRetentionNotifications();
    _initAppLinks();
  }

  void _initAppLinks() {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path == '/verify-email' || uri.path == '/api/v1/auth/verify-email' || uri.path == '/auth/verify-email') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          final context = navigatorKey.currentContext;
          if (context != null) {
            _verifyEmailToken(context, token);
          }
        });
      }
    } else if (uri.path == '/reset-password' || uri.path == '/api/v1/auth/reset-password' || uri.path == '/auth/reset-password') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          final context = navigatorKey.currentContext;
          if (context != null) {
            context.go(Routes.resetPassword, extra: token);
          }
        });
      }
    }
  }

  void _verifyEmailToken(BuildContext context, String token) async {
    final authProvider = Provider.of<AuthServiceProvider>(context, listen: false);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await authProvider.verifyEmail(token);
    final isAlreadyVerified = authProvider.errorMessage != null && authProvider.errorMessage!.contains('بالفعل');
    
    if (context.mounted) {
      // hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (success || isAlreadyVerified) {
       // Refresh user state if possible
       await authProvider.restoreSession();
       
       if (authProvider.user != null) {
          navigatorKey.currentContext?.go(Routes.homePage);
       } else {
          navigatorKey.currentContext?.go(Routes.auth);
          if (navigatorKey.currentContext != null) {
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              const SnackBar(content: Text('تم تأكيد البريد الإلكتروني بنجاح. يرجى تسجيل الدخول.')),
            );
          }
       }
    } else {
       navigatorKey.currentContext?.go(Routes.emailVerifyFailed, extra: authProvider.errorMessage);
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // User left the app, schedule retention notifications
      NotificationService().scheduleRetentionNotifications();
    } else if (state == AppLifecycleState.resumed) {
      // User came back, cancel them
      NotificationService().cancelRetentionNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    // إعدادات شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final appThemeProvider = context.watch<app_theme.ThemeProvider>();
    final currentTheme = appThemeProvider.isDarkMode
        ? ThemeApp.getDarkTheme(
            colorIndex: appThemeProvider.colorIndex,
            fontIndex: appThemeProvider.fontIndex,
          )
        : ThemeApp.getLightTheme(
            colorIndex: appThemeProvider.colorIndex,
            fontIndex: appThemeProvider.fontIndex,
          );

    // ThemeProvider (animated) ضروري كـ ancestor لـ ThemeSwitchingArea
    // نستخدم myTheme لضمان سلاسة حركة التبديل الدائرية دون وميض
    return ThemeProvider(
      initTheme: currentTheme,
      duration: const Duration(milliseconds: 1100),
      builder: (context, myTheme) {
        return MaterialApp.router(
          title: 'Algonaid Lessons',
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          routerConfig: AppRouters.routers,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          builder: (context, child) {
            return ThemeSwitchingArea(
              child: ValueListenableBuilder<bool>(
                valueListenable: NativePipHandler().isInPipMode,
                builder: (context, isPip, widgetChild) {
                  return Stack(
                    children: [
                      // Keep the app alive in the background to prevent state loss
                      widgetChild!,
                      
                      // In Native PIP mode, show only the VideoPlayer with black background
                      if (isPip && GlobalVideoState().videoPlayerController != null)
                        Positioned.fill(
                          child: Material(
                            color: Colors.black,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: GlobalVideoState()
                                    .videoPlayerController!
                                    .value
                                    .aspectRatio,
                                child: VideoPlayer(
                                  GlobalVideoState().videoPlayerController!,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Normal In-App floating video
                      if (!isPip)
                        ValueListenableBuilder<bool>(
                          valueListenable: GlobalVideoState().isFloatingNotifier,
                          builder: (context, isFloating, _) {
                            if (isFloating && GlobalVideoState().currentLessonId != null) {
                              return FloatingVideoWidget(
                                lessonId: GlobalVideoState().currentLessonId!,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  );
                },
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: UpgradeAlert(
                    upgrader: Upgrader(
                      messages: UpgraderMessages(code: 'ar'),
                    ),
                    navigatorKey: navigatorKey,
                    child: child!,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
