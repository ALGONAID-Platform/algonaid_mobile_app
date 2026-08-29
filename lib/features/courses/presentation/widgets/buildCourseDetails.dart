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
import 'package:markdown_widget/markdown_widget.dart';
import 'package:algonaid/core/widgets/shared/latex_custom_node.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BuildCourseDetails extends StatelessWidget {
  const BuildCourseDetails({super.key, required this.course, this.isCardMode = false});
  final CourseEntity course;
  final bool isCardMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
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
        const SizedBox(height: 4),

        // قسم عرض الوصف
        if (course.isEnrolled == false) ...[
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.1), thickness: 1, height: 8),
          _buildDescriptionText(context),
        ],
      ],
    );
  }

  // دالة عرض الوصف بأسلوب مميز
  Widget _buildDescriptionText(BuildContext context) {
    if (isCardMode) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                course.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return ExpandableMarkdownDescription(description: course.description);
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
                                  child: MarkdownBlock(
                                    data: course.description,
                                    
                                    generator: MarkdownGenerator(
                                      inlineSyntaxList: [LatexSyntax()],
                                      generators: [
                                        SpanNodeGeneratorWithTag(
                                          tag: 'latex',
                                          generator: (e, config, visitor) =>
                                              LatexNode(e.attributes, e.textContent, config, maxWidth: MediaQuery.sizeOf(context).width * 0.85),
                                        ),
                                      ],
                                    ),
                                    config: MarkdownConfig(configs: [
TableConfig(wrapper: (w) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: w)),
                                      PConfig(
                                        textStyle: context.textTheme.bodySmall?.copyWith(
                                          height: 1.5,
                                          color: context.isDarkMode
                                              ? Colors.grey[300]
                                              : Colors.grey[800],
                                        ) ?? const TextStyle(),
                                      ),
                                    ]),
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

class ExpandableMarkdownDescription extends StatefulWidget {
  final String description;
  const ExpandableMarkdownDescription({Key? key, required this.description}) : super(key: key);

  @override
  State<ExpandableMarkdownDescription> createState() => _ExpandableMarkdownDescriptionState();
}

class _ExpandableMarkdownDescriptionState extends State<ExpandableMarkdownDescription> {
  bool _isExpanded = false;
  List<Widget>? _cachedWidgets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedWidgets == null && widget.description.isNotEmpty) {
      final config = MarkdownConfig(configs: [
        TableConfig(wrapper: (w) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: w)),
        PConfig(textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5, color: Theme.of(context).colorScheme.onSurface) ?? const TextStyle()),
        H1Config(style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface) ?? const TextStyle()),
        H2Config(style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface) ?? const TextStyle()),
        H3Config(style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface) ?? const TextStyle()),
        ListConfig(marker: (isOrdered, depth, index) => Text('• ', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5, color: Theme.of(context).colorScheme.onSurface))),
      ]);
      final generator = MarkdownGenerator(
        inlineSyntaxList: [LatexSyntax()],
        generators: [
          SpanNodeGeneratorWithTag(
            tag: 'latex',
            generator: (e, conf, visitor) => LatexNode(e.attributes, e.textContent, conf, maxWidth: MediaQuery.sizeOf(context).width * 0.85),
          ),
        ],
      );
      _cachedWidgets = generator.buildWidgets(widget.description, config: config);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.description.isEmpty) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: _isExpanded ? double.infinity : 60.0,
                    ),
                    child: ClipRect(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: _cachedWidgets ?? [],
                          ),
                          if (!_isExpanded)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                                      Theme.of(context).scaffoldBackgroundColor,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 22.0, top: 4.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'عرض أقل' : 'عرض المزيد',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
