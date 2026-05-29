import 'dart:convert';
import 'dart:io';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedLessonItem {
  final int lessonId;
  final String title;
  final String localVideoPath;
  final String? localPdfPath;
  final bool hasVideo;
  final bool hasPdf;

  DownloadedLessonItem({
    required this.lessonId,
    required this.title,
    required this.localVideoPath,
    this.localPdfPath,
    this.hasVideo = false,
    this.hasPdf = false,
  });
}

class DownloadedModuleItem {
  final int moduleId;
  final String title;
  final List<DownloadedLessonItem> lessons;

  DownloadedModuleItem({
    required this.moduleId,
    required this.title,
    required this.lessons,
  });
}

class DownloadedCourseItem {
  final int courseId;
  final String title;
  final String thumbnail;
  final List<DownloadedModuleItem> modules;

  DownloadedCourseItem({
    required this.courseId,
    required this.title,
    required this.thumbnail,
    required this.modules,
  });
}

class DownloadsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<DownloadedCourseItem> downloadedCourses = [];

  Future<void> fetchDownloadedLessons() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final Set<int> downloadedLessonIds = {};
      for (final key in keys) {
        if (key.startsWith('video_local_path_')) {
          final idStr = key.replaceFirst('video_local_path_', '');
          final id = int.tryParse(idStr);
          if (id != null) {
            downloadedLessonIds.add(id);
          }
        }
      }

      final boxCourses = Hive.box<CourseModel>(AppConstants.boxCourses);
      final boxMyCourses = Hive.box<CourseModel>(AppConstants.boxMyCourses);
      final boxModules = Hive.box<ModuleModel>(AppConstants.boxModules);
      final boxLessons = Hive.box<LessonModel>(AppConstants.boxLessons);
      final boxLessonDetails = Hive.box<String>(AppConstants.boxLessonDetails);

      final Map<int, List<DownloadedModuleItem>> courseToModules = {};
      final Map<int, List<DownloadedLessonItem>> moduleToLessons = {};

      final Map<int, String> courseNames = {};
      final Map<int, String> courseThumbnails = {};
      final Map<int, String> moduleNames = {};

      for (final lessonId in downloadedLessonIds) {
        final videoPath = prefs.getString('video_local_path_$lessonId') ?? '';
        final pdfPath = prefs.getString('pdf_local_path_$lessonId');

        String lessonTitle = 'درس غير معروف';
        int? moduleId;

        // ابحث في الـ Lesson Details اولا لانه الاكثر دقة اذا فتحه المستخدم
        final rawDetail = boxLessonDetails.get(lessonId.toString());
        if (rawDetail != null && rawDetail.isNotEmpty) {
          try {
            final detail = LessonDetailModel.fromJson(jsonDecode(rawDetail));
            lessonTitle = detail.title;
            moduleId = detail.moduleId;
          } catch (_) {}
        }

        // اذا لم نجدها، ابحث في Lessons Box
        if (moduleId == null) {
          for (final lesson in boxLessons.values) {
            if (lesson.id == lessonId) {
              lessonTitle = lesson.title;
              moduleId = lesson.moduleId;
              break;
            }
          }
        }

        if (moduleId == null) {
          // لم نجد اي بيانات للدرس، نضعه في "غير معروف"
          moduleId = -1;
          moduleNames[-1] = 'وحدات غير معروفة';
        }

        int courseId = -1;
        if (moduleId != -1) {
          // ابحث عن الموديول للحصول على الكورس
          for (final mod in boxModules.values) {
            if (mod.id == moduleId) {
              moduleNames[moduleId] = mod.title;
              courseId = mod.courseId;
              break;
            }
          }
        }

        if (courseId == -1) {
          courseNames[-1] = 'دورات غير معروفة';
          courseThumbnails[-1] = '';
        } else {
          // ابحث عن الكورس في كلا الصندوقين
          CourseModel? course;
          for (final c in boxMyCourses.values) {
            if (c.id == courseId) {
              course = c;
              break;
            }
          }
          if (course == null) {
            for (final c in boxCourses.values) {
              if (c.id == courseId) {
                course = c;
                break;
              }
            }
          }

          if (course != null) {
            courseNames[courseId] = course.title;
            courseThumbnails[courseId] = course.thumbnail;
          } else {
            courseNames[courseId] = 'دورة مجهولة';
            courseThumbnails[courseId] = '';
          }
        }

        bool hasVid = false;
        bool hasP = false;
        try {
          if (videoPath.isNotEmpty) {
            hasVid = File(videoPath).existsSync();
          }
        } catch (_) {}

        try {
          if (pdfPath != null && pdfPath.isNotEmpty) {
            hasP = File(pdfPath).existsSync();
          }
        } catch (_) {}

        final item = DownloadedLessonItem(
          lessonId: lessonId,
          title: lessonTitle,
          localVideoPath: videoPath,
          localPdfPath: pdfPath,
          hasVideo: hasVid,
          hasPdf: hasP,
        );

        moduleToLessons.putIfAbsent(moduleId, () => []).add(item);
      }

      // تجميع الموديولات
      moduleToLessons.forEach((modId, lessons) {
        int cId = -1;
        if (modId != -1) {
          for (final mod in boxModules.values) {
            if (mod.id == modId) {
              cId = mod.courseId;
              break;
            }
          }
        }

        final modItem = DownloadedModuleItem(
          moduleId: modId,
          title: moduleNames[modId] ?? 'وحدة غير معروفة',
          lessons: lessons,
        );

        courseToModules.putIfAbsent(cId, () => []).add(modItem);
      });

      // تجميع الكورسات
      final List<DownloadedCourseItem> result = [];
      courseToModules.forEach((cId, modules) {
        result.add(DownloadedCourseItem(
          courseId: cId,
          title: courseNames[cId] ?? 'دورة غير معروفة',
          thumbnail: courseThumbnails[cId] ?? '',
          modules: modules,
        ));
      });

      downloadedCourses = result;
    } catch (e) {
      debugPrint('Error fetching downloads: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
