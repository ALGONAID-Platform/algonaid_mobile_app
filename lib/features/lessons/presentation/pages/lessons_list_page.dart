import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_detail_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LessonsListProvider(
          context.read<GetModuleLessons>(),
        );
        provider.loadLessons(moduleId);
        return provider;
      },
      child: _LessonsListView(
        moduleId: moduleId,
        moduleTitle: moduleTitle,
      ),
    );
  }
}

class _LessonsListView extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;

  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
  });

  @override
  State<_LessonsListView> createState() => _LessonsListViewState();
}

class _LessonsListViewState extends State<_LessonsListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      context.read<LessonsListProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: Text(widget.moduleTitle),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
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
                    context.read<LessonsListProvider>().loadLessons(
                          widget.moduleId,
                        ),
              );
            }

            final lessons = state.lessons;
            if (lessons.isEmpty) {
              return const Center(child: Text('لا توجد دروس حالياً'));
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: lessons.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= lessons.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final lesson = lessons[index];
                return LessonCard(
                  lesson: lesson,
                  displayOrder: lesson.order > 0 ? lesson.order : index + 1,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonDetailPage(lessonId: lesson.id),
                      ),
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
}
