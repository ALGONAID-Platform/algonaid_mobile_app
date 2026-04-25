import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessonHeader.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/moduleTimelineList.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/textDivider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_card.dart'; // تم تضمينه
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LessonsListPage extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final String? previousRoute; // تم دمجها من فرع exams

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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = LessonsListProvider(getIt<GetModuleLessons>());
        provider.loadLessons(moduleId);
        return provider;
      },
      child: _LessonsListView(
        moduleId: moduleId,
        moduleTitle: moduleTitle,
        completedLessons: completedLessons,
        progressPercentage: progressPercentage,
        totalLessons: totalLessons,
        previousRoute: previousRoute,
      ),
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
                child: Stack(
                  children: [
                    ModuleHeaderStats(
                      completedLessons: completedLessons,
                      moduleId: moduleId,
                      progressPercentage: progressPercentage,
                      moduleTitle: moduleTitle,
                      totalLessons: totalLessons,
                    ),
                    // زر الرجوع المدمج من فرع exams
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Transform.flip(
                          flipX: true,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _handleBackNavigation(context),
                      ),
                    ),
                  ],
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
                      child: Center(child: Text('لا توجد دروس حالياً')),
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
                          onTap: () {
                            GoRouter.of(context).push(
                              '${Routes.lessonDetails}/${lessonData.id}',
                              extra:
                                  '${Routes.lessonsList}/$moduleId', // تمرير المسار السابق
                            );
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
