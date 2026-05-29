import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/teacher_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/presentation/providers/excellence_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:lottie/lottie.dart';

class ExcellenceCoursesSection extends StatefulWidget {
  const ExcellenceCoursesSection({super.key});

  @override
  State<ExcellenceCoursesSection> createState() => _ExcellenceCoursesSectionState();
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
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.courses.isEmpty) {
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
                      SectionHeader(text: ' الكورسات المتميزة'),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(Routes.allExcellenceCourses);
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
                  height: 195,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.courses.length > 3 ? 3 : provider.courses.length,
                    itemBuilder: (context, index) {
                      final course = provider.courses[index];
                      return GestureDetector(
                        onTap: course.isCompleted ? () {
                          final dummyCourse = CourseEntity(
                            id: course.courseId,
                            title: course.courseTitle,
                            description: '',
                            thumbnail: course.courseImage,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            instructorId: 0,
                            teacher: TeacherEntity(
                              id: 0,
                              specialization: '',
                              experience: 0,
                              userId: 0,
                              user: UserEntity(name: 'مدرس', email: ''),
                            ),
                            moduleTitles: [],
                            modulesCount: 0,
                            isEnrolled: true,
                            totalLessons: 1,
                            completedLessons: 1,
                            progressPercentage: course.averagePercentage.toDouble(),
                          );
                          GoRouter.of(context).push('${Routes.modulesList}/${course.courseId}', extra: dummyCourse);
                        } : null,
                        child: Opacity(
                          opacity: course.isCompleted ? 1.0 : 0.6,
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: AppBorder.main_border
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
                                        height: 110,
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
                                                  colorFilter: const ColorFilter.matrix(<double>[
                                                    0.2126, 0.7152, 0.0722, 0, 0,
                                                    0.2126, 0.7152, 0.0722, 0, 0,
                                                    0.2126, 0.7152, 0.0722, 0, 0,
                                                    0, 0, 0, 1, 0,
                                                  ]),
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
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course.courseTitle,
                                            style: context.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: !course.isCompleted ? Colors.grey : null,
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
                            ],
                          ),
                        ),)
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
