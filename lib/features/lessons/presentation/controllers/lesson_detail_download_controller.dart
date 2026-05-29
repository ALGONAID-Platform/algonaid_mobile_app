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

// يجب أن تكون الدالة خارج الكلاس (Top-Level) لتعمل في الـ Isolate الخاص بالخلفية
@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

class LessonDetailDownloadController extends ChangeNotifier {
  static const bool supportsOfflineDownloads = !kIsWeb;

  final YoutubeExplode _yt = YoutubeExplode();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReceivePort? _port;
  SharedPreferences? _prefs;

  DownloadStatus _pdfDownloadStatus = DownloadStatus.notDownloaded;
  DownloadStatus _videoDownloadStatus = DownloadStatus.notDownloaded;

  String? _pdfDownloadId;
  String? _videoDownloadId;
  String? _localPdfFilePath;
  String? _localVideoFilePath;
  int? _currentLessonId;
  int? _syncedLessonId;

  DownloadStatus get pdfDownloadStatus => _pdfDownloadStatus;
  DownloadStatus get videoDownloadStatus => _videoDownloadStatus;

  String? get localPdfFilePath => _localPdfFilePath;
  String? get localVideoFilePath => _localVideoFilePath;
  
  int _pdfDownloadProgress = 0;
  int _videoDownloadProgress = 0;

