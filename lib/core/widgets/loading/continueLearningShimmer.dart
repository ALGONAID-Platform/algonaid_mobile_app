import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContinueLearningShimmer extends StatelessWidget {
  const ContinueLearningShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان الخاصة بتأثير اللمعان نفسه
    final shimmerBase = context.isDarkMode
        ? const Color(0xFF2A3644)
        : Colors.grey[200]!;
    final shimmerHighlight = context.isDarkMode
        ? const Color(0xFF3A4B5D)
        : Colors.grey[50]!;

    // لون خلفية البطاقة (تكون أغمق أو أفتح قليلاً من الخلفية العامة)
    final cardBackground = context.isDarkMode
        ? Colors.grey[800]!
        : Colors.white;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground, // خلفية البطاقة ثابتة لا تتحرك
        borderRadius: BorderRadius.circular(15),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerBase,
        highlightColor: shimmerHighlight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الجزء العلوي (مكان الصورة)
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white, // أي لون هنا سيتحول لتأثير شيمر
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // محاكاة التصنيف
                  Container(
                    width: 80,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // محاكاة الأسطر
                  Container(
                    width: double.infinity,
                    height: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(width: 150, height: 12, color: Colors.white),
                  const SizedBox(height: 16),
                  // محاكاة شريط التقدم
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // محاكاة الأزرار
                  Row(
                    children: List.generate(
                      2,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: index == 1 ? 12 : 0),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),)
            ],
          ),
        ),
      
    );
  }
}
