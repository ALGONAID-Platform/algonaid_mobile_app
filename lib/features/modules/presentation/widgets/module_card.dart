import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.module, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // قيمة افتراضية للتقدم
    double progress = 0.5;

    return Directionality(
      textDirection:
          TextDirection.ltr, // لضمان الترتيب العربي (السهم يمين، المربع يسار)
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // استخدام ألوان السطح المعرفة في ملفك
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                // استخدام ألوان الحدود والتقسيم المعرفة لديك
                color: isDark ? AppColors.indigoDark : AppColors.grey200,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : AppColors.shadow,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // 1. أيقونة السهم (جهة اليمين)
                Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.grey400,
                  size: 18,
                ),

                const SizedBox(width: 16),

                // 2. المحتوى النصي وشريط التقدم في المنتصف
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // عنوان الوحدة (يأخذ اللون تلقائياً من الثيم)
                      Text(
                        module.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // وصف الوحدة
                      Text(
                        module.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // شريط التقدم النحيف
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            // استخدام ألوان التقدم والخلفية من ملفك
                            backgroundColor: isDark
                                ? AppColors.indigoDark
                                : AppColors.grey100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors
                                  .primary, // اللون الأخضر التيل الأساسي في هويتك
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 3. مربع النسبة المئوية في جهة اليسار
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    // استخدام اللون الفاتح جداً من التيل في الوضع الفاتح
                    color: isDark
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors
                              .grey50, // أو استخدم درجات الـ grey الموجودة في ملفك
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
