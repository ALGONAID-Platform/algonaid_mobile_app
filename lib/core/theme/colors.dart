import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF1e3c72); // Deep Blue
  static const Color primaryLight = Color(0xFF2a5298); // Lighter Blue
  static const Color indigo = Color(0xFF6366F1); // Indigo
  static const Color indigoDark = Color(0xFF4F46E5); // Darker Indigo

  // Secondary/Accent Colors
  static const Color amber = Color(0xFFF59E0B); // Rating/Warning
  static const Color red = Color(0xFFEF4444); // Error
  static const Color green = Color(0xFF10B981); // Success

  // Background Colors
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;

  static const Color grey50 = Color(0xFFF8FAFC); // فاتح جداً (خلفيات)
  static const Color grey100 = Color(0xFFF1F5F9); // فاتح
  static const Color grey200 = Color(0xFFE2E8F0); // حدود الحقول (Borders)
  static const Color grey300 = Color(0xFFCBD5E1); // أيقونات معطلة
  static const Color grey400 = Color(0xFF94A3B8); // نص غير مهم

  // 2. State Colors (حالات إضافية)
  // عادة نحتاج لون للأزرار المعطلة (Disabled Button)
  static const Color disabledButton = Color(0xFFCBD5E1);
  static const Color disabledText = Color(0xFF94A3B8);

  // 3. UI Elements (عناصر الواجهة)
  // لون الخط الفاصل بين العناصر
  static const Color divider = Color(0xFFE2E8F0);

  // لون الحدود الافتراضي (لحقول الإدخال مثلاً)
  static const Color border = Color(0xFFE2E8F0);

  // لون الظل (أفضل من الأسود الصريح لأنه أنعم)
  static const Color shadow = Color(0x1F000000); // أسود شفاف بنسبة 12%

  // لون الخلفية المعتمة (عند فتح Dialog)
  static const Color overlay = Color(0x66000000); // أسود شفاف بنسبة 40%

  // 4. Shimmer Colors (لتأثير التحميل - Skeleton Loading)
  // مهمة جداً لتبدو احترافياً أثناء جلب البيانات
  static const Color shimmerBase = Color(0xFFE0E0E0); // اللون الأساسي
  static const Color shimmerHighlight = Color(0xFFF5F5F5); // لون اللمعة

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [indigo, indigoDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
