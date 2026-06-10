import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/widgets/lessonHeader.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/widgets/moduleTimelineList.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/widgets/textDivider.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';

class LessonsListPage extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final String? previousRoute;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.previousRoute,
  });

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LessonsListProvider>().loadLessons(widget.moduleId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LessonsListView(
      moduleId: widget.moduleId,
      moduleTitle: widget.moduleTitle,
      completedLessons: widget.completedLessons,
      progressPercentage: widget.progressPercentage,
      totalLessons: widget.totalLessons,
      previousRoute: widget.previousRoute,
    );
  }
}

class _LessonsListView extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final String? previousRoute;

  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.previousRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: context.background,
          // تم دمج الـ AppBar من نسخة exams كـ SliverAppBar أو استبداله بالـ Header stats
          body: CustomScrollView(
            slivers: [
              // الهيدر الذي يحتوي على الإحصائيات وزر الرجوع
              SliverToBoxAdapter(
                child: Consumer<LessonsListProvider>(
                  builder: (context, provider, child) {
                    final lessons = provider.state.lessons;
                    final currentTotal = lessons.isNotEmpty
                        ? lessons.length
                        : totalLessons;
                    int currentCompleted = completedLessons;
                    if (lessons.isNotEmpty) {
                      currentCompleted = 0;
                      for (var lesson in lessons) {
                        final isCompleted = CacheHelper.getBool(
                          key: 'lesson_completed_${lesson.id}',
                        );
                        if (isCompleted == true) {
                          currentCompleted++;
                        }
                      }
                    }
                    final currentProgress = currentTotal > 0
                        ? (currentCompleted / currentTotal) * 100
                        : progressPercentage;

                    return Stack(
                      children: [
                        ModuleHeaderStats(
                          completedLessons: currentCompleted,
                          moduleId: moduleId,
                          progressPercentage: currentProgress,
                          moduleTitle: moduleTitle,
                          totalLessons: currentTotal,
                          onBack: () => _handleBackNavigation(context),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: TextDivider(totalLessons: totalLessons),
              ),

              Consumer<LessonsListProvider>(
                builder: (context, provider, _) {
                  final state = provider.state;

                  if (state.isLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.errorMessage != null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: LessonsErrorState(
                        message: state.errorMessage!,
                        onRetry: () => context
                            .read<LessonsListProvider>()
                            .loadLessons(moduleId),
                      ),
                    );
                  }

                  final lessons = state.lessons;

                  if (lessons.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        icon: Icons.menu_book_rounded,
                        title: 'لا توجد دروس',
                        subtitle: 'لا توجد دروس حالياً',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final lessonData = lessons[index];
                        // ملاحظة: يمكنك الاختيار بين LessonCard أو LessonTimelineItem حسب التصميم المطلوب
                        // هنا استخدمنا LessonTimelineItem لأنه المعتمد في الهيكلية الأساسية للكود
                        return LessonTimelineItem(
                          lesson: lessonData,
                          isLast: index == lessons.length - 1,
                          onTap: () async {
                            await CacheHelper.saveData(
                              key: 'last_lesson_module_$moduleId',
                              value: lessonData.id,
                            );
                            if (!context.mounted) return;
                            GoRouter.of(context)
                                .push(
                                  '${Routes.lessonDetails}/${lessonData.id}',
                                  extra: '${Routes.lessonsList}/$moduleId',
                                )
                                .then((_) {
                                  if (context.mounted) {
                                    context
                                        .read<LessonsListProvider>()
                                        .loadLessons(moduleId);
                                    // Also tell GetCoursesProvider to refresh in background so home page updates
                                    try {
                                      context
                                          .read<GetCoursesProvider>()
                                          .refreshAll();
                                    } catch (_) {}
                                  }
                                });
                          },
                        );
                      }, childCount: lessons.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      final fallbackRoute = previousRoute ?? Routes.coursesPage;
      GoRouter.of(context).go(fallbackRoute);
    }
  }
}
