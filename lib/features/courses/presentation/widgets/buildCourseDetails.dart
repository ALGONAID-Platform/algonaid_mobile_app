import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/linearProgress.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BuildCourseDetails extends StatelessWidget {
  const BuildCourseDetails({super.key, required this.course});
  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildHeaderSection(context, colorScheme),

          if (course.isEnrolled) _buildProgressSection(context, colorScheme),

          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          " وحدات تعليمية متاحة ${course.modulesCount}",
          style: context.textTheme.titleMedium,
        ),
        if (course.moduleTitles != null && course.isEnrolled == false) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 35,
            child: ClipRect(
              child: Wrap(
                spacing: 8,
                children: course.moduleTitles
                    .map((tag) => _CourseTag(label: tag))
                    .toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // --- ودجت فرعي للبروجريس ---
  Widget _buildProgressSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(course.progressPercentage).toInt()}%",
              style: context.textTheme.labelLarge!.copyWith(
                color: context.primary,
              ),
            ),
            Text(
              "${course.completedLessons} / ${course.totalLessons} مكتمل", // تم تعديل الترتيب ليكون منطقياً
              style: context.theme.textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Directionality(
            textDirection:
                TextDirection.rtl, // لجعل التقدم يتجه من اليمين لليسار
            child: LinearProgress(
              progressPercentage: course.progressPercentage,
            ),
          ),
        ),
      ],
    );
  }

  // --- ودجت فرعي للزر ---
  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: course.isEnrolled
          ? TextButton(
              onPressed: () {
                final context = navigatorKey.currentContext;
                if (context != null) {
                  GoRouter.of(
                    context,
                  ).push('/modulesList/${course.id}', extra: course);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: context.primary.withOpacity(0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: context.primary,
              ),
              child: Text(
                "استمرار",
                style: context.textTheme.labelLarge!.copyWith(
                  color: context.primary,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () {
                if (!course.isEnrolled) {
                  AppDialog.showDynamicDialog(
                    title: "ملاحظة",
                    message: "هل تريد التسجيل في الدورة؟",
                    onConfirm: () async {
                      final context = navigatorKey.currentContext;
                      if (context != null) {
                        final authService = context.read<GetCoursesProvider>();
                        await authService.enrollInCourse(courseId: course.id);
                        if (authService.isSuccessEnroll) {
                          AppDialog.showDynamicDialog(
                            showCancelButton: false,
                            confirmText: "استكشف الدورة",
                            isError: false,
                            title: "تم التسجيل",
                            message: "تم تسجيلك في الدورة بنجاح!",
                            onConfirm: () {
                              GoRouter.of(context).push(
                                '/modulesList/${course.id}',
                                extra: course,
                              );
                            },
                          );
                        } else {
                          AppDialog.showDynamicDialog(
                            title: "خطأ",
                            message:
                                authService.errorMessage ??
                                "حدث خطأ أثناء التسجيل. حاول مرة أخرى.",
                            isError: true,
                          );
                        }
                      }
                    },
                  );
                }
              },
              child: const Text("استكشف الدورة الآن"),
            ),
    );
  }
}

// فصل الـ Tag في Class مستقل واستخدام الـ Theme داخله
class _CourseTag extends StatelessWidget {
  final String label;
  const _CourseTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: Styles.style12(context).copyWith(
          color: theme
              .colorScheme
              .surfaceContainer, // لون النص التلقائي المتوافق مع الخلفية
        ),
      ),
    );
  }
}
