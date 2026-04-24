import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class MyCoursesListSection extends StatelessWidget {
  final List<CourseEntity> myCourses;

  const MyCoursesListSection({super.key, required this.myCourses});

  @override
  Widget build(BuildContext context) {
    final reversedCourses = myCourses.reversed.toList();

    // if (myCourses.isEmpty) {
    //   return _buildEmptyStateCard(context);
    // }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(text: 'دوراتك الحالية'),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: reversedCourses.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(left: 16), // تنسيق الهوامش
                  child: CourseCard(course: reversedCourses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
