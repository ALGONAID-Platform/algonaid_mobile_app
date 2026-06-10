import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/info_banner.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:lottie/lottie.dart';

import 'package:algonaid_mobile_app/features/excellence_courses/presentation/widgets/excellence_modules_bottom_sheet.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';

class AllExcellenceCoursesPage extends StatelessWidget {
  const AllExcellenceCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const SharedAppBar(title: ' الإنجازات'),
        body: Consumer<ExcellenceCoursesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.courses.isEmpty) {
              return const Center(child: Text('لا توجد كورسات متميزة'));
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InfoBanner(
                      message:
                          'تمثل هذه الشارات تفوقك في الاختبارات، ولا تعتمد على  مشاهدة الدروس. للحصول على الشارة الذهبية، يجب عليك اجتياز جميع اختبارات الكورس بمعدل عام لا يقل عن 90%.',
                      padding: const EdgeInsets.all(16.0),
                      textStyle: context.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final course = provider.courses[index];
                      return GestureDetector(
                        onTap: () {
                          ExcellenceModulesBottomSheet.show(context, course);
                        },
                        child: Opacity(
                          opacity: course.isCompleted ? 1.0 : 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: AppBorder.main_border,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: !course.isCompleted
                                          ? Colors.grey.withOpacity(0.2)
                                          : (context.isDarkMode
                                                ? Colors.amber.withOpacity(0.1)
                                                : Colors.amber.shade50),
                                      child: Center(
                                        child: course.isCompleted
                                            ? Lottie.asset(
                                                AppLottie.goldMedal,
                                                width: 95,
                                                height: 95,
                                                fit: BoxFit.contain,
                                              )
                                            : ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.matrix(
                                                      <double>[
                                                        0.2126,
                                                        0.7152,
                                                        0.0722,
                                                        0,
                                                        0,
                                                        0.2126,
                                                        0.7152,
                                                        0.0722,
                                                        0,
                                                        0,
                                                        0.2126,
                                                        0.7152,
                                                        0.0722,
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                        1,
                                                        0,
                                                      ],
                                                    ),
                                                child: Lottie.asset(
                                                  AppLottie.goldMedal,
                                                  width: 95,
                                                  height: 95,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseTitle,
                                        style: context.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: !course.isCompleted
                                              ? Colors.grey
                                              : null,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      if (course.isCompleted)
                                        Text(
                                          'المعدل: ${course.averagePercentage}%',
                                          style: context.bodyMedium?.copyWith(
                                            color: Colors.amber.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: provider.courses.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
