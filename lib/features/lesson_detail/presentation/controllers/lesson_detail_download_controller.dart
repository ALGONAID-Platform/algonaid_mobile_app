import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid_mobile_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/datasources/lesson_detail_local_data_source.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName(
    'downloader_send_port',
  );
  send?.send([id, status, progress]);
}

class LessonDetailDownloadController extends ChangeNotifier {
  static const bool supportsOfflineDownloads = !kIsWeb;

  final YoutubeExplode _yt = YoutubeExplode();
  final Dio _dio = Dio();

  ReceivePort? _port;
  SharedPreferences? _prefs;

  DownloadStatus _pdfDownloadStatus = DownloadStatus.notDownloaded;
  DownloadStatus _videoDownloadStatus = DownloadStatus.notDownloaded;

  String? _pdfDownloadId;
  String? _videoDownloadId;
  String? _localPdfFilePath;
  String? _localVideoFilePath;
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
    _prefs = await SharedPreferences.getInstance();

    if (supportsOfflineDownloads) {
      if (!_isDownloaderInitialized) {
        await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
        _isDownloaderInitialized = true;
      }
      FlutterDownloader.registerCallback(downloadCallback);
      _bindBackgroundIsolate();
    }

    _safeNotifyListeners();
  }

  Future<void> syncDownloadStatus(LessonDetail lesson) async {
    if (!supportsOfflineDownloads ||
        _prefs == null ||
        !_isDownloaderInitialized)
      return;
    if (_syncedLessonId == lesson.id) return;

    _syncedLessonId = lesson.id;

    _pdfDownloadId = _prefs?.getString('pdf_download_id_${lesson.id}');
    _videoDownloadId = _prefs?.getString('video_download_id_${lesson.id}');

    final docDir = await getApplicationDocumentsDirectory();
    final saveDir = '${docDir.path}/lesson_${lesson.id}';

    final videoFileName = _prefs?.getString('video_filename_${lesson.id}');
    if (videoFileName != null) {
      _localVideoFilePath = '$saveDir/$videoFileName';
    } else {
      final storedPath = _prefs?.getString('video_local_path_${lesson.id}');
      if (storedPath != null && storedPath.isNotEmpty) {
        final name = storedPath.split('/').last;
        _localVideoFilePath = '$saveDir/$name';
      } else {
        _localVideoFilePath = null;
      }
    }

    final pdfFileName = _prefs?.getString('pdf_filename_${lesson.id}');
    if (pdfFileName != null) {
      _localPdfFilePath = '$saveDir/$pdfFileName';
    } else {
      final storedPath = _prefs?.getString('pdf_local_path_${lesson.id}');
      if (storedPath != null && storedPath.isNotEmpty) {
        final name = storedPath.split('/').last;
        _localPdfFilePath = '$saveDir/$name';
      } else {
        _localPdfFilePath = null;
      }
    }

    if (_localVideoFilePath != null) {
      await _prefs?.setString(
        'video_local_path_${lesson.id}',
        _localVideoFilePath!,
      );
    }
    if (_localPdfFilePath != null) {
      await _prefs?.setString(
        'pdf_local_path_${lesson.id}',
        _localPdfFilePath!,
      );
    }

    if (_pdfDownloadId == null) {
      _setPdfDownloadStatus(DownloadStatus.notDownloaded);
    }
    if (_videoDownloadId == null) {
      _setVideoDownloadStatus(DownloadStatus.notDownloaded);
    }

    final tasks = await FlutterDownloader.loadTasks();

    bool isPdfDownloaded =
        _localPdfFilePath != null && File(_localPdfFilePath!).existsSync();
    bool isVideoDownloaded =
        _localVideoFilePath != null && File(_localVideoFilePath!).existsSync();

    if (isPdfDownloaded) {
      _setPdfDownloadStatus(DownloadStatus.downloaded);
    } else {
      var pdfCompleted = false;
      var pdfRunning = false;
      int pdfProgress = 0;

      for (final task in tasks ?? <DownloadTask>[]) {
        if (task.taskId == _pdfDownloadId) {
          if (task.status == DownloadTaskStatus.complete) pdfCompleted = true;
          if (task.status == DownloadTaskStatus.running ||
              task.status == DownloadTaskStatus.enqueued) {
            pdfRunning = true;
            pdfProgress = task.progress > 0 ? task.progress : 0;
          }
        }
      }

      _pdfDownloadProgress = pdfProgress;
      if (pdfCompleted)
        _setPdfDownloadStatus(DownloadStatus.downloaded);
      else if (pdfRunning)
        _setPdfDownloadStatus(DownloadStatus.downloading);
      else
        _setPdfDownloadStatus(DownloadStatus.notDownloaded);
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
          if (task.status == DownloadTaskStatus.running ||
              task.status == DownloadTaskStatus.enqueued) {
            videoRunning = true;
            videoProgress = task.progress > 0 ? task.progress : 0;
          }
        }
      }

      _videoDownloadProgress = videoProgress;
      if (videoCompleted)
        _setVideoDownloadStatus(DownloadStatus.downloaded);
      else if (videoRunning)
        _setVideoDownloadStatus(DownloadStatus.downloading);
      else
        _setVideoDownloadStatus(DownloadStatus.notDownloaded);
    }
  }

  Future<void> downloadVideo(BuildContext context, LessonDetail lesson) async {
    if (!supportsOfflineDownloads) {
      _showSnackBar(
        context,
        'تحميل الفيديو غير متاح على هذا الجهاز حالياً.',
        isError: true,
      );
      return;
    }

    if (_videoDownloadStatus == DownloadStatus.downloading) return;

    final videoUrl = await resolveDownloadableVideoUrl(lesson.videoUrl);
    if (videoUrl == null) {
      _showSnackBar(context, 'لا يوجد فيديو متاح للتحميل.', isError: true);
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _videoDownloadProgress = 0;
      _setVideoDownloadStatus(DownloadStatus.downloading);

      final videoFileName = _getSafeFileName(lesson.title, 'mp4');
      _videoDownloadId = await FlutterDownloader.enqueue(
        url: videoUrl,
        savedDir: saveDir,
        fileName: videoFileName,
        showNotification: true,
        openFileFromNotification: false,
      );
      _localVideoFilePath = '$saveDir/$videoFileName';
      await _prefs?.setString(
        'video_download_id_${lesson.id}',
        _videoDownloadId!,
      );
      await _prefs?.setString('video_filename_${lesson.id}', videoFileName);
      await _prefs?.setString(
        'video_local_path_${lesson.id}',
        _localVideoFilePath!,
      );
      await _cacheLessonDetail(lesson);

      _safeNotifyListeners();
      _showSnackBar(context, 'بدأ تحميل الفيديو.');
    } catch (_) {
      _setVideoDownloadStatus(DownloadStatus.failed);
      _showSnackBar(context, 'تعذر بدء تحميل الفيديو.', isError: true);
    }
  }

  Future<void> downloadPdf(BuildContext context, LessonDetail lesson) async {
    if (!supportsOfflineDownloads) {
      _showSnackBar(
        context,
        'تحميل المرفق غير متاح على هذا الجهاز حالياً.',
        isError: true,
      );
      return;
    }

    if (_pdfDownloadStatus == DownloadStatus.downloading) return;

    final attachmentUrl = resolveAttachmentUrl(lesson.pdfUrl);
    if (attachmentUrl == null) {
      _showSnackBar(context, 'لا يوجد ملف متاح للتحميل.', isError: true);
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _pdfDownloadProgress = 0;
      _setPdfDownloadStatus(DownloadStatus.downloading);

      final attachmentExtension = await resolveAttachmentExtension(
        lesson.pdfUrl,
      );
      final pdfFileName = _getSafeFileName(lesson.title, attachmentExtension);
      _pdfDownloadId = await FlutterDownloader.enqueue(
        url: attachmentUrl,
        savedDir: saveDir,
        fileName: pdfFileName,
        showNotification: true,
        openFileFromNotification: true,
      );
      _localPdfFilePath = '$saveDir/$pdfFileName';
      await _prefs?.setString('pdf_download_id_${lesson.id}', _pdfDownloadId!);
      await _prefs?.setString('pdf_filename_${lesson.id}', pdfFileName);
      await _prefs?.setString(
        'pdf_local_path_${lesson.id}',
        _localPdfFilePath!,
      );
      await _cacheLessonDetail(lesson);

      _safeNotifyListeners();
      _showSnackBar(context, 'بدأ تحميل الملف المرفق.');
    } catch (_) {
      _setPdfDownloadStatus(DownloadStatus.failed);
      _showSnackBar(context, 'تعذر بدء تحميل الملف.', isError: true);
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

        final qualitySetting =
            CacheHelper.getString(key: 'downloadQuality') ?? 'متوسطة';
        final muxedStreams = manifest.muxed.toList();

        if (muxedStreams.isEmpty) return null;

        muxedStreams.sort((a, b) => a.bitrate.compareTo(b.bitrate));

        MuxedStreamInfo streamInfo;
        if (qualitySetting == 'منخفضة (توفير البيانات)') {
          streamInfo = muxedStreams.first;
        } else if (qualitySetting == 'عالية (HD)') {
          streamInfo = muxedStreams.last;
        } else {
          int midIndex = muxedStreams.length ~/ 2;
          streamInfo = muxedStreams[midIndex];
        }

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

  String? resolvePdfUrl(String? pdfUrl) => resolveAttachmentUrl(pdfUrl);

  String? resolveAttachmentUrl(String? attachmentUrl) {
    if (attachmentUrl == null || attachmentUrl.isEmpty) return null;

    final driveFileId = _extractDriveFileId(attachmentUrl);
    if (driveFileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$driveFileId';
    }

    if (attachmentUrl.startsWith('http')) return attachmentUrl;
    return '${EndPoint.uploadsBaseUrl}$attachmentUrl';
  }

  Future<String> resolveAttachmentExtension(String? attachmentUrl) async {
    if (attachmentUrl == null || attachmentUrl.isEmpty) {
      return 'pdf';
    }

    final parsed = Uri.tryParse(attachmentUrl);
    final path = parsed?.path.isNotEmpty == true ? parsed!.path : attachmentUrl;
    final lowerPath = path.toLowerCase();
    final supportedExtensions = <String>[
      'pdf',
      'ppt',
      'pptx',
      'pptm',
      'pps',
      'ppsx',
    ];

    for (final extension in supportedExtensions) {
      if (lowerPath.endsWith('.$extension')) {
        return extension;
      }
    }

    final resolvedUrl = resolveAttachmentUrl(attachmentUrl) ?? attachmentUrl;
    try {
      final response = await _dio.head(resolvedUrl);
      final contentDisposition =
          response.headers.value('content-disposition') ?? '';
      final contentType =
          response.headers.value('content-type')?.toLowerCase() ?? '';

      final dispositionMatch = RegExp(
        r'filename="([^"]+)"',
      ).firstMatch(contentDisposition);
      if (dispositionMatch != null && dispositionMatch.groupCount >= 1) {
        final filename = dispositionMatch.group(1)!.toLowerCase();
        for (final extension in supportedExtensions) {
          if (filename.endsWith('.$extension')) {
            return extension;
          }
        }
      }

      if (contentType.contains('pdf')) {
        return 'pdf';
      }

      if (contentType.contains('presentation') ||
          contentType.contains('powerpoint') ||
          contentType.contains('officedocument.presentationml')) {
        return 'pptx';
      }
    } catch (_) {}

    if (lowerPath.contains('drive.google.com')) {
      return 'pdf';
    }

    return 'pdf';
  }

  String? _extractDriveFileId(String url) {
    final patterns = <RegExp>[
      RegExp(r'https?://drive\.google\.com/file/d/([^/]+)/view'),
      RegExp(r'https?://drive\.google\.com/open\?id=([^&]+)'),
      RegExp(r'https?://drive\.google\.com/uc\?export=download&id=([^&]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  String _getSafeFileName(String title, String extension) {
    final sanitized = title.replaceAll(RegExp(r'[\\\/:*?"<>|]'), '_').trim();
    final finalName = sanitized.isEmpty ? 'lesson' : sanitized;
    return '$finalName.$extension';
  }

  Future<void> _cacheLessonDetail(LessonDetail lesson) async {
    try {
      final localDataSource = getIt<LessonDetailLocalDataSource>();

      final exam = lesson.exam;
      final examModel = exam != null
          ? (exam is ExamModel
                ? exam
                : ExamModel(
                    id: exam.id,
                    title: exam.title,
                    description: exam.description,
                    passingScore: exam.passingScore,
                    maxAttempts: exam.maxAttempts,
                    lessonId: exam.lessonId,
                    questions: exam.questions,
                  ))
          : null;

      final lessonModel = LessonDetailModel(
        id: lesson.id,
        moduleId: lesson.moduleId,
        title: lesson.title,
        order: lesson.order,
        description: lesson.description,
        content: lesson.content,
        videoUrl: lesson.videoUrl,
        pdfUrl: lesson.pdfUrl,
        exam: examModel,
      );
      await localDataSource.saveLessonDetail(lessonModel);
    } catch (e) {
      debugPrint('Error caching lesson details on download: $e');
    }
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
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      if (id == _pdfDownloadId) {
        if (status == DownloadTaskStatus.running ||
            status == DownloadTaskStatus.enqueued) {
          _pdfDownloadProgress = progress;
        }

        if (status == DownloadTaskStatus.complete) {
          _setPdfDownloadStatus(DownloadStatus.downloaded);
        } else if (status == DownloadTaskStatus.failed) {
          _setPdfDownloadStatus(DownloadStatus.failed);
        } else if (status == DownloadTaskStatus.running) {
          _pdfDownloadStatus = DownloadStatus.downloading;
          _safeNotifyListeners();
        }
      } else if (id == _videoDownloadId) {
        if (status == DownloadTaskStatus.running ||
            status == DownloadTaskStatus.enqueued) {
          _videoDownloadProgress = progress;
        }

        if (status == DownloadTaskStatus.complete) {
          _setVideoDownloadStatus(DownloadStatus.downloaded);
        } else if (status == DownloadTaskStatus.failed) {
          _setVideoDownloadStatus(DownloadStatus.failed);
        } else if (status == DownloadTaskStatus.running) {
          _videoDownloadStatus = DownloadStatus.downloading;
          _safeNotifyListeners();
        }
      }
    });
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    AppSnackBar.show(
      context: context,
      message: message,
      type: isError ? SnackBarType.error : SnackBarType.success,
    );
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
