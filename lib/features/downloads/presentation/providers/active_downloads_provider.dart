import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/utils/notification_service.dart';
import 'package:algonaid_mobile_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/datasources/lesson_detail_local_data_source.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobile_app/features/downloads/presentation/providers/active_downloads_provider.dart' show DownloadStatus;
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
void globalDownloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('global_downloader_send_port');
  send?.send([id, status, progress]);
}

class ActiveDownloadsProvider extends ChangeNotifier {
  static const bool supportsOfflineDownloads = !kIsWeb;

  final YoutubeExplode _yt = YoutubeExplode();
  final Dio _dio = Dio();

  ReceivePort? _port;
  SharedPreferences? _prefs;

  final Map<int, DownloadStatus> _pdfStatuses = {};
  final Map<int, DownloadStatus> _videoStatuses = {};

  final Map<int, int> _pdfProgresses = {};
  final Map<int, int> _videoProgresses = {};
  
  final Map<int, String?> _localPdfFilePaths = {};
  final Map<int, String?> _localVideoFilePaths = {};

  final Map<int, int> _lastNotifiedPdfProgress = {};
  final Map<int, int> _lastNotifiedVideoProgress = {};

  static bool _isDownloaderInitialized = false;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    if (supportsOfflineDownloads && !_isDownloaderInitialized) {
      _isDownloaderInitialized = true;
      FlutterDownloader.registerCallback(globalDownloadCallback);
      _bindBackgroundIsolate();
    }
  }

  DownloadStatus getPdfStatus(int lessonId) => _pdfStatuses[lessonId] ?? DownloadStatus.notDownloaded;
  DownloadStatus getVideoStatus(int lessonId) => _videoStatuses[lessonId] ?? DownloadStatus.notDownloaded;

  int getPdfProgress(int lessonId) => _pdfProgresses[lessonId] ?? 0;
  int getVideoProgress(int lessonId) => _videoProgresses[lessonId] ?? 0;
  
  String? getLocalPdfFilePath(int lessonId) => _localPdfFilePaths[lessonId];
  String? getLocalVideoFilePath(int lessonId) => _localVideoFilePaths[lessonId];

  String getSmartDownloadButtonLabel(int lessonId, {
    required bool hasVideo,
    required bool hasPdf,
    required bool downloadVideoSelected,
    required bool downloadPdfSelected,
  }) {
    final isPdfAlreadyDownloaded = getPdfStatus(lessonId) == DownloadStatus.downloaded;
    final isVideoAlreadyDownloaded = getVideoStatus(lessonId) == DownloadStatus.downloaded;

    final needsVideo = hasVideo && downloadVideoSelected && !isVideoAlreadyDownloaded;
    final needsPdf = hasPdf && downloadPdfSelected && !isPdfAlreadyDownloaded;

    if (needsVideo && needsPdf) return 'بدء التحميل';
    if (needsVideo && !needsPdf) return 'تحميل الفيديو';
    if (needsPdf && !needsVideo) return 'تحميل الـ PDF';
    return 'بدء التحميل';
  }

  Future<void> syncDownloadStatus(LessonDetail lesson) async {
    if (!supportsOfflineDownloads) return;
    _prefs ??= await SharedPreferences.getInstance();

    final docDir = await getApplicationDocumentsDirectory();
    final saveDir = '${docDir.path}/lesson_${lesson.id}';

    // PDF 
    final pdfFileName = _prefs?.getString('pdf_filename_${lesson.id}');
    String? localPdfFilePath;
    if (pdfFileName != null) {
      localPdfFilePath = '$saveDir/$pdfFileName';
    } else {
      final storedPath = _prefs?.getString('pdf_local_path_${lesson.id}');
      if (storedPath != null && storedPath.isNotEmpty) {
        localPdfFilePath = '$saveDir/${storedPath.split('/').last}';
      }
    }

    if (localPdfFilePath != null && File(localPdfFilePath).existsSync()) {
      final isPdfFullyDownloaded = _prefs?.getBool('pdf_fully_downloaded_${lesson.id}') ?? false;
      if (isPdfFullyDownloaded) {
        _pdfStatuses[lesson.id] = DownloadStatus.downloaded;
        _localPdfFilePaths[lesson.id] = localPdfFilePath;
      } else {
        if (_pdfStatuses[lesson.id] != DownloadStatus.downloading) {
          _pdfStatuses[lesson.id] = DownloadStatus.notDownloaded;
        }
      }
    } else {
      if (_pdfStatuses[lesson.id] != DownloadStatus.downloading) {
        _pdfStatuses[lesson.id] = DownloadStatus.notDownloaded;
      }
    }

    // Video
    final videoFileName = _prefs?.getString('video_filename_${lesson.id}');
    String? localVideoFilePath;
    if (videoFileName != null) {
      localVideoFilePath = '$saveDir/$videoFileName';
    } else {
      final storedPath = _prefs?.getString('video_local_path_${lesson.id}');
      if (storedPath != null && storedPath.isNotEmpty) {
        localVideoFilePath = '$saveDir/${storedPath.split('/').last}';
      }
    }

    bool isVideoFullyDownloaded = false;
    if (localVideoFilePath != null && File(localVideoFilePath).existsSync()) {
      isVideoFullyDownloaded = _prefs?.getBool('video_fully_downloaded_${lesson.id}') ?? false;
      if (isVideoFullyDownloaded) {
        _videoStatuses[lesson.id] = DownloadStatus.downloaded;
        _localVideoFilePaths[lesson.id] = localVideoFilePath;
      }
    }

    if (!isVideoFullyDownloaded) {
      final videoDownloadId = _prefs?.getString('video_download_id_${lesson.id}');
      if (videoDownloadId != null) {
        final tasks = await FlutterDownloader.loadTasks();
        bool isRunning = false;
        bool isComplete = false;
        for (final task in tasks ?? <DownloadTask>[]) {
          if (task.taskId == videoDownloadId) {
            if (task.status == DownloadTaskStatus.complete) isComplete = true;
            if (task.status == DownloadTaskStatus.running || task.status == DownloadTaskStatus.enqueued) isRunning = true;
          }
        }
        
        if (isComplete) {
          _videoStatuses[lesson.id] = DownloadStatus.downloaded;
          _localVideoFilePaths[lesson.id] = localVideoFilePath;
          await _prefs?.setBool('video_fully_downloaded_${lesson.id}', true);
        } else if (isRunning) {
          _videoStatuses[lesson.id] = DownloadStatus.downloading;
        } else {
          if (_videoStatuses[lesson.id] != DownloadStatus.downloading) {
            _videoStatuses[lesson.id] = DownloadStatus.notDownloaded;
          }
        }
      } else {
        if (_videoStatuses[lesson.id] != DownloadStatus.downloading) {
          _videoStatuses[lesson.id] = DownloadStatus.notDownloaded;
        }
      }
    }

    notifyListeners();
  }

  Future<void> downloadVideo(LessonDetail lesson, {void Function(String msg, bool isError)? onMessage}) async {
    if (!supportsOfflineDownloads) {
      onMessage?.call('تحميل الفيديو غير متاح على هذا الجهاز حالياً.', true);
      return;
    }

    if (_videoStatuses[lesson.id] == DownloadStatus.downloading) return;

    // Immediately show preparing state
    _videoStatuses[lesson.id] = DownloadStatus.downloading;
    _videoProgresses[lesson.id] = 0;
    notifyListeners();

    final videoUrl = await _resolveDownloadableVideoUrl(lesson.videoUrl);
    if (videoUrl == null) {
      _videoStatuses[lesson.id] = DownloadStatus.failed;
      notifyListeners();
      onMessage?.call('لا يوجد فيديو متاح للتحميل.', true);
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _lastNotifiedVideoProgress[lesson.id] = 0;

      await NotificationService().showProgressNotification(
        notificationId: lesson.id * 10 + 1,
        title: 'تحميل الفيديو: ${lesson.title}',
        body: 'جارٍ تجهيز التحميل...',
        progress: 0,
        maxProgress: 100,
      );

      final videoFileName = _getSafeFileName(lesson.title, 'mp4');
      final videoDownloadId = await FlutterDownloader.enqueue(
        url: videoUrl,
        savedDir: saveDir,
        fileName: videoFileName,
        showNotification: false,
        openFileFromNotification: false,
      );

      _prefs ??= await SharedPreferences.getInstance();
      await _prefs?.setString('video_download_id_${lesson.id}', videoDownloadId!);
      await _prefs?.setString('video_filename_${lesson.id}', videoFileName);
      await _prefs?.setString('video_local_path_${lesson.id}', '$saveDir/$videoFileName');
      
      _localVideoFilePaths[lesson.id] = '$saveDir/$videoFileName';

      await _cacheLessonDetail(lesson);
      onMessage?.call('بدأ تحميل الفيديو.', false);
    } catch (_) {
      _videoStatuses[lesson.id] = DownloadStatus.failed;
      notifyListeners();
      await NotificationService().cancelLocalNotification(lesson.id * 10 + 1);
      onMessage?.call('تعذر بدء تحميل الفيديو.', true);
    }
  }

  Future<void> downloadPdf(LessonDetail lesson, {void Function(String msg, bool isError)? onMessage}) async {
    if (!supportsOfflineDownloads) {
      onMessage?.call('تحميل المرفق غير متاح على هذا الجهاز حالياً.', true);
      return;
    }

    if (_pdfStatuses[lesson.id] == DownloadStatus.downloading) return;

    final attachmentUrl = resolveAttachmentUrl(lesson.pdfUrl);
    if (attachmentUrl == null) {
      onMessage?.call('لا يوجد ملف متاح للتحميل.', true);
      return;
    }

    if (Platform.isAndroid) await Permission.notification.request();

    final saveDir = await _prepareDownloadDirectory(lesson.id);

    try {
      _pdfProgresses[lesson.id] = 0;
      _pdfStatuses[lesson.id] = DownloadStatus.downloading;
      _lastNotifiedPdfProgress[lesson.id] = 0;
      notifyListeners();

      await NotificationService().showProgressNotification(
        notificationId: lesson.id * 10 + 2,
        title: 'تحميل الملف المرفق: ${lesson.title}',
        body: 'جارٍ تحميل ملف PDF... 0%',
        progress: 0,
        maxProgress: 100,
      );

      final attachmentExtension = await _resolveAttachmentExtension(lesson.pdfUrl);
      final pdfFileName = _getSafeFileName(lesson.title, attachmentExtension);
      final savePath = '$saveDir/$pdfFileName';

      _dio.download(
        attachmentUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = ((received / total) * 100).round().clamp(0, 100);
            _pdfProgresses[lesson.id] = progress;
            _pdfStatuses[lesson.id] = DownloadStatus.downloading;
            notifyListeners();

            final lastNotified = _lastNotifiedPdfProgress[lesson.id] ?? 0;
            if (progress - lastNotified >= 5 || progress == 100) {
              _lastNotifiedPdfProgress[lesson.id] = progress;
              NotificationService().showProgressNotification(
                notificationId: lesson.id * 10 + 2,
                title: 'تحميل الملف المرفق: ${lesson.title}',
                body: 'جارٍ تحميل ملف PDF... $progress%',
                progress: progress,
                maxProgress: 100,
              );
            }
          }
        },
        options: Options(followRedirects: true, maxRedirects: 10),
      ).then((_) async {
        final savedFile = File(savePath);
        if (!savedFile.existsSync() || savedFile.lengthSync() < 100) {
          throw Exception('الملف المحفوظ فارغ أو غير مكتمل');
        }

        _pdfProgresses[lesson.id] = 100;
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs?.setString('pdf_filename_${lesson.id}', pdfFileName);
        await _prefs?.setString('pdf_local_path_${lesson.id}', savePath);
        await _prefs?.setBool('pdf_fully_downloaded_${lesson.id}', true);
        
        _localPdfFilePaths[lesson.id] = savePath;

        await _cacheLessonDetail(lesson);
        _pdfStatuses[lesson.id] = DownloadStatus.downloaded;
        notifyListeners();

        await NotificationService().cancelLocalNotification(lesson.id * 10 + 2);
        onMessage?.call('تم تحميل الملف بنجاح.', false);
      }).catchError((e) async {
        debugPrint('PDF download error: $e');
        _pdfProgresses[lesson.id] = 0;
        _pdfStatuses[lesson.id] = DownloadStatus.failed;
        notifyListeners();

        await NotificationService().cancelLocalNotification(lesson.id * 10 + 2);
        onMessage?.call('تعذر تحميل الملف. تأكد من الاتصال بالإنترنت.', true);
      });
    } catch (e) {
      debugPrint('PDF download setup error: $e');
      _pdfProgresses[lesson.id] = 0;
      _pdfStatuses[lesson.id] = DownloadStatus.failed;
      notifyListeners();
      await NotificationService().cancelLocalNotification(lesson.id * 10 + 2);
      onMessage?.call('تعذر تحميل الملف. تأكد من الاتصال بالإنترنت.', true);
    }
  }

  void _bindBackgroundIsolate() {
    if (!supportsOfflineDownloads) return;

    _port = ReceivePort();
    IsolateNameServer.removePortNameMapping('global_downloader_send_port');
    IsolateNameServer.registerPortWithName(_port!.sendPort, 'global_downloader_send_port');

    _port!.listen((data) async {
      final id = data[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      _prefs ??= await SharedPreferences.getInstance();
      final keys = _prefs!.getKeys();
      int? matchedLessonId;
      for (final key in keys) {
        if (key.startsWith('video_download_id_')) {
          if (_prefs!.getString(key) == id) {
            final idStr = key.replaceFirst('video_download_id_', '');
            matchedLessonId = int.tryParse(idStr);
            break;
          }
        }
      }

      if (matchedLessonId != null) {
        if (status == DownloadTaskStatus.running || status == DownloadTaskStatus.enqueued) {
          _videoProgresses[matchedLessonId] = progress;
          _videoStatuses[matchedLessonId] = DownloadStatus.downloading;
          notifyListeners();

          final lastNotified = _lastNotifiedVideoProgress[matchedLessonId] ?? 0;
          if (progress - lastNotified >= 5 || progress == 100) {
            _lastNotifiedVideoProgress[matchedLessonId] = progress;
            NotificationService().showProgressNotification(
              notificationId: matchedLessonId * 10 + 1,
              title: 'تحميل الفيديو',
              body: 'جارٍ تحميل الفيديو... $progress%',
              progress: progress,
              maxProgress: 100,
            );
          }
        } else if (status == DownloadTaskStatus.complete) {
          _videoProgresses[matchedLessonId] = 100;
          await _prefs?.setBool('video_fully_downloaded_$matchedLessonId', true);
          NotificationService().cancelLocalNotification(matchedLessonId * 10 + 1);
          _videoStatuses[matchedLessonId] = DownloadStatus.downloaded;
          
          final docDir = await getApplicationDocumentsDirectory();
          final saveDir = '${docDir.path}/lesson_$matchedLessonId';
          final videoFileName = _prefs?.getString('video_filename_$matchedLessonId');
          if (videoFileName != null) {
            _localVideoFilePaths[matchedLessonId] = '$saveDir/$videoFileName';
          }
          
          notifyListeners();
        } else if (status == DownloadTaskStatus.failed) {
          NotificationService().cancelLocalNotification(matchedLessonId * 10 + 1);
          _videoStatuses[matchedLessonId] = DownloadStatus.failed;
          notifyListeners();
        }
      }
    });
  }

  Future<String?> _resolveDownloadableVideoUrl(String? videoUrl) async {
    if (videoUrl == null || videoUrl.isEmpty) return null;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      try {
        final videoId = VideoId(videoUrl);
        final manifest = await _yt.videos.streamsClient.getManifest(videoId);
        final qualitySetting = CacheHelper.getString(key: 'downloadQuality') ?? 'متوسطة';
        final muxedStreams = manifest.muxed.toList();
        if (muxedStreams.isEmpty) return null;
        muxedStreams.sort((a, b) => a.bitrate.compareTo(b.bitrate));

        MuxedStreamInfo streamInfo;
        if (qualitySetting == 'منخفضة (توفير البيانات)') streamInfo = muxedStreams.first;
        else if (qualitySetting == 'عالية (HD)') streamInfo = muxedStreams.last;
        else streamInfo = muxedStreams[muxedStreams.length ~/ 2];

        return streamInfo.url.toString();
      } catch (e) { return null; }
    }
    if (!videoUrl.startsWith('http')) return '${EndPoint.uploadsBaseUrl}$videoUrl';
    return videoUrl;
  }

  String? resolveAttachmentUrl(String? attachmentUrl) {
    if (attachmentUrl == null || attachmentUrl.isEmpty) return null;
    final driveFileId = _extractDriveFileId(attachmentUrl);
    if (driveFileId != null) return 'https://drive.google.com/uc?export=download&id=$driveFileId';
    if (attachmentUrl.startsWith('http')) return attachmentUrl;
    return '${EndPoint.uploadsBaseUrl}$attachmentUrl';
  }

  Future<String> _resolveAttachmentExtension(String? attachmentUrl) async {
    if (attachmentUrl == null || attachmentUrl.isEmpty) return 'pdf';
    final parsed = Uri.tryParse(attachmentUrl);
    final path = parsed?.path.isNotEmpty == true ? parsed!.path : attachmentUrl;
    final lowerPath = path.toLowerCase();
    final supportedExtensions = <String>['pdf', 'ppt', 'pptx', 'pptm', 'pps', 'ppsx'];

    for (final extension in supportedExtensions) {
      if (lowerPath.endsWith('.$extension')) return extension;
    }

    final resolvedUrl = resolveAttachmentUrl(attachmentUrl) ?? attachmentUrl;
    try {
      final response = await _dio.head(resolvedUrl);
      final contentDisposition = response.headers.value('content-disposition') ?? '';
      final contentType = response.headers.value('content-type')?.toLowerCase() ?? '';
      final dispositionMatch = RegExp(r'filename="([^"]+)"').firstMatch(contentDisposition);
      if (dispositionMatch != null && dispositionMatch.groupCount >= 1) {
        final filename = dispositionMatch.group(1)!.toLowerCase();
        for (final extension in supportedExtensions) {
          if (filename.endsWith('.$extension')) return extension;
        }
      }
      if (contentType.contains('pdf')) return 'pdf';
      if (contentType.contains('presentation') || contentType.contains('powerpoint') || contentType.contains('officedocument.presentationml')) return 'pptx';
    } catch (_) {}

    if (lowerPath.contains('drive.google.com')) return 'pdf';
    return 'pdf';
  }

  String? _extractDriveFileId(String url) {
    final patterns = <RegExp>[
      RegExp(r'https?://drive\.google\.com/file/d/([^/?#\s]+)'),
      RegExp(r'https?://drive\.google\.com/open\?id=([^&]+)'),
      RegExp(r'https?://drive\.google\.com/uc\?export=download&id=([^&]+)'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
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
      final examModel = exam != null ? (exam is ExamModel ? exam : ExamModel(id: exam.id, title: exam.title, description: exam.description, passingScore: exam.passingScore, maxAttempts: exam.maxAttempts, lessonId: exam.lessonId, questions: exam.questions)) : null;
      final lessonModel = LessonDetailModel(id: lesson.id, moduleId: lesson.moduleId, title: lesson.title, order: lesson.order, description: lesson.description, content: lesson.content, videoUrl: lesson.videoUrl, pdfUrl: lesson.pdfUrl, exam: examModel);
      await localDataSource.saveLessonDetail(lessonModel);
    } catch (e) { debugPrint('Error caching lesson details on download: $e'); }
  }

  Future<String> _prepareDownloadDirectory(int lessonId) async {
    final directory = await getApplicationDocumentsDirectory();
    final lessonDirectory = Directory('${directory.path}/lesson_$lessonId');
    if (!await lessonDirectory.exists()) await lessonDirectory.create(recursive: true);
    return lessonDirectory.path;
  }

  @override
  void dispose() {
    // Only close resources if absolutely needed. Since this is global, we usually don't dispose.
    super.dispose();
  }
}
