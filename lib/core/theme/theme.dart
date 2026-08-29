import 'package:algonaid/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeApp {
  static final List<Color> availableColors = [
    AppColors.primary,
    Colors.blue,
    const Color(0xFFE91E63), // Pink/Red
    Colors.orange,
    Colors.purple,
  ];

  static final List<String> availableFonts = [
    'IBM Plex Sans Arabic',
    'Cairo',
    'Tajawal',
    'Almarai',
    'Changa',
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

  static TextTheme _buildTextTheme({
    required bool isDark,
    required int fontIndex,
  }) {
    final String fontFamily = getAppFontFamily(fontIndex);
    final Color primaryText = isDark
        ? AppColors.textPrimaryDark.withOpacity(0.85)
        : AppColors.textPrimaryLight;
    final Color secondaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.65)
        : AppColors.textSecondaryLight;
    final Color tertiaryText = isDark
        ? AppColors.textSecondaryDark.withOpacity(0.45)
        : AppColors.textSecondaryLight.withOpacity(0.70);

    TextTheme baseTextTheme = ThemeData.light().textTheme;

    return baseTextTheme.copyWith(
      // --- عائلة الـ Display ---
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: primaryText,
        letterSpacing: 0,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),

      // --- عائلة الـ Headline ---
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Title ---
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // --- عائلة الـ Body ---
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),

      // --- عائلة الـ Label ---
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiaryText,
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
      appBarTheme: AppBarTheme(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),

      // 4. Input Decoration Theme (حقول الإدخال)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
      textTheme: _buildTextTheme(isDark: false, fontIndex: fontIndex),

      // 6. TimePicker Theme
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.bgLight,
        dayPeriodColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor.withOpacity(0.2) : AppColors.surfaceLight),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor : AppColors.textSecondaryLight),
        hourMinuteColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor.withOpacity(0.2) : AppColors.surfaceLight),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor : AppColors.textPrimaryLight),
        dialBackgroundColor: AppColors.surfaceLight,
        dialHandColor: primaryColor,
      ),
    );
  }

  // ===========================================================================
  // 🌑 Dark Theme
  // ===========================================================================
  static ThemeData getDarkTheme({int colorIndex = 0, int fontIndex = 0}) {
    final primaryColor = getPrimaryColor(colorIndex);
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

        surfaceContainer: AppColors.surfaceDark,
        onBackground: AppColors.textPrimaryDark,
        onError: AppColors.white,
      ),

      // 2. AppBar Theme
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
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // 3. Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // 4. Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
      ),

      // 5. Text Theme
      textTheme: _buildTextTheme(isDark: true, fontIndex: fontIndex),

      // 6. TimePicker Theme
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceDark,
        dayPeriodColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor.withOpacity(0.3) : AppColors.bgDark),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? AppColors.white : AppColors.textSecondaryDark),
        hourMinuteColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? primaryColor.withOpacity(0.3) : AppColors.bgDark),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? AppColors.white : AppColors.textPrimaryDark),
        dialBackgroundColor: AppColors.bgDark,
        dialHandColor: primaryColor,
      ),
    );
  }
}
