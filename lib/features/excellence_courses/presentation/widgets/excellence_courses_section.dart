import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/presentation/widgets/excellence_modules_bottom_sheet.dart';

class ExcellenceCoursesSection extends StatefulWidget {
  const ExcellenceCoursesSection({super.key});

  @override
  State<ExcellenceCoursesSection> createState() =>
      _ExcellenceCoursesSectionState();
}

class _ExcellenceCoursesSectionState extends State<ExcellenceCoursesSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExcellenceCoursesProvider>().fetchExcellenceCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExcellenceCoursesProvider>(
      builder: (context, provider, child) {
        // إذا لم يكن هناك بيانات أصلاً (لا كاش ولا محملة) → نعرض شيمر خفيف
        if (provider.isLoading && provider.courses.isEmpty) {
          return const _ExcellenceSectionSkeleton();
        }

        // إذا انتهى التحميل ولم توجد بيانات
        if (!provider.isLoading && provider.courses.isEmpty) {
          return const SizedBox.shrink();
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeader(
                        text: '  اوسمةالإنجازات',
                        subText: 'خاص بالاختبارات',
                        iconColor: Colors.amber.shade700,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(
                            context,
                          ).push(Routes.allExcellenceCourses);
                        },
                        child: Text(
                          'عرض الكل',
                          style: context.bodyMedium?.copyWith(
                            color: context.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.courses.length > 3
                        ? 3
                        : provider.courses.length,
                    itemBuilder: (context, index) {
                      final course = provider.courses[index];
                      // سبق أن حصل على الوسام (completedAt موجود) لكن المعدل نقص عن 90% بسبب اختبارات جديدة
                      final showWarning = course.completedAt != null && course.averagePercentage < 90;
                      final isVisuallyCompleted = course.isCompleted || showWarning;

                      return GestureDetector(
                        onTap: () {
                          ExcellenceModulesBottomSheet.show(context, course);
                        },
                        child: Opacity(
                          opacity: isVisuallyCompleted ? 1.0 : 0.6,
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
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
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Container(
                                        height: 95,
                                        width: double.infinity,
                                        color: !isVisuallyCompleted
                                            ? Colors.grey.withOpacity(0.2)
                                            : (context.isDarkMode
                                                  ? Colors.amber.withOpacity(
                                                      0.1,
                                                    )
                                                  : Colors.amber.shade50),
                                        child: Center(
                                          child: isVisuallyCompleted
                                              ? Lottie.asset(
                                                  AppLottie.goldMedal,
                                                  width: 100,
                                                  height: 100,
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
                                                     width: 100,
                                                     height: 100,
                                                     fit: BoxFit.contain,
                                                   ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course.courseTitle,
                                            style: context.titleMedium
                                                ?.copyWith(
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
                                              style: context.bodyMedium
                                                  ?.copyWith(
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
                                    top: 0,
                                    right: 0,
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
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// شيمر بسيط يظهر فقط عند أول تحميل بدون كاش
class _ExcellenceSectionSkeleton extends StatefulWidget {
  const _ExcellenceSectionSkeleton();

  @override
  State<_ExcellenceSectionSkeleton> createState() =>
      _ExcellenceSectionSkeletonState();
}

class _ExcellenceSectionSkeletonState
    extends State<_ExcellenceSectionSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // عنوان وهمي
                      Container(
                        width: 140,
                        height: 16,
                        decoration: BoxDecoration(
                          color: baseColor.withOpacity(_animation.value),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 14,
                        decoration: BoxDecoration(
                          color: baseColor.withOpacity(_animation.value * 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 195,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: baseColor.withOpacity(_animation.value),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
