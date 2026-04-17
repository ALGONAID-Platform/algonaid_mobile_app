import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/expertBadge3D.dart';
import 'package:flutter/material.dart';

class ModuleHeaderStats extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progressValue; // من 0.0 إلى 1.0
  final int completedLessons;
  final int totalLessons;

  const ModuleHeaderStats({
    super.key,
    this.title = 'الوحدة الثانية: الاشتقاق',
    this.subtitle = 'مقرر الرياضيات • المستوى المتقدم',
    this.progressValue = 0.5,
    this.completedLessons = 3,
    this.totalLessons = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ حجم محتواه فقط كـ Header
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. قسم العنوان والنص الفرعي مع زر الرجوع
            Stack(
              alignment: Alignment.center, // لتوسيط النصوص في المنتصف
              children: [
                // النصوص في المنتصف
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // أيقونة الرجوع في جهة اليمين (بما أننا في وضع RTL)
                Positioned(
                  right: 0, // تثبيت في أقصى اليمين
                  child: IconButton(
                    icon: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(
                        Icons
                            .arrow_forward_ios, // سهم الرجوع لليمين في اللغة العربية
                        size: 20,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. الكارد الرئيسي (الوسام + التقدم)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (context) => Badge3DDialog(
                    heroTag: "expert_badge_",
                    title: "وسام خبير المادة",
                    description: "أكمل 100% من الوحدة بمتوسط 90%",
                    iconColor: AppColors.white,
                    gradientColors: [AppColors.primary, AppColors.primaryLight],
                    borderColor: AppColors.primary,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isDark ? AppColors.indigoDark : AppColors.grey200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // --- الجزء العلوي: قسم الوسام ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withOpacity(0.05)
                            : const Color(0xFFF1FDF9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: AppColors.primary.withOpacity(0.3),
                                size: 70,
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'وسام الإتقان',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'يتطلب الحصول على درجة 85% أو أعلى في الاختبار النهائي.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // الخط المنقط
                    const _DashedDivider(),

                    // --- الجزء السفلي: ملخص التقدم ---
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ملخص التقدم',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${(progressValue * 100).toInt()}%',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              minHeight: 10,
                              backgroundColor: isDark
                                  ? AppColors.indigoDark
                                  : AppColors.grey100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لقد أنجزت $completedLessons دروس ومتبقي لك ${totalLessons - completedLessons} دروس لإنهاء هذه الوحدة.',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.maxWidth;
          const dashWidth = 4.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.grey300),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
