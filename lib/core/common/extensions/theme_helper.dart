import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  // 1. الوصول العام للثيم والـ ColorScheme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;

  // 2. الألوان الأساسية (Main Palette)
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;

  // 3. ألوان الحاويات (Container Colors - ممتازة لخلفيات الأيقونات والبطاقات البسيطة)
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  // 4. ألوان الأسطح والخلفيات (Surface & Background)
  Color get background => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;
  Color get surface => colorScheme.surface;
  Color get surfaceContainer => colorScheme.surfaceContainer;

  // سطح متغير (مثالي لشريط البحث أو الـ Navigation Bar)
  Color get surfaceVariant => colorScheme.surfaceVariant;

  // 5. الألوان التنبيهية (Functional Colors)
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get outline => colorScheme.outline; // مثالي للحدود (Borders)

  // 6. الألوان العكسية (Inverse Colors - تستخدم غالباً في الـ SnackBars)
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;

  // 7. الوصول السريع للنصوص (TextTheme)
  TextTheme get textTheme => theme.textTheme;

  // عناوين (Headings)
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;

  // نصوص المحتوى (Body)
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  // 8. خصائص إضافية مفيدة
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // الحصول على أبعاد الشاشة بسهولة
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
