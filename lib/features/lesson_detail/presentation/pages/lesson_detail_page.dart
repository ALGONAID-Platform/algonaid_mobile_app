import 'dart:async';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/utils/notification_service.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/controllers/lesson_detail_download_controller.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobile_app/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_detail_app_bar.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_detail_bottom_bar.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/widgets/lesson_video_player.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/controllers/global_video_state.dart';
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
  Timer? _fabTimer;
  double _fabOpacity = 0.3;

  @override
  void initState() {
    super.initState();
    _startFabTimer();

    _downloadController = LessonDetailDownloadController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _downloadController.initialize(widget.lessonId);
  }

  void _onScroll() {
    if (_fabOpacity != 1.0) {
      setState(() {
        _fabOpacity = 1.0;
      });
    }
    _startFabTimer();
  }

  void _startFabTimer() {
    _fabTimer?.cancel();
    _fabTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _fabOpacity = 0.3;
        });
      }
    });
  }

  @override
  void dispose() {
    _fabTimer?.cancel();
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
              message: state.errorMessage!,
              onRetry: () => provider.loadLesson(widget.lessonId),
              buttonText: 'إعادة المحاولة',
            ),
          );
        }

        if (lesson == null) {
          return const Scaffold(body: Center(child: Text('تعذر تحميل الدرس')));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _downloadController.syncDownloadStatus(lesson);
          }
        });

        debugPrint(
          'LessonDetailPage: rendering lessonId=${lesson.id}, title=${lesson.title}, '
          'examId=${lesson.exam?.id}, hasExam=${lesson.exam != null}',
        );

        final pdfUrl =
            _downloadController.resolvePdfUrl(lesson.pdfUrl) ?? lesson.pdfUrl;

        final bool isVideoDownloaded =
            _downloadController.videoDownloadStatus ==
            DownloadStatus.downloaded;
        final bool isPdfDownloaded =
            _downloadController.pdfDownloadStatus == DownloadStatus.downloaded;
        final bool isFullyDownloaded =
            isVideoDownloaded &&
            (pdfUrl == null || pdfUrl.isEmpty || isPdfDownloaded);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBackNavigation(lesson);
            },
            child: Scaffold(
              backgroundColor: context.background,
              appBar: LessonDetailAppBar(
                title: lesson.title,
                onBack: () => _handleBackNavigation(lesson),
              ),
              bottomNavigationBar: LessonDetailBottomBar(
                onNextLessonPressed: state.nextLessonId != null
                    ? () {
                        final globalState = GlobalVideoState();
                        globalState.disposeControllers();

                        context.pushReplacement(
                          '${Routes.lessonDetails}/${state.nextLessonId}',
                          extra: widget.previousRoute,
                        );
                      }
                    : null,
                onPreviousLessonPressed: state.previousLessonId != null
                    ? () {
                        final globalState = GlobalVideoState();
                        globalState.disposeControllers();

                        context.pushReplacement(
                          '${Routes.lessonDetails}/${state.previousLessonId}',
                          extra: widget.previousRoute,
                        );
                      }
                    : null,
              ),
              floatingActionButton: AnimatedOpacity(
                opacity: _fabOpacity,
                duration: const Duration(milliseconds: 300),
                child: FloatingActionButton(
                  onPressed: isFullyDownloaded
                      ? () {
                          AppSnackBar.show(
                            context: context,
                            message:
                                'تم تحميل هذا الدرس بالكامل ومتاح للمشاهدة بدون إنترنت',
                            type: SnackBarType.info,
                          );
                        }
                      : () => _showDownloadDialog(context, lesson),
                  backgroundColor: isFullyDownloaded
                      ? Colors.green
                      : context.colorScheme.error,
                  elevation: 0,
                  shape: const CircleBorder(),
                  child: Icon(
                    isFullyDownloaded
                        ? Icons.download_done_rounded
                        : Icons.download_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    _onScroll();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LessonVideoPlayer(
                        lessonId: lesson.id,
                        videoUrl: lesson.videoUrl,
                        localVideoPath: _downloadController.localVideoFilePath,
                        onVideoStart: () {
                          final isAlreadyCompleted =
                              CacheHelper.getBool(
                                key: 'lesson_completed_${lesson.id}',
                              ) ??
                              false;
                          context.read<LessonDetailProvider>().updateProgress(
                            lesson.id,
                            isAlreadyCompleted,
                          );
                        },
                        onProgressComplete: () async {
                          final isAlreadyCompleted =
                              CacheHelper.getBool(
                                key: 'lesson_completed_${lesson.id}',
                              ) ??
                              false;

                          await context
                              .read<LessonDetailProvider>()
                              .updateProgress(lesson.id, true);

                          if (!isAlreadyCompleted) {
                            await CacheHelper.saveData(
                              key: 'lesson_completed_${lesson.id}',
                              value: true,
                            );

                            await NotificationService().showNotification(
                              title: 'إنجاز جديد! 🎓',
                              body:
                                  'تهانينا! لقد أكملت مشاهدة درس "${lesson.title}" بنجاح.',
                            );

                            if (mounted) {
                              try {
                                context.read<GetCoursesProvider>().refreshAll();
                                final modulesListProvider = context
                                    .read<ModulesListProvider>();
                                if (modulesListProvider
                                    .state
                                    .modules
                                    .isNotEmpty) {
                                  modulesListProvider.loadModules(
                                    modulesListProvider
                                        .state
                                        .modules
                                        .first
                                        .courseId,
                                  );
                                }
                                context.read<LessonsListProvider>().loadLessons(
                                  lesson.moduleId,
                                );
                              } catch (_) {}

                              AppSnackBar.show(
                                context: context,
                                message: 'أحسنت! لقد أكملت الدرس بنجاح.',
                                type: SnackBarType.success,
                                actionLabel: 'عرض الإشعارات',
                                onActionPressed: () {
                                  context.push(Routes.notificationsPage);
                                },
                              );
                            }
                          }
                        },
                        onVideoEnd: () {
                          final autoPlayNext =
                              CacheHelper.getBool(
                                key: AppConstants.autoPlayNext,
                              ) ??
                              false;
                          if (autoPlayNext) {
                            final nextId = provider.state.nextLessonId;
                            if (nextId != null) {
                              final globalState = GlobalVideoState();
                              globalState.disposeControllers();
                              if (mounted) {
                                context.pushReplacement(
                                  '${Routes.lessonDetails}/$nextId',
                                  extra: widget.previousRoute,
                                );
                              }
                            }
                          }
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
                        downloadStatus: _downloadController.pdfDownloadStatus,
                        downloadProgress:
                            _downloadController.pdfDownloadProgress,
                        onDownload: () =>
                            _downloadController.downloadPdf(context, lesson),
                        onOpen: () {
                          if (lesson.pdfUrl == null || lesson.pdfUrl!.isEmpty)
                            return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LessonPdfViewerPage(
                                pdfUrl: lesson.pdfUrl,
                                localPdfPath:
                                    _downloadController.localPdfFilePath,
                                title: lesson.title,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      LessonQuizCard(
                        examId: lesson.exam?.id,
                        previousRoute:
                            '${Routes.lessonsList}/${lesson.moduleId}',
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleBackNavigation(LessonDetail lesson) {
    final floatingVideo =
        CacheHelper.getBool(key: AppConstants.floatingVideo) ?? true;
    final globalState = GlobalVideoState();

    if (floatingVideo &&
        globalState.videoPlayerController != null &&
        globalState.videoPlayerController!.value.isPlaying) {
      globalState.showFloatingVideo(
        context,
        lesson.id,
        lesson.videoUrl,
        _downloadController.localVideoFilePath,
      );
    } else {
      globalState.disposeControllers();
    }

    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    final fallbackRoute =
        widget.previousRoute ?? '${Routes.lessonsList}/${lesson.moduleId}';
    router.go(fallbackRoute);
  }

  void _showDownloadDialog(BuildContext context, LessonDetail lesson) {
    bool downloadVideo = true;
    bool downloadPdf = true;

    AppBottomSheet.show(
      context: context,
      title: 'خيارات التحميل',
      child: StatefulBuilder(
        builder: (statefulContext, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('تحميل الفيديو'),
                value: downloadVideo,
                activeColor: Theme.of(statefulContext).colorScheme.primary,
                onChanged: (value) {
                  setModalState(() {
                    downloadVideo = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('تحميل ملف الـ PDF'),
                value: downloadPdf,
                activeColor: Theme.of(statefulContext).colorScheme.primary,
                onChanged: (value) {
                  setModalState(() {
                    downloadPdf = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    statefulContext,
                  ).colorScheme.primary,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(statefulContext);
                  if (downloadVideo) {
                    _downloadController.downloadVideo(context, lesson);
                  }
                  if (downloadPdf) {
                    _downloadController.downloadPdf(context, lesson);
                  }
                },
                child: const Text(
                  'بدء التحميل',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
