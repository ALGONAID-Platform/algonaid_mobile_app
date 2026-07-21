import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/widgets/shared/info_banner.dart';
import 'package:algonaid/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:lottie/lottie.dart';

import 'package:algonaid/features/excellence_courses/presentation/widgets/excellence_modules_bottom_sheet.dart';
import 'package:algonaid/core/widgets/shared/shared_app_bar.dart';

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
                          childAspectRatio: 0.85,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final course = provider.courses[index];
                      final showWarning = course.completedAt != null && course.averagePercentage < 90;
                      final isVisuallyCompleted = course.isCompleted || showWarning;

                      return GestureDetector(
                        onTap: () {
                          ExcellenceModulesBottomSheet.show(context, course);
                        },
                        child: Opacity(
                          opacity: isVisuallyCompleted ? 1.0 : 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: AppBorder.main_border,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: !isVisuallyCompleted
                                          ? Colors.grey.withOpacity(0.2)
                                          : (context.isDarkMode
                                                ? Colors.amber.withOpacity(0.1)
                                                : Colors.amber.shade50),
                                      child: Center(
                                        child: isVisuallyCompleted
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
                                  padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseTitle,
                                        style: context.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: !isVisuallyCompleted
                                              ? Colors.grey
                                              : null,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      if (isVisuallyCompleted)
                                        Text(
                                          'المعدل: ${course.averagePercentage}%',
                                          style: context.bodyMedium?.copyWith(
                                            color: showWarning ? Colors.orange : Colors.amber.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (showWarning)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'يرجى إتمام الاختبارات الجديدة',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
