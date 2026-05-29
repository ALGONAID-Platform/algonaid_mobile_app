import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // مصفوفة الأوسمة مع الحفاظ على الألوان الأصلية
    final badges = [
      {'title': 'مبتدئ', 'icon': Icons.star_rounded, 'color': AppColors.amber},
      {'title': 'متعلم نشط', 'icon': Icons.local_fire_department_rounded, 'color': AppColors.red},
      {'title': 'مكتشف', 'icon': Icons.explore_rounded, 'color': AppColors.primary},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ضبط المحاذاة لتبدأ بشكل صحيح مع الهيدر
          children: [
            SectionHeader(text: 'أوسمة التميز'),
            const SizedBox(height: 16),
            
            // توزيع الأوسمة بشكل كروت مبتكرة متجاوبة
            Row(
              children: badges.map((badge) {
                final badgeColor = badge['color'] as Color;
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    decoration: BoxDecoration(
                      // خلفية الكارت: مزيج من لون السطح مع مسحة خفيفة جداً من لون الوسام لإعطاء روح للمكان
                      color: context.colorScheme.surfaceContainer.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: badgeColor.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // هالة الإضاءة والأيقونة المبتكرة
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // تأثير التوهج الخلفي (Glow)
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: badgeColor.withOpacity(0.12),
                                boxShadow: [
                                  BoxShadow(
                                    color: badgeColor.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            // الأيقونة الأساسية المحدثة بإصدار Rounded العصري
                            Icon(
                              badge['icon'] as IconData,
                              color: badgeColor,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // اسم الوسام بتنسيق أنيق ومحمي ضد النصوص الطويلة
                        Text(
                          badge['title'] as String,
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}