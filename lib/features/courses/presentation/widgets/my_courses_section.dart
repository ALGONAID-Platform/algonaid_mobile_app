import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

class MyCoursesListSection extends StatelessWidget {
  final List<CourseEntity> myCourses;

  const MyCoursesListSection({super.key, required this.myCourses});

  @override
  Widget build(BuildContext context) {
    if (myCourses.isEmpty) {
      return _buildEmptyStateCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, 
      children: [
        const SectionHeader(text: 'دوراتك الحالية'),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: myCourses.length,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(left: 16), // تنسيق الهوامش
                child: CourseCard(course: myCourses[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.rocket_launch_rounded, color: context.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            "ابدأ رحلة التغيير الآن!",
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "لم تشترك في أي دورة بعد. استثمر في نفسك اليوم وانضم لآلاف المتعلمين في رحلة نحو التميز.",
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.isDarkMode
                  ? Colors.grey[400]
                  : Colors.blueGrey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // زر للانتقال لصفحة الكورسات
          ElevatedButton(
            onPressed: () {
              // هنا تضع كود التنقل لصفحة استكشاف الكورسات
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text("استكشف الدورات المتاحة"),
          ),
        ],
      ),
    );
  }
}
