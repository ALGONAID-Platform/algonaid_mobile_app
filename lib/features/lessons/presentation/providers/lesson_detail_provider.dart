import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/data/services/lesson_download_service.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:flutter/foundation.dart';

class LessonDetailState {
  final bool isLoading;
  final bool isDownloading;
  final bool isDownloaded;
  final String? errorMessage;
  final String? downloadError;
  final LessonDetail? lesson;

  const LessonDetailState({
    required this.isLoading,
    required this.isDownloading,
    required this.isDownloaded,
    required this.errorMessage,
    required this.downloadError,
    required this.lesson,
  });

  factory LessonDetailState.initial() {
    return const LessonDetailState(
      isLoading: false,
      isDownloading: false,
      isDownloaded: false,
      errorMessage: null,
      downloadError: null,
      lesson: null,
    );
  }

  LessonDetailState copyWith({
    bool? isLoading,
    bool? isDownloading,
    bool? isDownloaded,
    String? errorMessage,
    String? downloadError,
    LessonDetail? lesson,
  }) {
    return LessonDetailState(
      isLoading: isLoading ?? this.isLoading,
      isDownloading: isDownloading ?? this.isDownloading,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      errorMessage: errorMessage,
      downloadError: downloadError,
      lesson: lesson ?? this.lesson,
    );
  }
}

class LessonDetailProvider extends ChangeNotifier {
  final GetLessonDetail _getLessonDetail;
  final LessonDownloadService _downloadService;
  LessonDetailState _state = LessonDetailState.initial();

  LessonDetailProvider(this._getLessonDetail, this._downloadService);

  LessonDetailState get state => _state;

  Future<void> loadLesson(int lessonId) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _getLessonDetail(lessonId);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          lesson: null,
        );
        notifyListeners();
      },
      (lesson) {
        _state = _state.copyWith(
          isLoading: false,
          lesson: lesson,
          errorMessage: null,
        );
        notifyListeners();
        _syncDownloadStatus(lesson);
      },
    );
  }

  Future<LessonDownloadResult> downloadLesson() async {
    final lesson = _state.lesson;
    if (lesson == null) {
      return const LessonDownloadResult(
        success: false,
        isDownloaded: false,
        message: 'لا يوجد درس للتحميل.',
      );
    }

    _state = _state.copyWith(isDownloading: true, downloadError: null);
    notifyListeners();

    final result = await _downloadService.downloadLesson(lesson);
    _state = _state.copyWith(
      isDownloading: false,
      isDownloaded: result.isDownloaded,
      downloadError: result.success ? null : result.message,
    );
    notifyListeners();
    return result;
  }

  Future<LessonDownloadResult> deleteDownloadedLesson() async {
    final lesson = _state.lesson;
    if (lesson == null) {
      return const LessonDownloadResult(
        success: false,
        isDownloaded: false,
        message: 'لا يوجد درس للحذف.',
      );
    }

    _state = _state.copyWith(isDownloading: true, downloadError: null);
    notifyListeners();

    final result = await _downloadService.deleteLesson(lesson);
    _state = _state.copyWith(
      isDownloading: false,
      isDownloaded: result.isDownloaded,
      downloadError: result.success ? null : result.message,
    );
    notifyListeners();
    return result;
  }

  Future<void> _syncDownloadStatus(LessonDetail lesson) async {
    final status = await _downloadService.getDownloadStatus(lesson);
    _state = _state.copyWith(isDownloaded: status.isDownloaded);
    notifyListeners();
  }
}
