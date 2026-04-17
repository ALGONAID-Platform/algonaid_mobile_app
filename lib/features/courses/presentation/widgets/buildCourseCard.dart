import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseDetails.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseImage.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BuildCourseImage(course: course),

            Flexible(
              fit: FlexFit.tight,
              child: BuildCourseDetails(
                tags: course.moduleTitles,
                modulesCount: course.modulesCount,
                isEnrolled: course.isEnrolled,
                courseId: course.id,
                courseTitle: course.title,
                courseImage : course.thumbnail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
