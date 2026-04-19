import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonDetailPage extends StatelessWidget {
  final int lessonId;

  const LessonDetailPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    // We already provide LessonDetailProvider higher up in the widget tree.
    // Ensure the lesson is loaded when this page is accessed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonDetailProvider>().loadLesson(lessonId);
    });
    return const _LessonDetailView();
  }
}

class _LessonDetailView extends StatefulWidget {
  const _LessonDetailView();

  @override
  State<_LessonDetailView> createState() => _LessonDetailViewState();
}

enum DownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  failed,
}

class _LessonDetailViewState extends State<_LessonDetailView> {
  DownloadStatus _downloadStatus = DownloadStatus.notDownloaded;
  String? _localPath;
  final YoutubeExplode _yt = YoutubeExplode();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ReceivePort _port = ReceivePort();
  SharedPreferences? _prefs;

  String? _pdfDownloadId;
  String? _videoDownloadId;
  String? _localPdfFilePath; // New variable
  String? _localVideoFilePath; // New variable

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _prepareSaveDir();

    // Initialize FlutterLocalNotificationsPlugin
    _initializeNotifications();

    // Initialize FlutterDownloader (if not already initialized globally)
    // It's recommended to initialize FlutterDownloader once at the app's entry point (main.dart)
    // For now, initializing here, but keep in mind for refactoring.
    FlutterDownloader.initialize(
        debug: true, // set to false to disable printing logs to console
        ignoreSsl: true // set to false to disable recording logs to console
    );

