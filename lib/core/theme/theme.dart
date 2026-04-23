import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static const String headingFontFamily = 'Inter';
  static const String bodyFontFamily = 'Roboto';
  static const String primaryFontFamily = 'Cairo';

  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color primaryText = isDark
        ? AppColors.textPrimaryDark.withOpacity(0.85)
        : AppColors.textPrimaryLight;
    final Color secondaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.65)
        : AppColors.textSecondaryLight;
    final Color tertiaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.45) // خافت جداً
        : AppColors.textSecondaryLight.withOpacity(0.70);
    final TextTheme headings = GoogleFonts.readexProTextTheme();
    final TextTheme body = GoogleFonts.readexProTextTheme();

    return headings.copyWith(
      // --- عائلة الـ Display (للأرقام الكبيرة والترحيب) ---
      displayLarge: headings.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w800, // عريض جداً
        color: primaryText,
        letterSpacing: 0, // العربية لا تحتاج مسافات بين الحروف
      ),
      displayMedium: headings.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displaySmall: headings.displaySmall?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),

      // --- عائلة الـ Headline (عناوين الصفحات والأقسام) ---
      headlineLarge: headings.headlineLarge?.copyWith(
        // أضفت Large للكمال
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: headings.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineSmall: headings.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Title (عناوين الكروت والأشرطة) ---
      titleLarge: body.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600, // تم التعديل إلى 600 ليبرز كعنوان
        color: primaryText,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Body (النصوص القرائية والوصف) ---
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText, // محتوى أساسي
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText, // النص الافتراضي يفضل أن يكون أهدأ قليلاً
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 12, // تم الرفع من 10 إلى 12 لأن 10 صغير جداً للعربي
        fontWeight: FontWeight.w400,
        color: secondaryText, // الوصف الباهت
      ),

      // --- عائلة الـ Label (الأزرار والتاغات) ---
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText, // نص الأزرار
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiaryText, // التاغات الصغيرة جداً
      ),
    );
  }

  // ===========================================================================
  // ☀️ Light Theme
  // ===========================================================================
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: primaryFontFamily,
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
      onSecondary: AppColors.textPrimaryLight,
      surfaceContainer: AppColors.white,

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
      primary: Color(0xFF2397E9),
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
  );
}
