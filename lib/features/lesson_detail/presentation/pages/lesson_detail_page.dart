import 'dart:async';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/constants/app_constants.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/utils/notification_service.dart';
import 'package:algonaid/core/widgets/shared/app_error_state.dart';
import 'package:algonaid/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid/core/utils/share_helper.dart';
import 'package:algonaid/core/network/check_internet.dart';
import 'package:algonaid/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid/features/downloads/presentation/providers/active_downloads_provider.dart';
import 'package:algonaid/features/lesson_detail/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid/features/lesson_detail/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_detail_app_bar.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_detail_bottom_bar.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid/features/lesson_detail/presentation/widgets/lesson_video_player.dart';
import 'package:algonaid/features/lesson_detail/presentation/controllers/global_video_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
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
      if (!mounted) return;
      final provider = context.read<LessonDetailProvider>();
      if (provider.state.lesson?.id != widget.lessonId) {
        provider.loadLesson(widget.lessonId);
      }
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
  late final ActiveDownloadsProvider _downloadController;
  Timer? _fabTimer;
  double _fabOpacity = 1.0; // 🌟 تبدأ بـ 1.0 لتجنب الوميض
  bool _hasShownOfflineWarning = false;
  bool _isLessonMarkedComplete = false;
  final ScrollController _readingScrollController = ScrollController();
  bool _isAtBottom = false;
  bool _canScroll = true;
  bool _pulseExam = false;
  bool _pulsePdf = false;

  void _updateFabVisibility() {
    if (!mounted) return;
    if (_readingScrollController.hasClients) {
      final maxScroll = _readingScrollController.position.maxScrollExtent;
      if (maxScroll == 0) {
        // المحتوى لا يتطلب سكرول، نجعل الزر ظاهراً بالكامل ونلغي المؤقت
        if (_fabOpacity != 1.0) {
          setState(() {
            _fabOpacity = 1.0;
          });
        }
        _fabTimer?.cancel();
      } else {
        // المحتوى يتطلب سكرول، إذا كان ظاهراً بالكامل ولا يوجد مؤقت يعمل، نقوم ببدء المؤقت ليختفي بعد ثانيتين
        if (_fabOpacity == 1.0 && (_fabTimer == null || !_fabTimer!.isActive)) {
          _startFabTimer();
        }
      }
    }
  }

  void _onDownloadStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _startFabTimer();

    _downloadController = context.read<ActiveDownloadsProvider>()
      ..addListener(_onDownloadStateChanged);
    _downloadController.initialize();
  }

  void _onScroll() {
    if (!mounted) return;
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

  Future<void> _markLessonAsCompleted(LessonDetail lesson) async {
    if (_isLessonMarkedComplete) return;
    _isLessonMarkedComplete = true;

    final isAlreadyCompleted = CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ?? false;
    if (isAlreadyCompleted) {
      return;
    }

    final isOffline = await hasNoInternet();
    if (!mounted) return;
    if (isOffline) {
      _isLessonMarkedComplete = false;
      return;
    }

    // Capture providers before the async gap
    final lessonsListProvider = context.read<LessonsListProvider>();
    final modulesListProvider = context.read<ModulesListProvider>();
    final getCoursesProvider = context.read<GetCoursesProvider>();
    final lastAccessedModuleProvider = context.read<LastAccessedModuleProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final lessonDetailProvider = context.read<LessonDetailProvider>();

    final isSuccess = await lessonDetailProvider.updateProgress(lesson.id, true);
    if (!isSuccess) {
      _isLessonMarkedComplete = false;
      return;
    }

    await CacheHelper.saveData(key: 'lesson_completed_${lesson.id}', value: true);

    try {
      // تحديث الدرس محلياً في الذاكرة
      lessonsListProvider.markLessonCompletedLocally(lesson.id);

      // تحديث الموديول محلياً في الذاكرة
      modulesListProvider.updateModuleProgressLocally(
        moduleId: lesson.moduleId,
        lessonId: lesson.id,
      );

      // تحديث الكورس محلياً في الذاكرة
      final matchedModules = modulesListProvider.state.modules.where((m) => m.id == lesson.moduleId);
      if (matchedModules.isNotEmpty) {
        final courseId = matchedModules.first.courseId;
        getCoursesProvider.updateCourseProgressLocally(courseId);
      }

      // تحديث كارد Continue Learning محلياً في الذاكرة
      lastAccessedModuleProvider.updateProgressLocally(moduleId: lesson.moduleId);

      // الأوسمة فقط نقوم بجلبها من السيرفر لأنها تحسب هناك
      profileProvider.loadUserBadges();
    } catch (e) {
      debugPrint('Error updating local progress: $e');
    }
  }

  @override
  void dispose() {
    _fabTimer?.cancel();
    _downloadController.removeListener(_onDownloadStateChanged);
    _readingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonDetailProvider>(
      builder: (context, provider, _) {
        final state = provider.state;
        final lesson = state.lesson;

        if (state.isLoading || (lesson != null && lesson.id != widget.lessonId)) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الدرس')),
            body: const Center(child: CircularProgressIndicator()),
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

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            _updateFabVisibility();
            _downloadController.syncDownloadStatus(lesson);

            // حفظ معلومة وجود اختبار في الدرس مؤقتاً لعرضها في قائمة الدروس
            if (lesson.exam != null) {
              await CacheHelper.saveData(
                key: 'lesson_has_exam_${lesson.id}',
                value: true,
              );
            }
            
            // تحديث الدرس كمكتمل مباشرة بمجرد الدخول إليه
            _markLessonAsCompleted(lesson);

            if (!_hasShownOfflineWarning) {
              _hasShownOfflineWarning = true;
              final isAlreadyCompleted = CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ?? false;
              if (!isAlreadyCompleted) {
                final isOffline = await hasNoInternet();
                if (isOffline) {
                  if (!context.mounted) return;
                  AppSnackBar.show(
                    context: context,
                    message: 'أنت في وضع عدم الاتصال بالإنترنت. لن يتم مزامنة تقدمك في هذا الدرس حتى تعاود الاتصال.',
                    type: SnackBarType.warning,
                  );
                }
              }

              // Check if it's a reading lesson
              if (lesson.isReading) {
                if (!isAlreadyCompleted) {
                  _markLessonAsCompleted(lesson);
                }
                
                if (_readingScrollController.hasClients) {
                  final pos = _readingScrollController.position;
                  bool newCanScroll = pos.maxScrollExtent > 0;
                  bool newIsAtBottom = pos.pixels >= pos.maxScrollExtent - 20;
                  if (_canScroll != newCanScroll || _isAtBottom != newIsAtBottom) {
                    setState(() {
                      _canScroll = newCanScroll;
                      _isAtBottom = newIsAtBottom;
                    });
                  }
                }
              }
            }
          }
        });

        debugPrint(
          'LessonDetailPage: rendering lessonId=${lesson.id}, title=${lesson.title}, '
          'examId=${lesson.exam?.id}, hasExam=${lesson.exam != null}',
        );

        final pdfUrl =
            _downloadController.resolveAttachmentUrl(lesson.pdfUrl) ?? lesson.pdfUrl;

        final hasPdf = pdfUrl != null && pdfUrl.isNotEmpty;
        final hasVideo = !lesson.isReading && lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty;
        final hasExam = lesson.exam != null;
        
        final bool isVideoDownloaded = !hasVideo || _downloadController.getVideoStatus(lesson.id) == DownloadStatus.downloaded;
        final bool isPdfDownloaded = !hasPdf || _downloadController.getPdfStatus(lesson.id) == DownloadStatus.downloaded;
        final bool isFullyDownloaded = isVideoDownloaded && isPdfDownloaded;

        final bool isTextOnly = lesson.isReading && !hasPdf;
        final bool isSavedText = CacheHelper.getBool(key: 'is_saved_lesson_${lesson.id}') ?? false;

        final bool hasMainFab = hasPdf || hasVideo || isTextOnly;
        final bool hasExamFab = lesson.isReading && hasExam && _canScroll && !_isAtBottom;

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
                onShare: () {
                  ShareHelper.shareLesson(lesson);
                },
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
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: hasExamFab
                        ? Padding(
                            key: const ValueKey('exam_fab'),
                            padding: EdgeInsets.only(bottom: hasMainFab ? 16.0 : 0),
                            child: AnimatedOpacity(
                              opacity: _fabOpacity,
                              duration: const Duration(milliseconds: 300),
                              child: FloatingActionButton(
                                heroTag: 'exam_fab_${lesson.id}',
                                onPressed: () {
                                  _readingScrollController.animateTo(
                                    _readingScrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  ).then((_) {
                                    setState(() => _pulseExam = true);
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      if (mounted) setState(() => _pulseExam = false);
                                    });
                                  });
                                },
                                backgroundColor: context.colorScheme.secondary,
                                elevation: 0,
                                shape: const CircleBorder(),
                                child: const Icon(Icons.assignment_rounded, color: Colors.white),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('no_exam_fab')),
                  ),
                  if (hasMainFab)
                    AnimatedOpacity(
                      opacity: _fabOpacity,
                      duration: const Duration(milliseconds: 300),
                      child: FloatingActionButton(
                        heroTag: 'main_fab_${lesson.id}',
                        onPressed: () {
                          if (isTextOnly) {
                             if (!isSavedText) {
                                CacheHelper.saveData(key: 'is_saved_lesson_${lesson.id}', value: true);
                                AppSnackBar.show(context: context, message: 'تم حفظ الدرس ضمن المحفوظات', type: SnackBarType.success);
                             } else {
                                CacheHelper.removeData(key: 'is_saved_lesson_${lesson.id}');
                                AppSnackBar.show(context: context, message: 'تم إزالة الدرس من المحفوظات', type: SnackBarType.info);
                             }
                             setState((){});
                             return;
                          }

                          if (lesson.isReading && hasPdf && _canScroll && !_isAtBottom) {
                            _readingScrollController.animateTo(
                              _readingScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            ).then((_) {
                              setState(() => _pulsePdf = true);
                              Future.delayed(const Duration(milliseconds: 400), () {
                                if (mounted) setState(() => _pulsePdf = false);
                              });
                            });
                            return;
                          }
                          
                          if (isFullyDownloaded) {
                            AppSnackBar.show(
                              context: context,
                              message:
                                  'تم تحميل هذا الدرس بالكامل ومتاح للمشاهدة بدون إنترنت',
                              type: SnackBarType.info,
                            );
                          } else {
                            _showDownloadDialog(context, lesson, hasVideo, hasPdf);
                          }
                        },
                        backgroundColor: isTextOnly 
                            ? (isSavedText ? Colors.green : context.colorScheme.primary)
                            : ((lesson.isReading && hasPdf && _canScroll && !_isAtBottom)
                                ? context.colorScheme.primary
                                : (isFullyDownloaded ? Colors.green : context.colorScheme.error)),
                        elevation: 0,
                        shape: const CircleBorder(),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                          child: isTextOnly
                              ? Icon(
                                  isSavedText ? Icons.bookmark_added_rounded : Icons.bookmark_add_rounded,
                                  color: Colors.white,
                                  key: ValueKey('bookmark_$isSavedText'),
                                )
                              : ((lesson.isReading && hasPdf && _canScroll && !_isAtBottom)
                                  ? const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, key: ValueKey('pdf'))
                                  : Icon(
                                      isFullyDownloaded
                                          ? Icons.download_done_rounded
                                          : Icons.download_rounded,
                                      color: Colors.white,
                                      key: const ValueKey('download'),
                                    )),
                        ),
                      ),
                    ),
                ],
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  _updateFabVisibility();
                  if (scrollNotification is ScrollUpdateNotification) {
                    _onScroll();
                  }
                  
                  if (lesson.isReading) {
                    final metrics = scrollNotification.metrics;
                    if (metrics.maxScrollExtent == 0 || metrics.pixels >= metrics.maxScrollExtent - 20) {
                      _markLessonAsCompleted(lesson);
                    }
                    
                    bool newCanScroll = metrics.maxScrollExtent > 0;
                    bool newIsAtBottom = metrics.pixels >= metrics.maxScrollExtent - 20;
                    if (_canScroll != newCanScroll || _isAtBottom != newIsAtBottom) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _canScroll = newCanScroll;
                            _isAtBottom = newIsAtBottom;
                          });
                        }
                      });
                    }
                  }
                  return false;
                },
                child: lesson.isReading
                    ? _buildReadingContent(context, lesson)
                    : _buildVideoContent(context, lesson, provider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadingContent(BuildContext context, LessonDetail lesson) {
    return SingleChildScrollView(
      controller: _readingScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reading content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                  MarkdownBody(
                    data: lesson.description!,
                    selectable: true,
                    imageBuilder: (uri, title, alt) {
                      return CachedNetworkImage(
                        imageUrl: uri.toString(),
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image_rounded, color: Colors.grey),
                        fit: BoxFit.contain,
                      );
                    },
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final url = Uri.parse(href);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h3: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ] else if (lesson.content != null && lesson.content!.isNotEmpty) ...[
                  MarkdownBody(
                    data: lesson.content!,
                    selectable: true,
                    imageBuilder: (uri, title, alt) {
                      return CachedNetworkImage(
                        imageUrl: uri.toString(),
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image_rounded, color: Colors.grey),
                        fit: BoxFit.contain,
                      );
                    },
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final url = Uri.parse(href);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      h3: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // PDF section if available
                if (lesson.pdfUrl != null && lesson.pdfUrl!.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 12),
                  AnimatedScale(
                    scale: _pulsePdf ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: LessonPdfCard(
                      pdfUrl: _downloadController.resolveAttachmentUrl(lesson.pdfUrl) ?? lesson.pdfUrl,
                      downloadStatus: _downloadController.getPdfStatus(lesson.id),
                      downloadProgress: _downloadController.getPdfProgress(lesson.id),
                      onDownload: () => _downloadController.downloadPdf(lesson, onMessage: (msg, isError) {
                                  if (mounted) {
                                    AppSnackBar.show(context: context, message: msg, type: isError ? SnackBarType.error : SnackBarType.success);
                                  }
                                }),
                      onOpen: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonPdfViewerPage(
                              pdfUrl: lesson.pdfUrl,
                              localPdfPath: _downloadController.getLocalPdfFilePath(lesson.id),
                              title: lesson.title,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AnimatedScale(
                  scale: _pulseExam ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: LessonQuizCard(
                    examId: lesson.exam?.id,
                    previousRoute: '${Routes.lessonsList}/${lesson.moduleId}',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context, LessonDetail lesson, LessonDetailProvider provider) {
    final pdfUrl = _downloadController.resolveAttachmentUrl(lesson.pdfUrl) ?? lesson.pdfUrl;
    return SingleChildScrollView(
      controller: _readingScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty) ...[
            LessonVideoPlayer(
              lessonId: lesson.id,
              videoUrl: lesson.videoUrl,
              localVideoPath: _downloadController.getLocalVideoFilePath(lesson.id),
              onVideoStart: () {},
              onProgressComplete: () async {
                final isOffline = await hasNoInternet();
                if (isOffline) return false;

                if (mounted) {
                  await NotificationService().showNotification(
                    title: 'إنجاز جديد! 🎓',
                    body: 'تهانينا! لقد أكملت مشاهدة درس "${lesson.title}" بنجاح.',
                  );

                  if (!context.mounted) return false;

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
                return true;
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
          ],
          LessonInfoCard(
            title: lesson.title, 
            hasVideo: lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty,
          ),
          const SizedBox(height: 16),
          LessonTabs(
            description: lesson.description,
            content: lesson.content,
          ),
          const SizedBox(height: 32),
          if (pdfUrl != null && pdfUrl.isNotEmpty) ...[
            LessonPdfCard(
              pdfUrl: pdfUrl,
              downloadStatus: _downloadController.getPdfStatus(lesson.id),
              downloadProgress:
                  _downloadController.getPdfProgress(lesson.id),
              onDownload: () =>
                  _downloadController.downloadPdf(lesson, onMessage: (msg, isError) {
                                  if (mounted) {
                                    AppSnackBar.show(context: context, message: msg, type: isError ? SnackBarType.error : SnackBarType.success);
                                  }
                                }),
              onOpen: () {
                if (lesson.pdfUrl == null || lesson.pdfUrl!.isEmpty) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LessonPdfViewerPage(
                      pdfUrl: lesson.pdfUrl,
                      localPdfPath:
                          _downloadController.getLocalPdfFilePath(lesson.id),
                      title: lesson.title,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
          LessonQuizCard(
            examId: lesson.exam?.id,
            previousRoute:
                '${Routes.lessonsList}/${lesson.moduleId}',
          ),
          const SizedBox(height: 30),
        ],
      ),
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
        _downloadController.getLocalVideoFilePath(lesson.id),
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

  void _showDownloadDialog(BuildContext context, LessonDetail lesson, bool hasVideo, bool hasPdf) {
    bool downloadVideo = hasVideo;
    bool downloadPdf = hasPdf;

    AppBottomSheet.show(
      context: context,
      title: 'خيارات التحميل',
      child: StatefulBuilder(
        builder: (statefulContext, setModalState) {
          return AnimatedBuilder(
            animation: _downloadController,
            builder: (listenableContext, _) {
              final isVideoDownloading = _downloadController.getVideoStatus(lesson.id) == DownloadStatus.downloading;
              final isVideoDownloaded = _downloadController.getVideoStatus(lesson.id) == DownloadStatus.downloaded;

              final isPdfDownloading = _downloadController.getPdfStatus(lesson.id) == DownloadStatus.downloading;
              final isPdfDownloaded = _downloadController.getPdfStatus(lesson.id) == DownloadStatus.downloaded;

              // تمت إزالة منطق الإغلاق التلقائي لمنع الخروج غير المرغوب فيه من الصفحة
              final bool canClickDownload = 
                  (downloadVideo && !isVideoDownloading && !isVideoDownloaded && hasVideo) || 
                  (downloadPdf && !isPdfDownloading && !isPdfDownloaded && hasPdf);

              final bool isAnyDownloading = isVideoDownloading || isPdfDownloading;

              final String buttonLabel = _downloadController.getSmartDownloadButtonLabel(lesson.id, 
                hasVideo: hasVideo,
                hasPdf: hasPdf,
                downloadVideoSelected: downloadVideo,
                downloadPdfSelected: downloadPdf,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasVideo) ...[
                    if (isVideoDownloading)
                      ListTile(
                        leading: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: _downloadController.getVideoProgress(lesson.id) > 0
                                ? _downloadController.getVideoProgress(lesson.id) / 100
                                : null,
                          ),
                        ),
                        title: const Text('جاري تحميل الفيديو...'),
                        trailing: Text(
                          '${_downloadController.getVideoProgress(lesson.id)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    else if (isVideoDownloaded)
                      const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('تم تحميل الفيديو بنجاح'),
                      )
                    else
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
                  ],
                  if (hasPdf) ...[
                    if (isPdfDownloading)
                      ListTile(
                        leading: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: _downloadController.getPdfProgress(lesson.id) > 0
                                ? _downloadController.getPdfProgress(lesson.id) / 100
                                : null,
                          ),
                        ),
                        title: const Text('جاري تحميل ملف الـ PDF...'),
                        trailing: Text(
                          '${_downloadController.getPdfProgress(lesson.id)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    else if (isPdfDownloaded)
                      const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('تم تحميل ملف الـ PDF بنجاح'),
                      )
                    else
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
                  ],
                  const SizedBox(height: 20),
                  if (!isAnyDownloading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canClickDownload 
                            ? Theme.of(statefulContext).colorScheme.primary 
                            : Colors.grey,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: canClickDownload
                          ? () {
                              if (downloadVideo && !isVideoDownloading && !isVideoDownloaded) {
                                _downloadController.downloadVideo(lesson, onMessage: (msg, isError) {
                                  if (mounted) {
                                    AppSnackBar.show(context: context, message: msg, type: isError ? SnackBarType.error : SnackBarType.success);
                                  }
                                });
                              }
                              if (downloadPdf && !isPdfDownloading && !isPdfDownloaded) {
                                _downloadController.downloadPdf(lesson, onMessage: (msg, isError) {
                                  if (mounted) {
                                    AppSnackBar.show(context: context, message: msg, type: isError ? SnackBarType.error : SnackBarType.success);
                                  }
                                });
                              }
                            }
                          : null,
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'جاري التحميل، يرجى الانتظار...',
                        style: TextStyle(
                          color: Theme.of(statefulContext).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
