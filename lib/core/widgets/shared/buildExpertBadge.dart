import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/expertBadge3D.dart';
import 'package:flutter/material.dart';

class BuildExpertBadge extends StatelessWidget {
  final String title;
  final String description;
  final Color iconColor;
  final List<Color> gradientColors;
  final Color borderColor;

  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final Color statusTagColor;

  final Function()? onTap;

  const BuildExpertBadge({
    super.key,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.gradientColors,
    required this.borderColor,
    // تم تحديث القيم الافتراضية لتناسب ألوان الصورة
    this.cardBackgroundColor = const Color(0xFFF1FDF9),
    this.cardBorderColor = const Color(0xFFD1F5EA),
    this.statusTagColor = const Color(0xFF33E1B3),

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String uniqueHeroTag = 'badge_hero_${title.hashCode}';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: uniqueHeroTag,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            // الخلفية والإطار من ملف الألوان مع دعم الوضع الليلي
            color: isDark ? AppColors.surfaceDark : cardBackgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isDark ? AppColors.indigoDark : cardBorderColor,
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl, // النصوص يمين والأيقونة يسار
              child: Row(
                children: [
                  // 1. قسم النصوص (على اليمين)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // توسيط النصوص كما في الصورة
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // شارة "قيد السعي" (تحت النصوص تماماً)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusTagColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "قيد السعي",
                            style: TextStyle(
                              color: statusTagColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20), // مسافة بين النصوص والأيقونة
                  // 2. قسم الأيقونة (على اليسار مع الدائرة المنقطة)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // دائرة منقطة وهمية (باستخدام Opacity) لتعطي شكل الدائرة في الصورة
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: statusTagColor.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                      ),
                      // أيقونة الكأس
                      Icon(
                        Icons.emoji_events_outlined,
                        color: statusTagColor.withOpacity(0.6),
                        size: 55,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
