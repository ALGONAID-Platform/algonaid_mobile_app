import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';

class ContinueLearningShimmer extends StatelessWidget {
  const ContinueLearningShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان بناءً على الثيم (فاتح/داكن)
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white, // ضروري ليظهر الشيمر
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // محاكاة مكان الصورة (بنفس الارتفاع 160)
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // محاكاة الـ Meta Tags (التاغ الصغير)
                  Container(
                    width: 80,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // محاكاة عنوان الكورس (Course Name)
                  Container(
                    width: double.infinity,
                    height: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  // محاكاة الوصف (Module Description) - سطرين
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(width: 150, height: 12, color: Colors.white),
                  const SizedBox(height: 16),
                  // محاكاة الـ Progress Bar
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(width: 120, height: 10, color: Colors.white),
                  const SizedBox(height: 16),
                  // محاكاة الأزرار (Action Buttons)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
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
