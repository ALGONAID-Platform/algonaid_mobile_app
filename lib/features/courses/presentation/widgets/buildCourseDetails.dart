import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/routes/navigatorKey.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/theme/styles.dart';
import 'package:algonaid/core/widgets/shared/linearProgress.dart';
import 'package:algonaid/core/widgets/shared/show_dialog.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BuildCourseDetails extends StatelessWidget {
  const BuildCourseDetails({super.key, required this.course});
  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        // قسم عرض الوصف
        if (course.isEnrolled == false)
          SizedBox(
            height: 35, // ارتفاع ثابت لمنع القفز في التصميم
            child: _buildDescriptionText(context), // دالة عرض الوصف دائماً
          ),
      ],
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
              "${course.totalLessons} / ${course.completedLessons} مكتمل", // تم تعديل الترتيب ليكون منطقياً
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
                GoRouter.of(context).push('/modulesList/${course.id}', extra: course);
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
                course.progressPercentage >= 100.0 ? "مكتمل" : "استمرار",
                style: context.textTheme.labelLarge!.copyWith(
                  color: context.primary,
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (!course.isEnrolled) {
                  AppDialog.showDynamicDialog(
                    title: "ملاحظة",
                    message: "هل تريد التسجيل في الدورة؟",
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.primary.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: context.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "المدرب: ${course.teacher.user.name}",
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.primary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 1,
                              color: context.primary.withOpacity(0.1),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: SingleChildScrollView(
                                child: ClipRect(
                                  child: MarkdownBody(
                                    data: course.description,
                                    styleSheet: MarkdownStyleSheet(
                                      p: context.textTheme.bodySmall?.copyWith(
                                        height: 1.5,
                                        color: context.isDarkMode
                                            ? Colors.grey[300]
                                            : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onConfirm: () async {
                      final context = navigatorKey.currentContext;
                      if (context != null) {
                        // إظهار مؤشر التحميل في منتصف الشاشة
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );

                        final authService = context.read<GetCoursesProvider>();
                        await authService.enrollInCourse(courseId: course.id);

                        // إغلاق مؤشر التحميل بعد انتهاء الطلب
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }

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
              child: const Text("سجل الآن"),
            ),
    );
  }
}
