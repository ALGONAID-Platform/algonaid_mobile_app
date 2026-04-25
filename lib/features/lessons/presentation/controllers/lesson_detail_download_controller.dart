import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

class LessonDetailDownloadController extends ChangeNotifier {
  static const bool supportsOfflineDownloads = !kIsWeb;

  final YoutubeExplode _yt = YoutubeExplode();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReceivePort? _port;
  SharedPreferences? _prefs;

  DownloadStatus _downloadStatus = DownloadStatus.notDownloaded;
  String? _pdfDownloadId;
  String? _videoDownloadId;
  String? _localPdfFilePath;
  String? _localVideoFilePath;
  int? _currentLessonId;
  int? _syncedLessonId;

  DownloadStatus get downloadStatus => _downloadStatus;
  String? get localPdfFilePath => _localPdfFilePath;
  String? get localVideoFilePath => _localVideoFilePath;

  static bool _isDownloaderInitialized = false;

  Future<void> initialize(int lessonId) async {
    _currentLessonId = lessonId;
    _prefs = await SharedPreferences.getInstance();

    if (supportsOfflineDownloads) {
      if (!_isDownloaderInitialized) {
        await _initializeNotifications();
        await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
        _isDownloaderInitialized = true;
      }
      _bindBackgroundIsolate();
    }

    notifyListeners();
  }

  Future<void> syncDownloadStatus(LessonDetail lesson) async {
    if (!supportsOfflineDownloads || _prefs == null) return;
    if (_syncedLessonId == lesson.id) return;

    _syncedLessonId = lesson.id;

    _pdfDownloadId = _prefs?.getString('pdf_download_id_${lesson.id}');
    _videoDownloadId = _prefs?.getString('video_download_id_${lesson.id}');
    _localPdfFilePath = _prefs?.getString('pdf_local_path_${lesson.id}');
    _localVideoFilePath = _prefs?.getString('video_local_path_${lesson.id}');

    if (_pdfDownloadId == null && _videoDownloadId == null) {
      _setDownloadStatus(DownloadStatus.notDownloaded);
      return;
    }

    final tasks = await FlutterDownloader.loadTasks();

    var allCompleted = true;
    var anyRunning = false;

    for (final task in tasks ?? <DownloadTask>[]) {
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
      _setDownloadStatus(DownloadStatus.downloaded);
    } else if (anyRunning) {
      _setDownloadStatus(DownloadStatus.downloading);
    } else {
      _setDownloadStatus(DownloadStatus.notDownloaded);
    }
  }

  Future<void> downloadLesson(BuildContext context, LessonDetail lesson) async {
    if (!supportsOfflineDownloads) {
      _showSnackBar(context, 'تحميل الدرس غير متاح على هذا الجهاز حالياً.');
      return;
    }

    if (_downloadStatus == DownloadStatus.downloading) return;

    final pdfUrl = resolvePdfUrl(lesson.pdfUrl);
    final videoUrl = resolveDownloadableVideoUrl(lesson.videoUrl);

    if (pdfUrl == null && videoUrl == null) {
      _showSnackBar(context, 'لا توجد ملفات متاحة لتحميل هذا الدرس.');
      return;
    }

    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
    
    // Request storage permission just in case for older Android versions,
    // but don't block if denied because Android 13+ denies it automatically 
    // and we are using getApplicationDocumentsDirectory() which doesn't need it.
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _setDownloadStatus(DownloadStatus.downloading);

      if (pdfUrl != null) {
        _pdfDownloadId = await FlutterDownloader.enqueue(
          url: pdfUrl,
          savedDir: saveDir,
          fileName: 'lesson_${lesson.id}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
        _localPdfFilePath = '$saveDir/lesson_${lesson.id}.pdf';
        await _prefs?.setString('pdf_download_id_${lesson.id}', _pdfDownloadId!);
        await _prefs?.setString('pdf_local_path_${lesson.id}', _localPdfFilePath!);
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

      notifyListeners();
      _showSnackBar(context, 'بدأ تحميل الدرس.');
    } catch (_) {
      _setDownloadStatus(DownloadStatus.failed);
      _showSnackBar(context, 'تعذر بدء تحميل الدرس.');
    }
  }

  String downloadButtonLabel() {
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

  String? resolveDownloadableVideoUrl(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) return null;

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

  String? resolvePdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.isEmpty) return null;

    final driveFileIdRegex =
        RegExp(r'https:\/\/drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)\/view');
    final match = driveFileIdRegex.firstMatch(pdfUrl);

    if (match != null && match.groupCount >= 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    if (pdfUrl.startsWith('http')) return pdfUrl;
    return '${EndPoint.uploadsBaseUrl}$pdfUrl';
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notificationsPlugin.initialize(settings);
  }

  Future<String> _prepareDownloadDirectory(int lessonId) async {
    final directory = await getApplicationDocumentsDirectory();
    final lessonDirectory = Directory('${directory.path}/lesson_$lessonId');
    if (!await lessonDirectory.exists()) {
      await lessonDirectory.create(recursive: true);
    }
    return lessonDirectory.path;
  }

  void _bindBackgroundIsolate() {
    if (!supportsOfflineDownloads) return;

    _port = ReceivePort();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.registerPortWithName(
      _port!.sendPort,
      'downloader_send_port',
    );

    _port!.listen((data) {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      if (id == _pdfDownloadId || id == _videoDownloadId) {
        if (status == DownloadTaskStatus.complete) {
          _setDownloadStatus(DownloadStatus.downloaded);
        } else if (status == DownloadTaskStatus.failed) {
          _setDownloadStatus(DownloadStatus.failed);
        } else if (status == DownloadTaskStatus.running) {
          _showNotification(
            _currentLessonId ?? 0,
            'Downloading',
            'Progress: $progress%',
          );
        }
      }
    });
  }

  Future<void> _showNotification(int id, String title, String body) async {
    const android = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      showProgress: true,
      maxProgress: 100,
      progress: 0,
    );

    const details = NotificationDetails(android: android);
    await _notificationsPlugin.show(id, title, body, details);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _setDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    if (supportsOfflineDownloads) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
    _port?.close();
    _yt.close();
    super.dispose();
  }
}
