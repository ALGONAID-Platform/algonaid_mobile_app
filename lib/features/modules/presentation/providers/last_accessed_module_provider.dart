import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid_mobail_app/features/modules/domain/usecases/get_last_accessed_module_usecase.dart';

class LastAccessedModuleProvider extends ChangeNotifier {
  final GetLastAccessedModuleUseCase getLastAccessedModuleUseCase;

  LastAccessedModuleProvider({required this.getLastAccessedModuleUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  LastAccessedModuleEntity? _lastAccessedModule;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LastAccessedModuleEntity? get lastAccessedModule => _lastAccessedModule;

  Future<void> fetchLastAccessedModule() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getLastAccessedModuleUseCase();

    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (module) {
        _isLoading = false;
        _lastAccessedModule = module;
        notifyListeners();
      },
    );
  }
}
