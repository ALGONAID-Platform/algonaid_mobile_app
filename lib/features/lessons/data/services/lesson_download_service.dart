import 'dart:io';

import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LessonDownloadStatus {
  final bool isDownloaded;
  final String? pdfPath;
  final String? videoPath;
  final String? folderPath;

  const LessonDownloadStatus({
    required this.isDownloaded,
    this.pdfPath,
    this.videoPath,
    this.folderPath,
  });
}

class LessonDownloadResult {
  final bool success;
  final bool isDownloaded;
  final String message;

  const LessonDownloadResult({
    required this.success,
    required this.isDownloaded,
    required this.message,
  });
}

class LessonDownloadService {
  final ApiService _api;

  const LessonDownloadService(this._api);

  Future<LessonDownloadStatus> getDownloadStatus(LessonDetail lesson) async {
    final box = await _openBox();
    final cached = box.get(lesson.id);
    if (cached is Map) {
      final data = cached.map((key, value) => MapEntry(key.toString(), value));
      final pdfPath = data['pdfPath']?.toString();
      final videoPath = data['videoPath']?.toString();
      final folderPath = data['folderPath']?.toString();
      final pdfExists = pdfPath != null && File(pdfPath).existsSync();
      final videoExists = videoPath != null && File(videoPath).existsSync();
      if (pdfExists || videoExists) {
        return LessonDownloadStatus(
          isDownloaded: true,
          pdfPath: pdfExists ? pdfPath : null,
          videoPath: videoExists ? videoPath : null,
          folderPath: folderPath,
        );
      }
      await box.delete(lesson.id);
    }
    return const LessonDownloadStatus(isDownloaded: false);
  }

  Future<LessonDownloadResult> downloadLesson(LessonDetail lesson) async {
    final permissionOk = await _ensureStoragePermission();
    if (!permissionOk) {
      return const LessonDownloadResult(
        success: false,
        isDownloaded: false,
        message: 'يجب السماح بالوصول للتخزين لحفظ الملفات.',
      );
    }

    final folder = await _ensureDownloadFolder();
    if (folder == null) {
      return const LessonDownloadResult(
        success: false,
        isDownloaded: false,
        message: 'تعذر الوصول إلى مساحة التخزين.',
      );
    }

    final lessonDir = await _ensureLessonFolder(folder, lesson);
    final pdfUrl = _resolvePdfUrl(lesson.pdfUrl);
    final videoUrl = _resolveVideoUrl(lesson.videoUrl);

    String? pdfPath;
    String? videoPath;
    final errors = <String>[];

    if (pdfUrl != null) {
      final pdfFileName = '${_sanitizeTitle(lesson.title)}.pdf';
      final pdfFile = File('${lessonDir.path}/$pdfFileName');
      try {
        await _api.download(finalUrl: pdfUrl, path: pdfFile.path);
        pdfPath = pdfFile.path;
      } catch (_) {
        errors.add('فشل تحميل ملف PDF');
      }
    }

    if (videoUrl != null) {
      if (_isYoutubeUrl(videoUrl)) {
        final videoFileName = '${_sanitizeTitle(lesson.title)}.mp4';
        final videoFile = File('${lessonDir.path}/$videoFileName');
        YoutubeExplode? yt;
        try {
          yt = YoutubeExplode();
          final manifest = await yt.videos.streamsClient.getManifest(videoUrl);
          final streamInfo = manifest.muxed.withHighestBitrate();

          if (streamInfo != null) {
            final stream = yt.videos.streamsClient.get(streamInfo);
            final fileStream = videoFile.openWrite();
            await stream.pipe(fileStream);
            await fileStream.flush();
            await fileStream.close();
            videoPath = videoFile.path;
          } else {
            errors.add('فشل تحميل الفيديو: لا يوجد دفق متاح');
          }
        } catch (e) {
          errors.add('فشل تحميل الفيديو: $e');
        } finally {
          yt?.close();
        }
      } else {
        final extension = _extractExtension(videoUrl) ?? 'mp4';
        final videoFileName = '${_sanitizeTitle(lesson.title)}.$extension';
        final videoFile = File('${lessonDir.path}/$videoFileName');
        try {
          await _api.download(finalUrl: videoUrl, path: videoFile.path);
          videoPath = videoFile.path;
        } catch (_) {
          errors.add('فشل تحميل الفيديو');
        }
      }
    }

    if (pdfPath == null && videoPath == null) {
      final message =
          errors.isNotEmpty ? errors.join(' ') : 'لا توجد ملفات للتحميل.';
      return LessonDownloadResult(
        success: false,
        isDownloaded: false,
        message: message,
      );
    }

    await _saveDownloadRecord(
      lesson: lesson,
      pdfPath: pdfPath,
      videoPath: videoPath,
      folderPath: lessonDir.path,
    );

    final message = errors.isEmpty
        ? 'تم حفظ الدرس بنجاح.'
        : 'تم حفظ بعض الملفات مع ملاحظة: ${errors.join(' ')}';

    return LessonDownloadResult(
      success: true,
      isDownloaded: true,
      message: message,
    );
  }

