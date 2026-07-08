import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/utils/notification_service.dart';
import 'package:algonaid_mobile_app/features/practice_exams/data/models/practice_exam_model.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/entities/practice_exam_entity.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/usecases/get_practice_exams_usecase.dart';
import 'package:flutter/material.dart';

class PracticeExamsProvider extends ChangeNotifier {
  final GetPracticeExamsUseCase getPracticeExamsUseCase;

  PracticeExamsProvider({required this.getPracticeExamsUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  List<PracticeExamEntity> _exams = [];

  // Track downloaded status: map of exam ID to its local file path
  final Map<int, String> _downloadedExams = {};
  
  // Track downloading progress: map of exam ID to progress percentage (0-1)
  final Map<int, double> _downloadingProgress = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PracticeExamEntity> get exams => _exams;
  Map<int, String> get downloadedExams => _downloadedExams;
  Map<int, double> get downloadingProgress => _downloadingProgress;

  Future<void> fetchPracticeExams(int courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getPracticeExamsUseCase(courseId);

    result.fold(
      (failure) async {
        final cached = await _loadCachedExams(courseId);
        if (cached.isNotEmpty) {
          _exams = cached;
          await _checkDownloadedExams();
          _errorMessage = null; // Clear error since we have cached data
        } else {
          _errorMessage = failure.message;
        }
        _isLoading = false;
        notifyListeners();
      },
      (examsList) async {
        _exams = examsList;
        await _cacheExams(courseId, examsList);
        await _checkDownloadedExams();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> _cacheExams(int courseId, List<PracticeExamEntity> examsList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final models = examsList.map((e) => PracticeExamModel(
        id: e.id,
        title: e.title,
        description: e.description,
        pdfUrl: e.pdfUrl,
        grade: e.grade,
        courseId: e.courseId,
        createdAt: e.createdAt,
      ).toJson()).toList();
      await prefs.setString('practice_exams_course_$courseId', jsonEncode(models));
    } catch (_) {}
  }

  Future<List<PracticeExamEntity>> _loadCachedExams(int courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('practice_exams_course_$courseId');
      if (jsonStr != null) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        return decoded.map((json) => PracticeExamModel.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _checkDownloadedExams() async {
    final prefs = await SharedPreferences.getInstance();
    for (var exam in _exams) {
      final path = prefs.getString('practice_exam_pdf_${exam.id}');
      if (path != null && File(path).existsSync()) {
        _downloadedExams[exam.id] = path;
      } else {
        _downloadedExams.remove(exam.id);
      }
    }
  }

  String _resolveDownloadUrl(String sourceUrl) {
    if (!sourceUrl.startsWith('http')) {
      return '${EndPoint.uploadsBaseUrl}$sourceUrl';
    }
    final driveFileId = _extractDriveFileId(sourceUrl);
    if (driveFileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$driveFileId';
    }
    return sourceUrl;
  }

  String? _extractDriveFileId(String url) {
    final patterns = <RegExp>[
      RegExp(r'https?://drive\.google\.com/file/d/([^/?#\s]+)'),
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

  Future<void> downloadExams(List<PracticeExamEntity> examsToDownload, BuildContext context) async {
    if (Platform.isAndroid) await Permission.notification.request();
    await Permission.storage.request();

    final prefs = await SharedPreferences.getInstance();
    final docDir = await getApplicationDocumentsDirectory();
    final saveDir = Directory('${docDir.path}/practice_exams');
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    final dio = Dio();

    for (var exam in examsToDownload) {
      if (exam.pdfUrl.isEmpty) continue;
      
      // Prevent downloading if already downloaded or currently downloading
      if (_downloadedExams.containsKey(exam.id) || _downloadingProgress.containsKey(exam.id)) continue;

      final url = _resolveDownloadUrl(exam.pdfUrl);

      final fileName = 'exam_${exam.id}.pdf';
      final savePath = '${saveDir.path}/$fileName';

      _downloadingProgress[exam.id] = 0.0;
      notifyListeners();
      
      final notificationId = exam.id + 10000; // unique ID for progress notification

      try {
        // Show initial progress notification
        await NotificationService().showProgressNotification(
          notificationId: notificationId,
          title: 'تحميل نموذج: ${exam.title}',
          body: 'جاري التحميل...',
          progress: 0,
          maxProgress: 100,
        );

        int lastProgressUpdate = 0;

        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progressValue = received / total;
              _downloadingProgress[exam.id] = progressValue;
              notifyListeners();
              
              final int progressPercent = (progressValue * 100).toInt();
              // Update notification every 5% to avoid spamming the system
              if (progressPercent - lastProgressUpdate >= 5 || progressPercent == 100) {
                lastProgressUpdate = progressPercent;
                NotificationService().showProgressNotification(
                  notificationId: notificationId,
                  title: 'تحميل نموذج: ${exam.title}',
                  body: 'جاري التحميل... $progressPercent%',
                  progress: progressPercent,
                  maxProgress: 100,
                );
              }
            }
          },
        );

        _downloadedExams[exam.id] = savePath;
        await prefs.setString('practice_exam_pdf_${exam.id}', savePath);
        
        // Show completion notification
        await NotificationService().cancelLocalNotification(notificationId);
        await NotificationService().showNotification(
          title: 'اكتمل التحميل',
          body: 'تم تحميل نموذج: ${exam.title} بنجاح',
        );

      } catch (e) {
        debugPrint('Error downloading practice exam ${exam.id}: $e');
        
        // Cancel progress notification and show error
        await NotificationService().cancelLocalNotification(notificationId);
        await NotificationService().showNotification(
          title: 'فشل التحميل',
          body: 'تعذر تحميل نموذج: ${exam.title}',
        );

        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('تعذر تحميل النموذج: ${exam.title}'),
               backgroundColor: Colors.red,
             ),
           );
        }
      } finally {
        _downloadingProgress.remove(exam.id);
        notifyListeners();
      }
    }
  }
}
