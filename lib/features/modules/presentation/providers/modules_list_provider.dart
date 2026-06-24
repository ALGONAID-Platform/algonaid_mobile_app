// algonaid_mobile_app/lib/features/modules/presentation/providers/modules_list_provider.dart

import 'package:algonaid_mobile_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_modules_by_course.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_cached_modules_usecase.dart';
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
}