  Future<LessonDownloadResult> deleteLesson(LessonDetail lesson) async {
    final box = await _openBox();
    final cached = box.get(lesson.id);
    if (cached is Map) {
      final data = cached.map((key, value) => MapEntry(key.toString(), value));
      final folderPath = data['folderPath']?.toString();
      if (folderPath != null) {
        final dir = Directory(folderPath);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      } else {
        final folder = await _ensureDownloadFolder();
        if (folder != null) {
          final lessonDir = Directory(
            '${folder.path}/${_sanitizeTitle(lesson.title)}',
          );
          if (await lessonDir.exists()) {
            await lessonDir.delete(recursive: true);
          }
        }
      }
      await box.delete(lesson.id);
      return const LessonDownloadResult(
        success: true,
        isDownloaded: false,
        message: 'تم حذف ملفات الدرس.',
      );
    }

    return const LessonDownloadResult(
      success: false,
      isDownloaded: false,
      message: 'لا توجد ملفات محفوظة لهذا الدرس.',
    );
  }

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) {
      return false;
    }

    final manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<Directory?> _ensureDownloadFolder() async {
    final rootDir = await _getRootStorageDirectory();
    if (rootDir == null) return null;
    final folder = Directory(
      '${rootDir.path}/${AppConstants.platformDownloadsFolderName}',
    );
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  Future<Directory?> _getRootStorageDirectory() async {
    final externalDir = await getExternalStorageDirectory();
    if (externalDir == null) return null;
    final pathParts = externalDir.path.split('/Android/');
    if (pathParts.isEmpty) return externalDir;
    return Directory(pathParts.first);
  }

  Future<Directory> _ensureLessonFolder(
    Directory root,
    LessonDetail lesson,
  ) async {
    final lessonDir = Directory('${root.path}/${_sanitizeTitle(lesson.title)}');
    if (!await lessonDir.exists()) {
      await lessonDir.create(recursive: true);
    }
    return lessonDir;
  }

  String? _resolvePdfUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    if (url.startsWith('http')) return url;
    final cleaned = url.startsWith('uploads/')
        ? url.replaceFirst('uploads/', '')
        : url;
    return '${EndPoint.uploadsBaseUrl}$cleaned';
  }

  String? _resolveVideoUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    if (url.startsWith('http')) return url;
    return null;
  }

  String _sanitizeTitle(String title) {
    final sanitized = title
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\.+$'), '')
        .trim();
    if (sanitized.isEmpty) {
      return 'lesson';
    }
    return sanitized;
  }

  bool _isYoutubeUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('youtube.com') || lower.contains('youtu.be');
  }

  String? _extractExtension(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final path = uri.path;
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return null;
    return path.substring(dot + 1);
  }

  String? _resolveDownloadedPath(dynamic result) {
    if (result is String && result.isNotEmpty) {
      return result;
    }
    return null;
  }

  Future<void> _saveDownloadRecord({
    required LessonDetail lesson,
    required String? pdfPath,
    required String? videoPath,
    required String folderPath,
  }) async {
    final box = await _openBox();
    await box.put(lesson.id, {
      'lessonId': lesson.id,
      'title': lesson.title,
      'pdfPath': pdfPath,
      'videoPath': videoPath,
      'folderPath': folderPath,
      'downloadedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Box<dynamic>> _openBox() async {
    return Hive.isBoxOpen(AppConstants.boxLessonDownloads)
        ? Hive.box(AppConstants.boxLessonDownloads)
        : await Hive.openBox(AppConstants.boxLessonDownloads);
  }
}
