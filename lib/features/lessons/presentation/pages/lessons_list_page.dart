import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessonHeader.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/moduleTimelineList.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/textDivider.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  const LessonsListPage({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
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
        completedLessons: completedLessons,
        moduleId: moduleId,
        moduleTitle: moduleTitle,
        progressPercentage: progressPercentage,
        totalLessons: totalLessons,
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
  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: context.background,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ModuleHeaderStats(
                  completedLessons: completedLessons,
                  moduleId: moduleId,
                  progressPercentage: progressPercentage,
                  moduleTitle: moduleTitle,
                  totalLessons: totalLessons,
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
                        final lessonData = lessons[index]; // البيانات من DB
                        return LessonTimelineItem(
                          lesson: lessonData,
                          isLast: index == lessons.length - 1,
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).push('${Routes.lessonDetails}/${lessonData.id}');
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
}
