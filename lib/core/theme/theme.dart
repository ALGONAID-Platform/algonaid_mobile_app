import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // للتحكم في شريط الحالة (Status Bar)

class ThemeApp {
  static const String fontFamily = 'Readex Pro';

  // ===========================================================================
  // ☀️ Light Theme
  // ===========================================================================
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: fontFamily,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bgLight,
        
        // 1. Color Scheme (العمود الفقري للألوان)
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.indigo,
          surface: AppColors.surfaceLight,
          error: AppColors.red,
        ),

        // 2. AppBar Theme (الشريط العلوي)
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          scrolledUnderElevation: 0, // لمنع تغيير اللون عند السكرول
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
          systemOverlayStyle: SystemUiOverlayStyle.dark, // أيقونات البطارية والساعة سوداء
        ),

        // 3. Button Theme (الأزرار)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white, // لون النص
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),

        // 4. Input Decoration Theme (حقول الإدخال - أهم جزء) 🔥
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // الحواف العادية
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          // الحواف عند التركيز (الكتابة)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          // الحواف عند الخطأ
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.red),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
        ),

        // 5. Text Theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight), // النص العادي
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight), // النص الفرعي
        ),
      );

  // ===========================================================================
  // 🌑 Dark Theme
  // ===========================================================================
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bgDark,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.indigo,
          surface: AppColors.surfaceDark,
          error: AppColors.red,
        ),

        // AppBar Dark
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryDark,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          systemOverlayStyle: SystemUiOverlayStyle.light, // أيقونات البطارية بيضاء
        ),

        // Button Dark
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
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
            borderSide: const BorderSide(color: AppColors.grey200), // قد تحتاج لون أغمق هنا
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        ),

        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimaryDark),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
        ),
      );
}