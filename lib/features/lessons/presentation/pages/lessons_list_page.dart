import 'package:algonaid_mobail_app/core/routes/paths_routes.dart'; // Added
import 'package:go_router/go_router.dart'; // Added

import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final String? previousRoute;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
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
        previousRoute: previousRoute,
      ),
    );
  }
}

class _LessonsListView extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final String? previousRoute;

  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
    this.previousRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(moduleTitle),
          actions: [
            IconButton(
              icon: Transform.flip(
                flipX: true,
                child: Icon(Icons.arrow_back_ios_new),
              ),
              onPressed: () => _handleBackNavigation(context),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Consumer<LessonsListProvider>(
          builder: (context, provider, _) {
            final state = provider.state;
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return LessonsErrorState(
                message: state.errorMessage!,
                onRetry: () =>
                    context.read<LessonsListProvider>().loadLessons(moduleId),
              );
            }

            final lessons = state.lessons;
            if (lessons.isEmpty) {
              return const Center(child: Text('لا توجد دروس حالياً'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lessons.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return LessonCard(
                  lesson: lesson,
                  displayOrder: lesson.order > 0 ? lesson.order : index + 1,
                  onTap: () {
                    GoRouter.of(context).push(
                      '${Routes.lessonDetails}/${lesson.id}',
                      extra: '${Routes.lessonsList}/$moduleId',
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    final fallbackRoute = previousRoute ?? Routes.coursesPage;
    GoRouter.of(context).go(fallbackRoute);
  }
}
