import 'package:algonaid_mobail_app/core/widgets/loading/courseCardShimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoursesSectionShimmer extends StatelessWidget {
  const CoursesSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF2A3644) : Colors.grey[200]!;
    final highlightColor = isDark ? const Color(0xFF3A4B5D) : Colors.grey[50]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        // 2. قائمة الكروت الوهمية (بنفس ارتفاع السكشن الأصلي 330)
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            physics:
                const NeverScrollableScrollPhysics(), // تعطيل السحب أثناء التحميل
            itemBuilder: (context, index) => CourseCardShimmer(),
          ),
        ),
      ],
    );
  }
}
