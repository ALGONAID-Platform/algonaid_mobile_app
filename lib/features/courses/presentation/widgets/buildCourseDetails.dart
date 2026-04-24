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
          Text(
            "عدد الوحدات : ${course.modulesCount}",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (course.isEnrolled == false)
            _buildHeaderSection(context, colorScheme),

          if (course.isEnrolled) _buildProgressSection(context, colorScheme),

          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    final bool hasModules =
        course.moduleTitles != null && course.moduleTitles!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),

        if (course.isEnrolled == false)
          SizedBox(
            height: 35, // ارتفاع ثابت لمنع القفز في التصميم
            child: hasModules
                ? _buildModulesList(context) // دالة عرض الوحدات كـ Tags
                : _buildDescriptionText(context), // دالة عرض الوصف
          ),
      ],
    );
  }

  Widget _buildModulesList(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Icon(
            Icons.collections_bookmark_outlined,
            size: 16,
            color: context.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics:
                  const NeverScrollableScrollPhysics(), // منع التمرير ليبقى التصميم ثابتاً
              child: Row(
                children: course.moduleTitles.map((title) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _CourseTag(label: title),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة عرض الوصف بأسلوب مميز
  Widget _buildDescriptionText(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              course.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall!.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
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
        LinearProgress(progressPercentage: course.progressPercentage),
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

class _CourseTag extends StatelessWidget {
  final String label;
  final bool isMore;

  const _CourseTag({required this.label, this.isMore = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMore
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isMore
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          // إذا كان "المزيد" نبرز النص بلون المنصة الأساسي
          color: isMore ? theme.colorScheme.primary : null,
          fontWeight: isMore ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
