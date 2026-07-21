import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid/core/widgets/shared/heroWidget.dart';
import 'package:algonaid/core/widgets/shared/linearProgress.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/courses/presentation/widgets/buildCourseDetails.dart';
import 'package:algonaid/core/widgets/shared/timeout_image_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/core/constants/endpoints.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CourseThinCard extends StatelessWidget {
  final CourseEntity course;
  const CourseThinCard({super.key, required this.course});

  void _handleCourseTap(BuildContext context) {
    if (course.isEnrolled) {
      context.push('/modulesList/${course.id}', extra: course);
    } else {
      AppBottomSheet.show(
        context: context,
        title: course.title,
        child: BuildCourseDetails(course: course),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleCourseTap(context),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(15),
          border: AppBorder.main_border,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 130,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppHero(
                        tag: "course_image${course.id}_thin",
                        child: Builder(
                          builder: (context) {
                            final bool hasNoImage = Images.isInvalidImage(course.thumbnail);
                            String resolvedUrl = course.thumbnail;
                            if (!hasNoImage && !resolvedUrl.startsWith('http')) {
                              resolvedUrl = resolvedUrl.startsWith('/')
                                  ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
                                  : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
                            }
                            final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);
                            if (hasNoImage || isResolvedInvalid) {
                              return Image.asset(
                                Images.noImageFound,
                                fit: BoxFit.cover,
                              );
                            }
                            return TimeoutImageWrapper(
                              imageUrl: resolvedUrl,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<Box<String>>(
                        valueListenable: Hive.box<String>('course_reminders_box').listenable(),
                        builder: (context, box, _) {
                          final hasReminder = box.containsKey(course.id.toString());
                          if (!hasReminder) return const SizedBox.shrink();
                          return Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.greenAccent.withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.alarm_on_rounded,
                                color: Colors.greenAccent,
                                size: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "المدرب: ${course.teacher.user.name}",
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (course.isEnrolled) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${(course.progressPercentage).toInt()}%",
                                style: context.textTheme.labelMedium!.copyWith(
                                  color: context.primary,
                                ),
                              ),
                              Text(
                                "${course.totalLessons} / ${course.completedLessons} مكتمل",
                                style: context.theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgress(
                            progressPercentage: course.progressPercentage,
                          ),
                        ] else
                          Text(
                            course.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseGridItem extends StatelessWidget {
  final CourseEntity course;
  const CourseGridItem({super.key, required this.course});

  void _handleCourseTap(BuildContext context) {
    if (course.isEnrolled) {
      context.push('/modulesList/${course.id}', extra: course);
    } else {
      AppBottomSheet.show(
        context: context,
        title: course.title,
        child: BuildCourseDetails(course: course),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleCourseTap(context),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(15),
          border: AppBorder.main_border,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppHero(
                      tag: "course_image${course.id}_grid",
                      child: Builder(
                        builder: (context) {
                          final bool hasNoImage = Images.isInvalidImage(course.thumbnail);
                          String resolvedUrl = course.thumbnail;
                          if (!hasNoImage && !resolvedUrl.startsWith('http')) {
                            resolvedUrl = resolvedUrl.startsWith('/')
                                ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
                                : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
                          }
                          final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);
                          if (hasNoImage || isResolvedInvalid) {
                            return Image.asset(
                              Images.noImageFound,
                              fit: BoxFit.cover,
                            );
                          }
                          return TimeoutImageWrapper(
                            imageUrl: resolvedUrl,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<Box<String>>(
                      valueListenable: Hive.box<String>('course_reminders_box').listenable(),
                      builder: (context, box, _) {
                        final hasReminder = box.containsKey(course.id.toString());
                        if (!hasReminder) return const SizedBox.shrink();
                        return Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.greenAccent.withOpacity(0.4),
                                  width: 1),
                            ),
                            child: const Icon(
                              Icons.alarm_on_rounded,
                              color: Colors.greenAccent,
                              size: 12,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      left: 8,
                      child: Text(
                        course.title,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المدرب: ${course.teacher.user.name}",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (course.isEnrolled) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${(course.progressPercentage).toInt()}% اكتمل",
                              style: context.textTheme.labelSmall!.copyWith(
                                color: context.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgress(
                              progressPercentage: course.progressPercentage,
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          "${course.modulesCount} وحدات",
                          style: context.textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
