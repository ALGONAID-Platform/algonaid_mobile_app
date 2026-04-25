import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonTabs extends StatelessWidget {
  final String? description;
  final String? content;

  const LessonTabs({super.key, this.description, this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(18),
          // دمج الحواف الديناميكية للوضع الداكن/الفاتح
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : context.primary.withOpacity(0.10),
          ),
          // إخفاء الظلال في الوضع الداكن واستخدام AppShadows في الفاتح
          boxShadow: isDark ? const [] : AppShadows.cardShadow,
        ),
        child: Column(
          children: [
            TabBar(
              // استخدام context.primary بدلاً من استدعاء AppColors مباشرة لتوحيد النمط
              labelColor: context.primary,
              // استخدام onSurface ليظهر بشكل واضح في كلا الوضعين
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.68),
              indicatorColor: context.primary,
              tabs: const [
                Tab(text: 'الوصف'),
                Tab(text: 'التعليقات'),
              ],
            ),
            SizedBox(
              height: 180,
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      description?.isNotEmpty == true
                          ? description!
                          : (content?.isNotEmpty == true
                              ? content!
                              : 'لا يوجد وصف متوفر لهذا الدرس حالياً.'),
                      // دمج textTheme من HEAD مع ألوان الخطوط الديناميكية من exams
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.78),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'سيتم إضافة قسم التعليقات قريبًا.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.78),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}