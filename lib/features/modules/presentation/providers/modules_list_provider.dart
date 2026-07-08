// algonaid_mobile_app/lib/features/modules/presentation/providers/modules_list_provider.dart

import 'package:algonaid_mobile_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_modules_by_course.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_cached_modules_usecase.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
import 'package:flutter/material.dart';

class ModulesListState {
  final bool isLoading;
  final bool isBackgroundUpdating;
  final String? errorMessage;
  final List<Module> modules;

  ModulesListState({
    this.isLoading = false,
    this.isBackgroundUpdating = false,
    this.errorMessage,
    this.modules = const [],
  });

  ModulesListState copyWith({
    bool? isLoading,
    bool? isBackgroundUpdating,
    String? errorMessage,
    List<Module>? modules,
  }) {
    return ModulesListState(
      isLoading: isLoading ?? this.isLoading,
      isBackgroundUpdating: isBackgroundUpdating ?? this.isBackgroundUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
      modules: modules ?? this.modules,
    );
  }
}

class ModulesListProvider extends ChangeNotifier {
  final GetModulesByCourse getModulesByCourse;
  final GetCachedModulesUsecase getCachedModules;

  ModulesListProvider(this.getModulesByCourse, this.getCachedModules);

  ModulesListState _state = ModulesListState();
  ModulesListState get state => _state;
  Future<void> loadModules(int courseId) async {
    // 1. Read from cache first
    final cachedResult = getCachedModules(courseId);
    cachedResult.fold(
      (failure) {}, // Ignore cache errors
      (cachedModules) {
        if (cachedModules.isNotEmpty) {
          _state = _state.copyWith(modules: cachedModules, isLoading: false, isBackgroundUpdating: true, errorMessage: null);
          notifyListeners();
        } else {
          _state = _state.copyWith(isLoading: true, isBackgroundUpdating: false, errorMessage: null);
          notifyListeners();
        }
      },
    );

    // If cache was empty, we are already showing isLoading. If cache was not empty, we fetch silently in background.
    
    // 2. Fetch from remote
    final result = await getModulesByCourse(courseId);

    // Check if Provider was disposed
    if (!hasListeners) return; 

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          isBackgroundUpdating: false,
          errorMessage: _state.modules.isEmpty ? failure.message : null, // only show error if no cache
        );
      },
      (modules) {
        _state = _state.copyWith(isLoading: false, isBackgroundUpdating: false, modules: modules, errorMessage: null);
      },
    );

    if (hasListeners) {
      notifyListeners();
    }
  }

  void updateModuleProgressLocally({required int moduleId, required int lessonId}) {
    final updatedModules = _state.modules.map((module) {
      if (module.id == moduleId) {
        bool alreadyCompleted = false;
        for (var l in module.lessons) {
          if (l.id == lessonId && l.status == LessonStatus.completed) {
            alreadyCompleted = true;
          }
        }
        if (alreadyCompleted) return module;

        final updatedLessons = module.lessons.map((lesson) {
          if (lesson.id == lessonId) {
            return lesson.copyWith(status: LessonStatus.completed);
          }
          return lesson;
        }).toList();

        int newCompleted = module.completedLessons + 1;
        if (newCompleted > module.totalLessons) {
          newCompleted = module.totalLessons;
        }

        final double newPercentage = module.totalLessons > 0 
            ? ((newCompleted / module.totalLessons) * 100) 
            : 0.0;

        return module.copyWith(
          lessons: updatedLessons,
          completedLessons: newCompleted,
          progressPercentage: newPercentage,
        );
      }
      return module;
    }).toList();

    _state = _state.copyWith(modules: updatedModules);
    notifyListeners();
  }
}
