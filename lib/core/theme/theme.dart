import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MotionTheme extends ThemeExtension<MotionTheme> {
  final Duration fast;
  final Duration medium;
  final Duration slow;
  final Curve standard;
  final Curve emphasized;

  const MotionTheme({
    required this.fast,
    required this.medium,
    required this.slow,
    required this.standard,
    required this.emphasized,
  });

  static const MotionTheme defaults = MotionTheme(
    fast: Duration(milliseconds: 180),
    medium: Duration(milliseconds: 320),
    slow: Duration(milliseconds: 520),
    standard: Curves.easeOutCubic,
    emphasized: Curves.easeInOutCubic,
  );

  @override
  MotionTheme copyWith({
    Duration? fast,
    Duration? medium,
    Duration? slow,
    Curve? standard,
    Curve? emphasized,
  }) {
    return MotionTheme(
      fast: fast ?? this.fast,
      medium: medium ?? this.medium,
      slow: slow ?? this.slow,
      standard: standard ?? this.standard,
      emphasized: emphasized ?? this.emphasized,
    );
  }

  @override
  MotionTheme lerp(ThemeExtension<MotionTheme>? other, double t) {
    if (other is! MotionTheme) return this;
    return MotionTheme(
      fast: lerpDuration(fast, other.fast, t),
      medium: lerpDuration(medium, other.medium, t),
      slow: lerpDuration(slow, other.slow, t),
      standard: t < 0.5 ? standard : other.standard,
      emphasized: t < 0.5 ? emphasized : other.emphasized,
    );
  }

  Duration lerpDuration(Duration a, Duration b, double t) {
    return Duration(
      milliseconds:
          (a.inMilliseconds + (b.inMilliseconds - a.inMilliseconds) * t)
              .round(),
    );
  }
}

class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }

    final motion = Theme.of(context).extension<MotionTheme>() ??
        MotionTheme.defaults;
    final curved = CurvedAnimation(
      parent: animation,
      curve: motion.standard,
      reverseCurve: motion.emphasized,
    );

    final fade = FadeTransition(opacity: curved, child: child);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(curved),
      child: fade,
    );
  }
}

class ThemeApp {
  static const String headingFontFamily = 'Inter';
  static const String bodyFontFamily = 'Roboto';

  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color primaryText =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color secondaryText =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final TextTheme headings = GoogleFonts.interTextTheme();
    final TextTheme body = GoogleFonts.robotoTextTheme();

    return headings.copyWith(
      displayLarge: headings.displayLarge?.copyWith(
        fontSize: 49,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displayMedium: headings.displayMedium?.copyWith(
        fontSize: 39,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displaySmall: headings.displaySmall?.copyWith(
        fontSize: 31,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: headings.headlineMedium?.copyWith(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineSmall: headings.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
      bodyMedium: body.bodyMedium?.copyWith(  //default theme
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
    );
  }

  // ===========================================================================
  // ☀️ Light Theme
  // ===========================================================================
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: headingFontFamily,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bgLight,

        // 1. Color Scheme (العمود الفقري للألوان)
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.indigo,
          surface: AppColors.surfaceLight,
          background: AppColors.bgLight,
          error: AppColors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.textPrimaryLight,
          onBackground: AppColors.textPrimaryLight,
          onError: AppColors.white,
        ),

        // 2. AppBar Theme (الشريط العلوي)
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: headingFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        // 3. Button Theme (الأزرار)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),

        // 4. Input Decoration Theme (حقول الإدخال)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.red),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
        ),

        // 5. Text Theme
        textTheme: _buildTextTheme(isDark: false),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
            TargetPlatform.iOS: FadeSlidePageTransitionsBuilder(),
          },
        ),
        extensions: const <ThemeExtension<dynamic>>[
          MotionTheme.defaults,
        ],
      );

  // ===========================================================================
  // 🌑 Dark Theme
  // ===========================================================================
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: headingFontFamily,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bgDark,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.indigo,
          surface: AppColors.surfaceDark,
          background: AppColors.bgDark,
          error: AppColors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.textPrimaryDark,
          onBackground: AppColors.textPrimaryDark,
          onError: AppColors.white,
        ),

        // AppBar Dark
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: headingFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryDark,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        // Button Dark
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        // Input Dark
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.indigoDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.indigoDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        ),

        textTheme: _buildTextTheme(isDark: true),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
            TargetPlatform.iOS: FadeSlidePageTransitionsBuilder(),
          },
        ),
        extensions: const <ThemeExtension<dynamic>>[
          MotionTheme.defaults,
        ],
      );
}
