import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/app_shadows.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:flutter/material.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/courses/presentation/widgets/buildCourseDetails.dart';
import 'package:algonaid/features/courses/presentation/widgets/buildCourseImage.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final String heroTagSuffix;
  const CourseCard({super.key, required this.course, this.heroTagSuffix = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(15),
        border: AppBorder.main_border,
        // boxShadow: AppShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BuildCourseImage(course: course, heroTagSuffix: heroTagSuffix),

            Flexible(
              fit: FlexFit.tight,
              child: BuildCourseDetails(course: course, isCardMode: true),
            ),
          ],
        ),
      ),
    );
  }
}
