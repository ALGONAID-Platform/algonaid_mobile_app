import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class AllCoursesListSection extends StatelessWidget {
  final List<CourseEntity> allCourses;

  const AllCoursesListSection({super.key, required this.allCourses});

  @override
  Widget build(BuildContext context) {
    final reversedCourses = allCourses.reversed.toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // تم التعديل لتتناسب مع اتجاه النص العربي
        children: [
          const SectionHeader(text: 'كل الكورسات'),

          if (allCourses.isEmpty)
            _buildAllEnrolledCard(context)
          else
            SizedBox(
              height: 330,
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: reversedCourses.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    // تعديل المارجن ليكون متناسقاً مع الاتجاه العكسي
                    margin: const EdgeInsets.only(left: 16),
                    child: CourseCard(course: reversedCourses[index]),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAllEnrolledCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: context.primary, size: 40),
          const SizedBox(height: 16),
          Text(
            "لقد قمت بالتسجيل في كل الكورسات!",
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "أنت الآن في رحلة تعلم شاملة. في حال توفر عروض أو دورات جديدة، ستظهر لك هنا مباشرة.",
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.blueGrey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
