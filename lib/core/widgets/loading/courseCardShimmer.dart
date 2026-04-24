import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.isDarkMode
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final highlightColor = context.isDarkMode
        ? Colors.grey[700]!
        : Colors.grey[100]!;

    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // محاكاة نص "وحدات تعليمية"
                  Container(width: 80, height: 12, color: Colors.white),
                  const SizedBox(height: 12),
                  // محاكاة التاغات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 50,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 50,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
