import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static final List<Color> availableColors = [
    AppColors.primary,
    Colors.blue,
    const Color(0xFFE91E63), // Pink/Red
    Colors.orange,
    Colors.purple,
  ];

  static final List<String> availableFonts = [
    GoogleFonts.ibmPlexSansArabic().fontFamily ?? 'IBM Plex Sans Arabic',
    GoogleFonts.cairo().fontFamily ?? 'Cairo',
    GoogleFonts.tajawal().fontFamily ?? 'Tajawal',
    GoogleFonts.almarai().fontFamily ?? 'Almarai',
    GoogleFonts.changa().fontFamily ?? 'Changa',
  ];

  static String getAppFontFamily(int index) {
    if (index >= 0 && index < availableFonts.length) {
      return availableFonts[index];
    }
    return availableFonts[0];
  }

  static Color getPrimaryColor(int index) {
    if (index >= 0 && index < availableColors.length) {
      return availableColors[index];
    }
    return availableColors[0];
  }

  static TextTheme _buildTextTheme({required bool isDark, required String fontFamily}) {
    final Color primaryText = isDark
        ? AppColors.textPrimaryDark.withOpacity(0.85)
        : AppColors.textPrimaryLight;
    final Color secondaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.65)
        : AppColors.textSecondaryLight;
    final Color tertiaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.45) // خافت جداً
        : AppColors.textSecondaryLight.withOpacity(0.70);
    final TextTheme baseTextTheme = ThemeData.light().textTheme.apply(fontFamily: fontFamily);

    return baseTextTheme.copyWith(
      // --- عائلة الـ Display (للأرقام الكبيرة والترحيب) ---
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w800, // عريض جداً
        color: primaryText,
        letterSpacing: 0, // العربية لا تحتاج مسافات بين الحروف
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),

      // --- عائلة الـ Headline (عناوين الصفحات والأقسام) ---
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        // أضفت Large للكمال
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Title (عناوين الكروت والأشرطة) ---
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600, // تم التعديل إلى 600 ليبرز كعنوان
        color: primaryText,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Body (النصوص القرائية والوصف) ---
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText, // محتوى أساسي
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText, // النص الافتراضي يفضل أن يكون أهدأ قليلاً
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12, // تم الرفع من 10 إلى 12 لأن 10 صغير جداً للعربي
        fontWeight: FontWeight.w400,
        color: secondaryText, // الوصف الباهت
      ),

      // --- عائلة الـ Label (الأزرار والتاغات) ---
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText, // نص الأزرار
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiaryText, // التاغات الصغيرة جداً
      ),
    );
  }

  // ===========================================================================
  // ☀️ Light Theme
  // ===========================================================================
  static ThemeData getLightTheme({int colorIndex = 0, int fontIndex = 0}) {
    final primaryColor = getPrimaryColor(colorIndex);
    final appFontFamily = getAppFontFamily(fontIndex);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: appFontFamily,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: AppColors.bgLight,

    // 1. Color Scheme (العمود الفقري للألوان)
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: AppColors.indigo,
      surface: AppColors.surfaceLight,
      background: AppColors.bgLight,
      error: AppColors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.textPrimaryLight,
      surfaceContainer: AppColors.white,

      onBackground: AppColors.textPrimaryLight,
      onError: AppColors.white,
    ),

    // 2. AppBar Theme (الشريط العلوي)
    appBarTheme:  AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.bgLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: appFontFamily,
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
        backgroundColor: primaryColor,
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
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
    ),

    // 5. Text Theme
    textTheme: _buildTextTheme(isDark: false, fontFamily: appFontFamily),
    );
  }

  // ===========================================================================
  // 🌑 Dark Theme
  // ===========================================================================
  static ThemeData getDarkTheme({int colorIndex = 0, int fontIndex = 0}) {
    final primaryColor = Colors.blue; // Always blue in dark mode
    final appFontFamily = getAppFontFamily(fontIndex);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: appFontFamily,
      primaryColor: primaryColor,
    scaffoldBackgroundColor: AppColors.bgDark,

    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: AppColors.indigo,
      surface: AppColors.cardDark,
      onSurface: AppColors.white,
      background: AppColors.bgDark,
      error: AppColors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,

      surfaceContainer: Color(0xFF212E3E),
      onBackground: AppColors.textPrimaryDark,
      onError: AppColors.white,
    ),

    // AppBar Dark
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.bgDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: appFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Button Dark
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
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
        borderSide: BorderSide(color: primaryColor),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
    ),

    textTheme: _buildTextTheme(isDark: true, fontFamily: appFontFamily),
    );
  }
}
