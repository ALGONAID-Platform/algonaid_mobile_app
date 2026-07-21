// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/widgets/shared/linearProgress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:algonaid/features/modules/presentation/widgets/module_grades_widget.dart';

import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:algonaid/core/theme/app_shadows.dart';
import 'package:algonaid/core/theme/styles.dart';
import 'package:algonaid/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid/core/widgets/shared/timeout_image_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/core/constants/endpoints.dart';

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
          border: AppBorder.main_border,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 110,
                      height: 125,
                      child: _CourseImagePreview(image_irl: module.image_url),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CourseMetaTags(moduleName: module.moduleName),
                        const SizedBox(height: 8),
                        Text(
                          module.courseName,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        _ProgressBarSection(
                          progressPercentage: module.progressPercentage.toDouble(),
                          completedLessons: module.completedLessons,
                          totalLessons: module.totalLessons,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ActionButtonsRow(module: module),
            ],
          ),
      ),)
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نسبة الإنجاز',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${progressPercentage.toInt()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: context.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
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
          flex: 3,
          child: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push(
                '${Routes.lessonsList}/${module.moduleId}',
                extra: {
                  'moduleTitle': module.moduleName,
                  'completedLessons': module.completedLessons,
                  'progressPercentage': module.progressPercentage,
                  'totalLessons': module.totalLessons,
                  'moduleDescription': module.moduleDescription,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'مواصلة الوحدة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: () {
              AppBottomSheet.show(
                context: context,
                title: 'تفاصيل درجات اختبارات الوحدة',
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: ModuleGradesWidget(moduleId: module.moduleId),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: context.colorScheme.onSecondary.withOpacity(0.5),
              ),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
    final bool hasNoImage = Images.isInvalidImage(image_irl);

    String resolvedUrl = image_irl;
    if (!hasNoImage && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }

    final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);

    return Stack(
      fit: StackFit.expand,
      children: [
        (hasNoImage || isResolvedInvalid)
            ? Image.asset(
                Images.noImageFound,
                fit: BoxFit.cover,
              )
            : TimeoutImageWrapper(
                imageUrl: resolvedUrl,
                fit: BoxFit.cover,
              ),
      ],
    );
  }
}