  int get pdfDownloadProgress => _pdfDownloadProgress;
  int get videoDownloadProgress => _videoDownloadProgress;

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
      // تسجيل دالة الاستماع لحالة التحميل
      FlutterDownloader.registerCallback(downloadCallback);
      _bindBackgroundIsolate();
    }

    _safeNotifyListeners();
  }

  Future<void> syncDownloadStatus(LessonDetail lesson) async {
    if (!supportsOfflineDownloads || _prefs == null || !_isDownloaderInitialized) return;
    if (_syncedLessonId == lesson.id) return;

    _syncedLessonId = lesson.id;

    _pdfDownloadId = _prefs?.getString('pdf_download_id_${lesson.id}');
    _videoDownloadId = _prefs?.getString('video_download_id_${lesson.id}');
    _localPdfFilePath = _prefs?.getString('pdf_local_path_${lesson.id}');
    _localVideoFilePath = _prefs?.getString('video_local_path_${lesson.id}');

    if (_pdfDownloadId == null) {
      _setPdfDownloadStatus(DownloadStatus.notDownloaded);
    }
    if (_videoDownloadId == null) {
      _setVideoDownloadStatus(DownloadStatus.notDownloaded);
    }

    final tasks = await FlutterDownloader.loadTasks();

    bool isPdfDownloaded = _localPdfFilePath != null && File(_localPdfFilePath!).existsSync();
    bool isVideoDownloaded = _localVideoFilePath != null && File(_localVideoFilePath!).existsSync();

    if (isPdfDownloaded) {
      _setPdfDownloadStatus(DownloadStatus.downloaded);
    } else {
      var pdfCompleted = false;
      var pdfRunning = false;
      int pdfProgress = 0;
      
      for (final task in tasks ?? <DownloadTask>[]) {
        if (task.taskId == _pdfDownloadId) {
          if (task.status == DownloadTaskStatus.complete) pdfCompleted = true;
          if (task.status == DownloadTaskStatus.running || task.status == DownloadTaskStatus.enqueued) {
            pdfRunning = true;
            pdfProgress = task.progress > 0 ? task.progress : 0;
          }
        }
      }
      
      _pdfDownloadProgress = pdfProgress;
      if (pdfCompleted) _setPdfDownloadStatus(DownloadStatus.downloaded);
      else if (pdfRunning) _setPdfDownloadStatus(DownloadStatus.downloading);
      else _setPdfDownloadStatus(DownloadStatus.notDownloaded);
    }

    if (isVideoDownloaded) {
      _setVideoDownloadStatus(DownloadStatus.downloaded);
    } else {
      var videoCompleted = false;
      var videoRunning = false;
      int videoProgress = 0;

      for (final task in tasks ?? <DownloadTask>[]) {
        if (task.taskId == _videoDownloadId) {
          if (task.status == DownloadTaskStatus.complete) videoCompleted = true;
          if (task.status == DownloadTaskStatus.running || task.status == DownloadTaskStatus.enqueued) {
            videoRunning = true;
            videoProgress = task.progress > 0 ? task.progress : 0;
          }
        }
      }

      _videoDownloadProgress = videoProgress;
      if (videoCompleted) _setVideoDownloadStatus(DownloadStatus.downloaded);
      else if (videoRunning) _setVideoDownloadStatus(DownloadStatus.downloading);
      else _setVideoDownloadStatus(DownloadStatus.notDownloaded);
    }
  }

  Future<void> downloadVideo(BuildContext context, LessonDetail lesson) async {
    if (!supportsOfflineDownloads) {
      _showSnackBar(context, 'تحميل الفيديو غير متاح على هذا الجهاز حالياً.');
      return;
    }

    if (_videoDownloadStatus == DownloadStatus.downloading) return;

    final videoUrl = await resolveDownloadableVideoUrl(lesson.videoUrl);
    if (videoUrl == null) {
      _showSnackBar(context, 'لا يوجد فيديو متاح للتحميل.');
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _videoDownloadProgress = 0;
      _setVideoDownloadStatus(DownloadStatus.downloading);

      _videoDownloadId = await FlutterDownloader.enqueue(
        url: videoUrl,
        savedDir: saveDir,
        fileName: 'lesson_${lesson.id}.mp4',
        showNotification: true,
        openFileFromNotification: false,
      );
      _localVideoFilePath = '$saveDir/lesson_${lesson.id}.mp4';
      await _prefs?.setString('video_download_id_${lesson.id}', _videoDownloadId!);
      await _prefs?.setString('video_local_path_${lesson.id}', _localVideoFilePath!);

      _safeNotifyListeners();
      _showSnackBar(context, 'بدأ تحميل الفيديو.');
    } catch (_) {
      _setVideoDownloadStatus(DownloadStatus.failed);
      _showSnackBar(context, 'تعذر بدء تحميل الفيديو.');
    }
  }

  Future<void> downloadPdf(BuildContext context, LessonDetail lesson) async {
    if (!supportsOfflineDownloads) {
      _showSnackBar(context, 'تحميل المرفق غير متاح على هذا الجهاز حالياً.');
      return;
    }

    if (_pdfDownloadStatus == DownloadStatus.downloading) return;

    final pdfUrl = resolvePdfUrl(lesson.pdfUrl);
    if (pdfUrl == null) {
      _showSnackBar(context, 'لا يوجد ملف متاح للتحميل.');
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _pdfDownloadProgress = 0;
      _setPdfDownloadStatus(DownloadStatus.downloading);

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

      _safeNotifyListeners();
      _showSnackBar(context, 'بدأ تحميل الملف المرفق.');
    } catch (_) {
      _setPdfDownloadStatus(DownloadStatus.failed);
      _showSnackBar(context, 'تعذر بدء تحميل الملف.');
    }
  }

  String videoDownloadButtonLabel() {
    switch (_videoDownloadStatus) {
      case DownloadStatus.downloading:
        return 'جاري تحميل الفيديو...';
      case DownloadStatus.downloaded:
        return 'تم تحميل الفيديو';
      case DownloadStatus.failed:
        return 'إعادة تحميل الفيديو';
      case DownloadStatus.notDownloaded:
        return 'تحميل الفيديو';
    }
  }

  String pdfDownloadButtonLabel() {
    switch (_pdfDownloadStatus) {
      case DownloadStatus.downloading:
        return 'جاري التحميل...';
      case DownloadStatus.downloaded:
        return 'تم التحميل';
      case DownloadStatus.failed:
        return 'إعادة التحميل';
      case DownloadStatus.notDownloaded:
        return 'تحميل المرفق';
    }
  }

  Future<String?> resolveDownloadableVideoUrl(String? videoUrl) async {
    if (videoUrl == null || videoUrl.isEmpty) return null;

    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      try {
        final videoId = VideoId(videoUrl);
        final manifest = await _yt.videos.streamsClient.getManifest(videoId);
        final streamInfo = manifest.muxed.withHighestBitrate();
        return streamInfo.url.toString();
      } catch (e) {
        debugPrint('Error getting YouTube video stream: $e');
        return null;
      }
    }

    if (!videoUrl.startsWith('http')) {
      return '${EndPoint.uploadsBaseUrl}$videoUrl';
    }

    return videoUrl;
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
      // تحويل الرقم القادم من الخلفية إلى DownloadTaskStatus بشكل صحيح
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      if (id == _pdfDownloadId) {
        if (status == DownloadTaskStatus.running || status == DownloadTaskStatus.enqueued) {
          _pdfDownloadProgress = progress;
        }

        if (status == DownloadTaskStatus.complete) {
          _setPdfDownloadStatus(DownloadStatus.downloaded);
        } else if (status == DownloadTaskStatus.failed) {
          _setPdfDownloadStatus(DownloadStatus.failed);
        } else if (status == DownloadTaskStatus.running) {
          _pdfDownloadStatus = DownloadStatus.downloading;
          _safeNotifyListeners();
          _showNotification(_currentLessonId ?? 0, 'Downloading PDF', 'Progress: $progress%');
        }
      } else if (id == _videoDownloadId) {
        if (status == DownloadTaskStatus.running || status == DownloadTaskStatus.enqueued) {
          _videoDownloadProgress = progress;
        }

        if (status == DownloadTaskStatus.complete) {
          _setVideoDownloadStatus(DownloadStatus.downloaded);
        } else if (status == DownloadTaskStatus.failed) {
          _setVideoDownloadStatus(DownloadStatus.failed);
        } else if (status == DownloadTaskStatus.running) {
          _videoDownloadStatus = DownloadStatus.downloading;
          _safeNotifyListeners();
          _showNotification((_currentLessonId ?? 0) + 1000, 'Downloading Video', 'Progress: $progress%');
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
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isDisposed = false;

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _setPdfDownloadStatus(DownloadStatus status) {
    _pdfDownloadStatus = status;
    _safeNotifyListeners();
  }

  void _setVideoDownloadStatus(DownloadStatus status) {
    _videoDownloadStatus = status;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (supportsOfflineDownloads) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
    _port?.close();
    _yt.close();
    super.dispose();
  }
}