    _bindBackgroundIsolate();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkDownloadStatus();
  }

  void _checkDownloadStatus() async {
    final lesson = context.read<LessonDetailProvider>().state.lesson;
    if (lesson == null) return;
    final lessonId = lesson.id;

    _pdfDownloadId = _prefs?.getString('pdf_download_id_$lessonId');
    _videoDownloadId = _prefs?.getString('video_download_id_$lessonId');
    _localPdfFilePath = _prefs?.getString('pdf_local_path_$lessonId');
    _localVideoFilePath = _prefs?.getString('video_local_path_$lessonId');

    if (_pdfDownloadId != null || _videoDownloadId != null) {
      final tasks = await FlutterDownloader.loadTasks();

      bool allCompleted = true;
      bool anyRunning = false;

      for (var task in tasks ?? []) {
        if (task.taskId == _pdfDownloadId) {
          if (task.status != DownloadTaskStatus.complete) allCompleted = false;
          if (task.status == DownloadTaskStatus.running || task.status == DownloadTaskStatus.enqueued) anyRunning = true;
        }
        if (task.taskId == _videoDownloadId) {
          if (task.status != DownloadTaskStatus.complete) allCompleted = false;
          if (task.status == DownloadTaskStatus.running || task.status == DownloadTaskStatus.enqueued) anyRunning = true;
        }
      }

      if (allCompleted && (_pdfDownloadId != null || _videoDownloadId != null)) {
        setState(() {
          _downloadStatus = DownloadStatus.downloaded;
        });
      } else if (anyRunning) {
        setState(() {
          _downloadStatus = DownloadStatus.downloading;
        });
      } else {
        setState(() {
          _downloadStatus = DownloadStatus.notDownloaded;
        });
      }
    }
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Replace 'app_icon' with your app icon name
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _bindBackgroundIsolate() {
    bool isRegistered = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isRegistered) {
      // If already registered, unregister and register again
      IsolateNameServer.removePortNameMapping('downloader_send_port');
      IsolateNameServer.registerPortWithName(
        _port.sendPort,
        'downloader_send_port',
      );
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final lesson = context.read<LessonDetailProvider>().state.lesson;
      if (lesson == null) return;
      final lessonId = lesson.id;

      if (id == _pdfDownloadId || id == _videoDownloadId) {
        if (status == DownloadTaskStatus.complete) {
          // Retrieve local file path from FlutterDownloader task
          FlutterDownloader.loadTasks().then((tasks) {
            final completedTask = tasks?.firstWhere((task) => task.taskId == id);
            if (completedTask != null) {
              final fullPath = '${completedTask.savedDir}/${completedTask.filename}';
              if (id == _pdfDownloadId) {
                _prefs?.setString('pdf_local_path_$lessonId', fullPath);
                _localPdfFilePath = fullPath;
              } else if (id == _videoDownloadId) {
                _prefs?.setString('video_local_path_$lessonId', fullPath);
                _localVideoFilePath = fullPath;
              }
            }

            bool pdfCompleted = _pdfDownloadId == null || tasks?.any((task) => task.taskId == _pdfDownloadId && task.status == DownloadTaskStatus.complete) == true;
            bool videoCompleted = _videoDownloadId == null || tasks?.any((task) => task.taskId == _videoDownloadId && task.status == DownloadTaskStatus.complete) == true;

            if (pdfCompleted && videoCompleted) {
              _showNotification(lessonId.hashCode, 'Download Complete', 'Lesson downloaded successfully!', progress: 100);
              setState(() {
                _downloadStatus = DownloadStatus.downloaded;
              });
            }
          });
        } else if (status == DownloadTaskStatus.failed) {
          _showNotification(lessonId.hashCode, 'Download Failed', 'Failed to download lesson.');
          setState(() {
            _downloadStatus = DownloadStatus.failed;
          });
        } else if (status == DownloadTaskStatus.running) {
          // Only update notification for the last download in progress to avoid spam
          if (id == _pdfDownloadId && _videoDownloadId == null || id == _videoDownloadId) { // This condition needs to be more robust
            _showNotification(lessonId.hashCode, 'Downloading Lesson', 'Progress: $progress%', progress: progress);
          }
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    _yt.close();
    _port.close(); // Close the receive port
    super.dispose();
  }

  Future<void> _showNotification(int id, String title, String body, {int progress = 0}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download channel', // id
      'Download Notifications', // name
      channelDescription: 'Notifications for lesson downloads', // description
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true, // Only alert once when progress changes
      // You can set a custom icon here
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Downloader callback must be a static function
  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath!);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      // For Android, we want to save in the external storage directory for downloads
      // This is usually /storage/emulated/0/Download
      return (await getExternalStorageDirectory())?.path;
    } else if (Platform.isIOS) {
      // For iOS, usually in the Documents directory
      return (await getApplicationDocumentsDirectory()).path;
    }
    return null;
  }

  Future<bool> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  void _downloadLesson() async {
    setState(() {
      _downloadStatus = DownloadStatus.downloading;
    });
    final lesson = context.read<LessonDetailProvider>().state.lesson;
    if (lesson == null) {
      setState(() {
        _downloadStatus = DownloadStatus.failed;
      });
      return;
    }

    final lessonName = lesson.title;
    final savePath = '$_localPath/منصة الجنيد/$lessonName';
    final directory = Directory(savePath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Download PDF
    if (lesson.pdfUrl != null) {
      final pdfFileName = 'lesson_pdf_${lesson.id}.pdf';
      final taskId = await FlutterDownloader.enqueue(
        url: _resolvePdfUrl(lesson.pdfUrl)!,
        savedDir: savePath,
        fileName: pdfFileName,
        showNotification: true,
        openFileFromNotification: true,
      );
      if (taskId != null) {
        _prefs?.setString('pdf_download_id_${lesson.id}', taskId);
        _prefs?.setString('pdf_local_path_${lesson.id}', '$savePath/$pdfFileName');
        _pdfDownloadId = taskId;
        _localPdfFilePath = '$savePath/$pdfFileName';
      }
    }

    // Download Video
    if (lesson.videoUrl != null) {
      try {
        final videoId = YoutubePlayer.convertUrlToId(lesson.videoUrl!) ?? lesson.videoUrl!;
        final StreamManifest manifest = await _yt.videos.streamsClient.getManifest(videoId);

        // Prioritize muxed streams for simplicity, then video-only + audio-only
        final streamInfo = manifest.muxed.sortByVideoQuality().lastOrNull ??
                           manifest.video.sortByVideoQuality().lastOrNull;

        if (streamInfo != null) {
          final videoFileName = 'lesson_video_${lesson.id}.mp4'; // Assuming mp4
          final taskId = await FlutterDownloader.enqueue(
            url: streamInfo.url.toString(),
            savedDir: savePath,
            fileName: videoFileName,
            showNotification: true,
            openFileFromNotification: true,
          );
          if (taskId != null) {
            _prefs?.setString('video_download_id_${lesson.id}', taskId);
            _prefs?.setString('video_local_path_${lesson.id}', '$savePath/$videoFileName');
            _videoDownloadId = taskId;
            _localVideoFilePath = '$savePath/$videoFileName';
          }
        } else {
          print('No suitable video stream found.');
        }

      } catch (e) {
        print('Error downloading video: $e');
      }
    }
  }

  void _deleteLesson() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف الدرس المحمل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final lesson = context.read<LessonDetailProvider>().state.lesson;
      if (lesson == null) return;
      final lessonId = lesson.id;

      // 1. Delete files from storage
      final lessonDirectoryPath = '$_localPath/منصة الجنيد/${lesson.title}';
      final lessonDirectory = Directory(lessonDirectoryPath);
      if (await lessonDirectory.exists()) {
        await lessonDirectory.delete(recursive: true);
        print('Deleted directory: $lessonDirectoryPath');
      }

      // 2. Clear SharedPreferences entries
      await _prefs?.remove('pdf_download_id_$lessonId');
      await _prefs?.remove('video_download_id_$lessonId');
      await _prefs?.remove('pdf_local_path_$lessonId');
      await _prefs?.remove('video_local_path_$lessonId');

      _pdfDownloadId = null;
      _videoDownloadId = null;
      _localPdfFilePath = null;
      _localVideoFilePath = null;

      // 3. Cancel FlutterDownloader tasks (if any are still running/enqueued)
      if (_pdfDownloadId != null) {
        await FlutterDownloader.cancel(taskId: _pdfDownloadId!);
      }
      if (_videoDownloadId != null) {
        await FlutterDownloader.cancel(taskId: _videoDownloadId!);
      }

      setState(() {
        _downloadStatus = DownloadStatus.notDownloaded;
      });
      print('Deleting lesson...');
      // Implement actual deletion logic here later
    }
  }

  String? _resolvePdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.trim().isEmpty) {
      return null;
    }
    if (pdfUrl.startsWith('http')) {
      return pdfUrl;
    }
    final cleaned = pdfUrl.startsWith('uploads/')
        ? pdfUrl.replaceFirst('uploads/', '')
        : pdfUrl;
    return '${EndPoint.uploadsBaseUrl}$cleaned';
  }
}
