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
    // إذا كانت القائمة فارغة لا نعرض شيئاً
    if (myCourses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // عنوان القسم
       SectionHeader(text: 'دوراتك الحالية',),
        SizedBox(
          height: 320,
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: myCourses.length,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                child: CourseCard(course: myCourses[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
