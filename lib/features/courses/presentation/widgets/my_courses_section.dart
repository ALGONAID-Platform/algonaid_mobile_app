import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';

import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';

class MyCoursesListSection extends StatelessWidget {
  final List<CourseEntity> myCourses;
  final List<CourseEntity> allCourses;

  const MyCoursesListSection({
    super.key,
    required this.myCourses,
    required this.allCourses,
  });

  @override
  Widget build(BuildContext context) {
    final reversedCourses = myCourses.reversed.toList();

    // if (myCourses.isEmpty) {
    //   return _buildEmptyStateCard(context);
    // }

    return myCourses.isEmpty
        ? _buildEmptyStateCard(context)
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  text: 'دوراتك الحالية',
                  onViewAllPressed: () {
                    context.push(
                      Routes.coursesViewAllPage,
                      extra: {
                        'title': 'دوراتك الحالية',
                        'courses': reversedCourses,
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 345,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: reversedCourses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        margin: const EdgeInsets.only(
                          left: 16,
                        ), // تنسيق الهوامش
                        child: CourseCard(course: reversedCourses[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
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
        border: AppBorder.main_border,
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
              context.push(
                Routes.coursesViewAllPage,
                extra: {'title': 'جميع الدورات المتاحة', 'courses': allCourses},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
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
