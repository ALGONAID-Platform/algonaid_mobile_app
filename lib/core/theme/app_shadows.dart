import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppShadows {
  
  // 1. الظل الناعم (للكروت والعناصر البسيطة)
  static final BoxShadow soft = BoxShadow(
    color: AppColors.shadow.withOpacity(0.1), // نستخدم لون الظل بشفافية خفيفة
    offset: const Offset(0, 4), // اتجاه الظل للأسفل قليلاً
    blurRadius: 10, // نعومة الظل
    spreadRadius: 0,
  );

  // 2. الظل المتوسط (للأزرار العائمة والقوائم المنسدلة)
  static final BoxShadow medium = BoxShadow(
    color: AppColors.shadow.withOpacity(0.15),
    offset: const Offset(0, 6),
    blurRadius: 20,
    spreadRadius: 0,
  );

  // 3. الظل العميق (للنوافذ المنبثقة والـ Dialogs)
  static final BoxShadow dialog = BoxShadow(
    color: AppColors.shadow.withOpacity(0.2), 
    offset: const Offset(0, 10),
    blurRadius: 40,
    spreadRadius: -5, // نجعل الظل أصغر قليلاً ليعطي إيحاء بالارتفاع العالي
  );

  // 4. توهج اللون الأساسي (Primary Glow) - لمسة عصرية جداً
  static final BoxShadow primaryGlow = BoxShadow(
    color: AppColors.primary.withOpacity(0.3), // نستخدم لون البراند نفسه
    offset: const Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );

  // 5. ظل الشريط السفلي (Navigation Bar Shadow)
  static final BoxShadow reverse = BoxShadow(
    color: AppColors.shadow.withOpacity(0.08),
    offset: const Offset(0, -4), // الظل يتجه للأعلى (سالب)
    blurRadius: 10,
    spreadRadius: 0,
  );
}