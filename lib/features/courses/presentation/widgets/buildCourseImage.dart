import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/heroWidget.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuildCourseImage extends StatelessWidget {
  const BuildCourseImage({super.key, required this.course});

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        ClipRRect(
          child: AppHero(
            tag: "course_image${course.id}",

            child: CachedNetworkImage(
              imageUrl: course.thumbnail,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: theme.colorScheme.errorContainer,
                child: Image.asset(Images.noImageFound, fit: BoxFit.cover),
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 16,
          right: 16,

          child: AppHero(
            tag: "course_name${course.id}",

            child: Text(
              course.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              softWrap: false,

              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
