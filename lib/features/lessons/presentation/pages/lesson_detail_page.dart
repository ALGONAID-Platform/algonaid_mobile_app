import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/lesson_detail_download_controller.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_detail_app_bar.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_detail_bottom_bar.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

        // حالة التحميل الأولية
        if (state.isLoading && lesson == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // حالة الخطأ
        if (state.errorMessage != null && lesson == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الدرس')),
            body: AppErrorState(
              message: state.errorMessage!,
              onRetry: () => provider.loadLesson(widget.lessonId),
              buttonText: 'إعادة المحاولة',
            ),
          );
        }

        // في حال عدم وجود بيانات
        if (lesson == null) {
          return const Scaffold(body: Center(child: Text('تعذر تحميل الدرس')));
        }

        // مزامنة حالة التنزيل للملفات
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _downloadController.syncDownloadStatus(lesson);
        });

        debugPrint(
          'LessonDetailPage: rendering lessonId=${lesson.id}, title=${lesson.title}, '
          'examId=${lesson.exam?.id}, hasExam=${lesson.exam != null}',
        );

        // دمج منطق معالجة مسار ملف الـ PDF
        final pdfUrl =
            _downloadController.resolvePdfUrl(lesson.pdfUrl) ?? lesson.pdfUrl;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: context.background,
            appBar: LessonDetailAppBar(
              title: lesson.title,
              onBack: () => _handleBackNavigation(lesson),
            ),
            bottomNavigationBar: LessonDetailBottomBar(
              onLessonsListPressed: () {
                context.go('${Routes.lessonsList}/${lesson.moduleId}');
              },
              onDownloadPressed:
                  _downloadController.downloadStatus ==
                      DownloadStatus.downloading
                  ? null
                  : () => _downloadController.downloadLesson(context, lesson),
              downloadLabel: _downloadController.downloadButtonLabel(),
              isDownloaded:
                  _downloadController.downloadStatus ==
                  DownloadStatus.downloaded,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LessonVideoPlayer(
                    videoUrl: lesson.videoUrl,
                    localVideoPath: _downloadController
                        .localVideoFilePath, // دعم الفيديو المحلي
                    // 1. عند فتح الفيديو (بدء المشاهدة)
                    onVideoStart: () {
                      context.read<LessonDetailProvider>().updateProgress(
                        lesson.id,
                        false,
                      );
                    },
                    // 2. عند الوصول لـ 90% (الإكمال)
                    onProgressComplete: () {
                      context.read<LessonDetailProvider>().updateProgress(
                        lesson.id,
                        true,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  LessonInfoCard(title: lesson.title),
                  const SizedBox(height: 16),
                  LessonTabs(
                    description: lesson.description,
                    content: lesson.content,
                  ),
                  const SizedBox(height: 16),
                  LessonPdfCard(
                    pdfUrl: pdfUrl,
                    // تمرير المسار المحلي لبطاقة العرض إن كانت تدعمه، وإلا نعتمد على المتصفح/الرابط
                    onOpen: () {
                      if (pdfUrl == null) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonPdfViewerPage(
                            pdfUrl: pdfUrl,
                            title: lesson.title,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  LessonQuizCard(
                    examId: lesson.exam?.id,
                    previousRoute: '${Routes.lessonsList}/${lesson.moduleId}',
                  ),
                ],
              ),
            ),
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
