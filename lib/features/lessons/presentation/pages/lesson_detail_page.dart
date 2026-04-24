import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/lesson_detail_download_controller.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_detail_app_bar.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_detail_bottom_bar.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LessonDetailPage extends StatefulWidget {
  final int lessonId;
  final String? previousRoute;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
    this.previousRoute,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<LessonDetailProvider>().loadLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LessonDetailView(
      lessonId: widget.lessonId,
      previousRoute: widget.previousRoute,
    );
  }
}

class _LessonDetailView extends StatefulWidget {
  final int lessonId;
  final String? previousRoute;

  const _LessonDetailView({required this.lessonId, this.previousRoute});

  @override
  State<_LessonDetailView> createState() => _LessonDetailViewState();
}

class _LessonDetailViewState extends State<_LessonDetailView> {
  late final LessonDetailDownloadController _downloadController;

  @override
  void initState() {
    super.initState();

    _downloadController = LessonDetailDownloadController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _downloadController.initialize(widget.lessonId);
  }

  @override
  void dispose() {
    _downloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonDetailProvider>(
      builder: (context, provider, _) {
        final state = provider.state;
        final lesson = state.lesson;

        if (state.isLoading && lesson == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && lesson == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الدرس')),
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () => provider.loadLesson(widget.lessonId),
              buttonText: 'إعادة المحاولة',
            ),
          );
        }

        if (lesson == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _downloadController.syncDownloadStatus(lesson);

        debugPrint(
          'LessonDetailPage: rendering lessonId=${lesson.id}, title=${lesson.title}, '
          'examId=${lesson.exam?.id}, hasExam=${lesson.exam != null}',
        );

        return Scaffold(
          appBar: LessonDetailAppBar(
            title: lesson.title,
            onBack: () => _handleBackNavigation(lesson),
          ),
          body: LessonDetailContent(
            lesson: lesson,
            localVideoPath: _downloadController.localVideoFilePath,
            localPdfPath: _downloadController.localPdfFilePath,
            resolvePdfUrl: _downloadController.resolvePdfUrl,
          ),
          bottomNavigationBar: LessonDetailBottomBar(
            onLessonsListPressed: () {
              context.go('${Routes.lessonsList}/${lesson.moduleId}');
            },
            onDownloadPressed:
                _downloadController.downloadStatus == DownloadStatus.downloading
                ? null
                : () => _downloadController.downloadLesson(context, lesson),
            downloadLabel: _downloadController.downloadButtonLabel(),
            isDownloaded:
                _downloadController.downloadStatus == DownloadStatus.downloaded,
          ),
        );
      },
    );
  }

  void _handleBackNavigation(LessonDetail lesson) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    final fallbackRoute =
        widget.previousRoute ?? '${Routes.lessonsList}/${lesson.moduleId}';
    router.go(fallbackRoute);
  }
}
