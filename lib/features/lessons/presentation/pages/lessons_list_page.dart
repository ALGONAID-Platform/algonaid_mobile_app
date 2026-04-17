import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessonHeader.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/moduleTimelineList.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  // 1. إضافة متغير لاستقبال السليفرز الخارجية (مثل الهيدر أو شريط التقدم)
  final List<Widget>? headerSlivers;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
    this.headerSlivers,
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
        headerSlivers: headerSlivers,
      ),
    );
  }
}

class _LessonsListView extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final List<Widget>? headerSlivers;

  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
    this.headerSlivers,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.grey50,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ModuleHeaderStats(title: moduleTitle)),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "مسار التعلم",
                        style: Styles.style16(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.grey200,
                        ),
                        child: Text("6 دروس"),
                      ),
                    ],
                  ),
                ),
              ), // مسافة بين الهيدر والقائمة

              Consumer<LessonsListProvider>(
                builder: (context, provider, _) {
                  final state = provider.state;

                  // حالة التحميل (نستخدم SliverFillRemaining لتوسيط العنصر في المساحة المتبقية)
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
                            // التنقل باستخدام المعرف الحقيقي
                            GoRouter.of(
                              context,
                            ).go('${Routes.lessonDetails}/${lessonData.id}');
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
