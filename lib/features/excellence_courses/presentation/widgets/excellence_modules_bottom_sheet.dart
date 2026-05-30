import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/info_banner.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ExcellenceModulesBottomSheet extends StatefulWidget {
  final ExcellenceCourseEntity course;

  const ExcellenceModulesBottomSheet({super.key, required this.course});

  static void show(BuildContext context, ExcellenceCourseEntity course) {
    AppBottomSheet.show(
      context: context,
      title: 'أوسمة وحدات ${course.courseTitle}',
      child: ExcellenceModulesBottomSheet(course: course),
    );
  }

  @override
  State<ExcellenceModulesBottomSheet> createState() => _ExcellenceModulesBottomSheetState();
}

class _ExcellenceModulesBottomSheetState extends State<ExcellenceModulesBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExcellenceCoursesProvider>().fetchExcellenceModules(widget.course.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExcellenceCoursesProvider>(
      builder: (context, provider, child) {
        if (provider.isModulesLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final modules = provider.currentModules;

        if (modules.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'لا توجد بيانات للأوسمة',
                style: context.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: modules.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: InfoBanner(
                          message: widget.course.isCompleted
                              ? 'ألف مبروك! لقد حصلت على الوسام الذهبي لهذا الكورس بعد إكمالك لجميع هذه الوحدات بنجاح واجتياز اختباراتها.'
                              : 'لكي تحصل على الوسام الذهبي للكورس، يجب عليك اجتياز جميع اختبارات الوحدات بنجاح   بمعدل لا يقل عن 85%.',
                        ),
                      );
                    }
                    
                    final module = modules[index - 1];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: AppBorder.main_border,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Opacity(
                            opacity: module.isCompleted ? 1.0 : 0.4,
                            child: kIsWeb
                                ? ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 1, 0,
                                    ]),
                                    child: Image.asset(
                                      Images.trophy,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 1, 0,
                                    ]),
                                    child: Lottie.asset(
                                      AppLottie.goldMedal,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                        ),
                        title: Text(
                          module.moduleTitle,
                          style: context.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: module.isCompleted ? null : Colors.grey,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            module.isCompleted ? 'مكتمل بمعدل ${module.averagePercentage}%' : 'غير مكتمل',
                            style: context.bodySmall?.copyWith(
                              color: module.isCompleted ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                        trailing: module.isCompleted 
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.lock_outline, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
