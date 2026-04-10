import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class AllCoursesListSection extends StatelessWidget {
  final List<CourseEntity> allCourses;

  const AllCoursesListSection({super.key, required this.allCourses});

  @override
  Widget build(BuildContext context) {
    if (allCourses.isEmpty) return const SizedBox.shrink();

    // حساب العرض بناءً على حجم الشاشة لضمان ظهور جزء من البطاقة التالية
    // 0.7 تعني أن البطاقة تأخذ 70% من عرض الشاشة
    final cardWidth = MediaQuery.of(context).size.width * 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'كل الكورسات',
            style: Styles.style18(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        SizedBox(
          height: 330,
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(right: 16), 
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: allCourses.length,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(left: 16),
                child: CourseCard(course: allCourses[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
