import 'dart:isolate';

import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

class _LessonDetailViewState extends State<_LessonDetailView> {
  static const bool _supportsOfflineDownloads = !kIsWeb;

  DownloadStatus _downloadStatus = DownloadStatus.notDownloaded;

  final YoutubeExplode _yt = YoutubeExplode();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReceivePort? _port;

  SharedPreferences? _prefs;

  String? _pdfDownloadId;
  String? _videoDownloadId;

  String? _localPdfFilePath;
  String? _localVideoFilePath;

  late int _currentLessonId;

  @override
  void initState() {
    super.initState();

    _currentLessonId = widget.lessonId;

    _initPreferences();

    if (_supportsOfflineDownloads) {
      // _prepareSaveDir();
      _initializeNotifications();
      FlutterDownloader.initialize(debug: true, ignoreSsl: true);
      _bindBackgroundIsolate();
    }
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkDownloadStatus();
  }

  Future<String> _prepareDownloadDirectory(int lessonId) async {
    final directory = await getApplicationDocumentsDirectory();
    final lessonDirectory = Directory('${directory.path}/lesson_$lessonId');
    if (!await lessonDirectory.exists()) {
      await lessonDirectory.create(recursive: true);
    }
    return lessonDirectory.path;
  }

  Future<void> _downloadLesson(LessonDetail lesson) async {
    if (!_supportsOfflineDownloads) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تحميل الدرس غير متاح على هذا الجهاز حالياً.'),
        ),
      );
      return;
    }

    if (_downloadStatus == DownloadStatus.downloading) {
      return;
    }

    final pdfUrl = _resolvePdfUrl(lesson.pdfUrl);
    final videoUrl = _resolveDownloadableVideoUrl(lesson.videoUrl);

    if (pdfUrl == null && videoUrl == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد ملفات متاحة لتحميل هذا الدرس.')),
      );
      return;
    }

    final permissionStatus = await Permission.storage.request();
    if (!permissionStatus.isGranted && !permissionStatus.isLimited) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يلزم منح صلاحية التخزين لتحميل الدرس.')),
      );
      return;
    }

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      setState(() {
        _downloadStatus = DownloadStatus.downloading;
      });

      if (pdfUrl != null) {
        _pdfDownloadId = await FlutterDownloader.enqueue(
          url: pdfUrl,
          savedDir: saveDir,
          fileName: 'lesson_${lesson.id}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
        _localPdfFilePath = '$saveDir/lesson_${lesson.id}.pdf';
        await _prefs?.setString(
          'pdf_download_id_${lesson.id}',
          _pdfDownloadId!,
        );
        await _prefs?.setString(
          'pdf_local_path_${lesson.id}',
          _localPdfFilePath!,
        );
      }

      if (videoUrl != null) {
        _videoDownloadId = await FlutterDownloader.enqueue(
          url: videoUrl,
          savedDir: saveDir,
          fileName: 'lesson_${lesson.id}.mp4',
          showNotification: true,
          openFileFromNotification: false,
        );
        _localVideoFilePath = '$saveDir/lesson_${lesson.id}.mp4';
        await _prefs?.setString(
          'video_download_id_${lesson.id}',
          _videoDownloadId!,
        );
        await _prefs?.setString(
          'video_local_path_${lesson.id}',
          _localVideoFilePath!,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('بدأ تحميل الدرس.')));
    } catch (_) {
      setState(() {
        _downloadStatus = DownloadStatus.failed;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر بدء تحميل الدرس.')));
    }
  }

  String? _resolveDownloadableVideoUrl(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) {
      return null;
    }

    if (!videoUrl.startsWith('http')) {
      return '${EndPoint.uploadsBaseUrl}$videoUrl';
    }

    final uri = Uri.tryParse(videoUrl);
    final path = uri?.path.toLowerCase() ?? '';
    final isDirectFile =
        path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.m4v') ||
        path.endsWith('.webm');

    return isDirectFile ? videoUrl : null;
  }

  String _downloadButtonLabel() {
    switch (_downloadStatus) {
      case DownloadStatus.downloading:
        return 'جاري التحميل...';
      case DownloadStatus.downloaded:
        return 'تم تحميل الدرس';
      case DownloadStatus.failed:
        return 'إعادة تحميل الدرس';
      case DownloadStatus.notDownloaded:
        return 'تحميل الدرس';
    }
  }

  void _checkDownloadStatus() async {
    if (!_supportsOfflineDownloads) return;

    final provider = context.read<LessonDetailProvider>();
    final lesson = provider.state.lesson;

    if (lesson == null) return;

    final lessonId = lesson.id;

    _pdfDownloadId = _prefs?.getString('pdf_download_id_$lessonId');
    _videoDownloadId = _prefs?.getString('video_download_id_$lessonId');
    _localPdfFilePath = _prefs?.getString('pdf_local_path_$lessonId');
    _localVideoFilePath = _prefs?.getString('video_local_path_$lessonId');

    if (_pdfDownloadId == null && _videoDownloadId == null) return;

    final tasks = await FlutterDownloader.loadTasks();

    bool allCompleted = true;
    bool anyRunning = false;

    for (var task in tasks ?? []) {
      if (task.taskId == _pdfDownloadId || task.taskId == _videoDownloadId) {
        if (task.status != DownloadTaskStatus.complete) {
          allCompleted = false;
        }

        if (task.status == DownloadTaskStatus.running ||
            task.status == DownloadTaskStatus.enqueued) {
          anyRunning = true;
        }
      }
    }

    if (allCompleted) {
      setState(() => _downloadStatus = DownloadStatus.downloaded);
    } else if (anyRunning) {
      setState(() => _downloadStatus = DownloadStatus.downloading);
    } else {
      setState(() => _downloadStatus = DownloadStatus.notDownloaded);
    }
  }

  void _initializeNotifications() async {
    const android = AndroidInitializationSettings('app_icon');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  void _bindBackgroundIsolate() {
    if (!_supportsOfflineDownloads) return;

    _port = ReceivePort();

    IsolateNameServer.removePortNameMapping('downloader_send_port');

    IsolateNameServer.registerPortWithName(
      _port!.sendPort,
      'downloader_send_port',
    );

    _port!.listen((data) {
      final String id = data[0];
      final DownloadTaskStatus status = data[1];
      final int progress = data[2];

      final lessonId = _currentLessonId;

      if (id == _pdfDownloadId || id == _videoDownloadId) {
        if (status == DownloadTaskStatus.complete) {
          setState(() {
            _downloadStatus = DownloadStatus.downloaded;
          });
        } else if (status == DownloadTaskStatus.failed) {
          setState(() {
            _downloadStatus = DownloadStatus.failed;
          });
        } else if (status == DownloadTaskStatus.running) {
          _showNotification(
            lessonId,
            'Downloading',
            'Progress: $progress%',
            progress: progress,
          );
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    if (!_supportsOfflineDownloads) return;
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    _port?.close();
    _yt.close();
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

        final int? actualExamId = lesson.exam?.id;
        debugPrint(
          'LessonDetailPage: rendering lessonId=${lesson.id}, title=${lesson.title}, '
          'examId=$actualExamId, hasExam=${lesson.exam != null}',
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => _handleBackNavigation(lesson),
            ),
            title: Text(
              lesson.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LessonVideoPlayer(
                  videoUrl: lesson.videoUrl,
                  localVideoPath: _localVideoFilePath,
                ),
                const SizedBox(height: 16),

                LessonInfoCard(title: lesson.title),

                const SizedBox(height: 16),

                LessonPdfCard(
                  pdfUrl: lesson.pdfUrl,
                  onOpen: () {
                    final pdfUrl =
                        _localPdfFilePath ?? _resolvePdfUrl(lesson.pdfUrl);

                    if (pdfUrl == null) return;

                    Navigator.push(
                      context,
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

                LessonTabs(
                  description: lesson.description,
                  content: lesson.content,
                ),

                const SizedBox(height: 16),

                LessonQuizCard(examId: actualExamId),

                const SizedBox(height: 16),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.go('${Routes.lessonsList}/${lesson.moduleId}');
                      },
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('قائمة الدروس'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _downloadStatus == DownloadStatus.downloading
                          ? null
                          : () => _downloadLesson(lesson),
                      icon: Icon(
                        _downloadStatus == DownloadStatus.downloaded
                            ? Icons.check_circle_outline
                            : Icons.download_rounded,
                      ),
                      label: Text(_downloadButtonLabel()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNotification(
    int id,
    String title,
    String body, {
    int progress = 0,
  }) async {
    const android = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      showProgress: true,
      maxProgress: 100,
      progress: 0,
    );

    const details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  String? _resolvePdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.isEmpty) return null;

    if (pdfUrl.startsWith('http')) return pdfUrl;

    return '${EndPoint.uploadsBaseUrl}$pdfUrl';
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
