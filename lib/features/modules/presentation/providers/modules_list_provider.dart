// algonaid_mobail_app/lib/features/modules/presentation/providers/modules_list_provider.dart

import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_modules_by_course.dart';
import 'package:flutter/material.dart';

class ModulesListState {
  final bool isLoading;
  final String? errorMessage;
  final List<Module> modules;

  ModulesListState({
    this.isLoading = false,
    this.errorMessage,
    this.modules = const [],
  });

  ModulesListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Module>? modules,
  }) {
    return ModulesListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      modules: modules ?? this.modules,
    );
  }
}

class ModulesListProvider extends ChangeNotifier {
  final GetModulesByCourse getModulesByCourse;

  ModulesListProvider(this.getModulesByCourse);

  ModulesListState _state = ModulesListState();
  ModulesListState get state => _state;
Future<void> loadModules(int courseId) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await getModulesByCourse(courseId);

    // التحقق مما إذا كان الـ Provider قد تم إغلاقه أثناء انتظار البيانات
    if (!hasListeners) return; 

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          modules: [],
        );
      },
      (modules) {
        _state = _state.copyWith(isLoading: false, modules: modules);
      },
    );

    // تحقق مرة أخرى قبل إخطار المستمعين
    if (hasListeners) {
      notifyListeners();
    }
  }
}
