import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_last_accessed_module_usecase.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_cached_last_accessed_module_usecase.dart';

class LastAccessedModuleProvider extends ChangeNotifier {
  final GetLastAccessedModuleUseCase getLastAccessedModuleUseCase;
  final GetCachedLastAccessedModuleUseCase getCachedLastAccessedModuleUseCase;

  LastAccessedModuleProvider({
    required this.getLastAccessedModuleUseCase,
    required this.getCachedLastAccessedModuleUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  LastAccessedModuleEntity? _lastAccessedModule;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LastAccessedModuleEntity? get lastAccessedModule => _lastAccessedModule;

  Future<void> fetchLastAccessedModule() async {
    final cachedResult = await getCachedLastAccessedModuleUseCase();
    cachedResult.fold(
      (failure) {
        _isLoading = true;
        notifyListeners();
      },
      (module) {
        if (module != null) {
          _lastAccessedModule = module;
          notifyListeners();
        } else {
          _isLoading = true;
          notifyListeners();
        }
      },
    );

    final result = await getLastAccessedModuleUseCase();

    result.fold(
      (failure) {
        _isLoading = false;
        if (_lastAccessedModule == null) {
          _errorMessage = failure.message;
        }
        notifyListeners();
      },
      (module) {
        _isLoading = false;
        if (module != null) {
          _lastAccessedModule = module;
        }
        notifyListeners();
      },
    );
  }
}
