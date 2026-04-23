// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/linearProgress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:go_router/go_router.dart';

class ContinueLearningCard extends StatelessWidget {
  final LastAccessedModuleEntity module;
  const ContinueLearningCard({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: AppShadows.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: _CourseImagePreview(image_irl: module.image_url),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CourseMetaTags(moduleName: module.moduleName),
                    const SizedBox(height: 12),
                    Text(
                      module.courseName,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.moduleDescription,
                      style: context.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    _ProgressBarSection(
                      progressPercentage: module.progressPercentage.toDouble(),
                      completedLessons: module.completedLessons,
                      totalLessons: module.totalLessons,
                    ),
                    const SizedBox(height: 16),
                    _ActionButtonsRow(module: module),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseMetaTags extends StatelessWidget {
  final String moduleName;
  const _CourseMetaTags({required this.moduleName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            moduleName,
            style: context.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBarSection extends StatelessWidget {
  final double progressPercentage;
  final int completedLessons;
  final int totalLessons;

  const _ProgressBarSection({
    required this.progressPercentage,
    required this.completedLessons,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgress(progressPercentage: progressPercentage, hPadding: 0),
        const SizedBox(height: 6),
        Text(
          '$completedLessons درس مكتمل من أصل $totalLessons درساً',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final LastAccessedModuleEntity module;
  const _ActionButtonsRow({required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push(
                '${Routes.lessonsList}/${module.moduleId}',
                extra: {
                  'moduleTitle': module.moduleName,
                  'completedLessons': module.completedLessons,
                  'progressPercentage': module.progressPercentage,
                  'totalLessons': module.totalLessons,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'استمرار',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: context.colorScheme.onSecondary.withOpacity(0.5),
              ),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'التفاصيل',
              style: context.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.onSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseImagePreview extends StatelessWidget {
  final String image_irl;
  const _CourseImagePreview({Key? key, required this.image_irl})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: image_irl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(Images.onboarding1),
        ),
        Container(color: Colors.black12),
        const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 45),
        ),
      ],
    );
  }
}
