import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContinueLearningShimmer extends StatelessWidget {
  const ContinueLearningShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Theme.of(context) لجلب الألوان تلقائياً للتبديل بين الفاتح والمظلم
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // تحديد ألوان الشيمر بناءً على الوضع الحالي
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: IntrinsicHeight(
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // محاكاة _CourseMetaTags
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 30,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // محاكاة عنوان الكورس
                            Container(
                              width: 150,
                              height: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            // محاكاة وصف الكورس (سطرين)
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: 100,
                              height: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            // محاكاة _ProgressBarSection
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 120,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // محاكاة _ActionButtonsRow
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 80,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // محاكاة _CourseImagePreview
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
