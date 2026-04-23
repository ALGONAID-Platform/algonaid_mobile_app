import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseDetails.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseImage.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BuildCourseImage(course: course),

            Flexible(
              fit: FlexFit.tight,
              child: BuildCourseDetails(course: course),
            ),
          ],
        ),
      ),
    );
  }
}
