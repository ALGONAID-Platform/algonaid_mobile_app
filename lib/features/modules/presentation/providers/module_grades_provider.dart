import 'package:algonaid_mobail_app/features/modules/domain/entities/module_grades.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_module_grades.dart';
import 'package:flutter/material.dart';

class ModuleGradesState {
  final bool isLoading;
  final String? errorMessage;
  final ModuleGrades? grades;

  ModuleGradesState({
    this.isLoading = false,
    this.errorMessage,
    this.grades,
  });

  ModuleGradesState copyWith({
    bool? isLoading,
    String? errorMessage,
    ModuleGrades? grades,
  }) {
    return ModuleGradesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // We want to be able to reset the error
      grades: grades ?? this.grades,
    );
  }
}

class ModuleGradesProvider extends ChangeNotifier {
  final GetModuleGrades getModuleGrades;
  final Map<int, ModuleGradesState> _states = {};

  ModuleGradesProvider({required this.getModuleGrades});

  ModuleGradesState getState(int moduleId) {
    return _states[moduleId] ?? ModuleGradesState();
  }

  Future<void> fetchGrades(int moduleId) async {
    // If we already have grades and aren't loading, maybe don't fetch again,
    // or fetch to update. Let's fetch to update but show loading if empty.
    final currentState = getState(moduleId);
    if (currentState.isLoading) return;

    _states[moduleId] = currentState.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await getModuleGrades(moduleId);

    result.fold(
      (failure) {
        _states[moduleId] = _states[moduleId]!.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (grades) {
        _states[moduleId] = _states[moduleId]!.copyWith(
          isLoading: false,
          grades: grades,
          errorMessage: null,
        );
      },
    );

    notifyListeners();
  }
}
