import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';

class SearchCoursesTab extends StatelessWidget {
  final List<CourseEntity> courses;

  const SearchCoursesTab({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'لا توجد نتائج',
        subtitle: 'لا توجد كورسات مطابقة',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return SizedBox(
          height: 345,
          child: CourseCard(course: course),
        );
      },
    );
  }
}
