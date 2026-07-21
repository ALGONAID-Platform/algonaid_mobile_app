import 'package:flutter/material.dart';
import 'package:algonaid/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid/features/modules/domain/usecases/get_last_accessed_module_usecase.dart';
import 'package:algonaid/features/modules/domain/usecases/get_cached_last_accessed_module_usecase.dart';
import 'package:algonaid/core/di/service_locator.dart';
import 'package:algonaid/features/modules/data/datasources/module_local_datasource.dart';
import 'package:algonaid/features/modules/data/models/last_accessed_module_model.dart';

class LastAccessedModuleProvider extends ChangeNotifier {
  final GetLastAccessedModuleUseCase getLastAccessedModuleUseCase;
  final GetCachedLastAccessedModuleUseCase getCachedLastAccessedModuleUseCase;

  LastAccessedModuleProvider({
    required this.getLastAccessedModuleUseCase,
    required this.getCachedLastAccessedModuleUseCase,
  }) {
    _loadCachedData();
  }

  void _loadCachedData() {
    getCachedLastAccessedModuleUseCase().then((cachedResult) {
      cachedResult.fold(
        (failure) {},
        (module) {
          if (module != null) {
            _lastAccessedModule = module;
            notifyListeners();
          }
        },
      );
    });
  }

  bool _isLoading = false;
  String? _errorMessage;
  LastAccessedModuleEntity? _lastAccessedModule;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LastAccessedModuleEntity? get lastAccessedModule => _lastAccessedModule;

  Future<void> fetchLastAccessedModule({bool forceRefresh = false}) async {
    // 1. قراءة الكاش وتحديد حالة التحميل
    final cachedResult = await getCachedLastAccessedModuleUseCase();
    bool hasCache = false;
    cachedResult.fold(
      (failure) {},
      (module) {
        if (module != null) {
          _lastAccessedModule = module;
          hasCache = true;
        }
      },
    );
    
    // إذا كان لدينا كاش ولا نريد تحديثاً إجبارياً، نعتمد على الكاش لكي لا نلغي تنقل المستخدم المحلي
    if (hasCache && !forceRefresh) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = _lastAccessedModule == null;
    notifyListeners();

    // 2. الجلب من الشبكة
    final result = await getLastAccessedModuleUseCase();
    result.fold(
      (failure) {
        if (_lastAccessedModule == null) {
          _errorMessage = failure.message;
        }
      },
      (module) {
        if (module != null) _lastAccessedModule = module;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLastAccessedModule(LastAccessedModuleEntity module) async {
    _lastAccessedModule = module;
    notifyListeners();
  }

  void updateProgressLocally({required int moduleId}) {
    if (_lastAccessedModule != null && _lastAccessedModule!.moduleId == moduleId) {
      int newCompleted = _lastAccessedModule!.completedLessons + 1;
      if (newCompleted > _lastAccessedModule!.totalLessons) {
        newCompleted = _lastAccessedModule!.totalLessons;
      }
      final double newPercentage = _lastAccessedModule!.totalLessons > 0 
          ? ((newCompleted / _lastAccessedModule!.totalLessons) * 100) 
          : 0.0;
      
      _lastAccessedModule = _lastAccessedModule!.copyWith(
        completedLessons: newCompleted,
        progressPercentage: newPercentage,
      );
      
      final modelToSave = LastAccessedModuleModel(
        moduleId: _lastAccessedModule!.moduleId,
        courseName: _lastAccessedModule!.courseName,
        moduleName: _lastAccessedModule!.moduleName,
        moduleDescription: _lastAccessedModule!.moduleDescription,
        totalLessons: _lastAccessedModule!.totalLessons,
        completedLessons: newCompleted,
        progressPercentage: newPercentage,
        image_url: _lastAccessedModule!.image_url,
      );
      try {
         getIt<ModuleLocalDataSource>().cacheLastAccessedModule(modelToSave);
      } catch (_) {}

      notifyListeners();
    } else {
      // If it's the very first lesson a user completes, _lastAccessedModule will be null.
      // So we fetch it from the API to initialize the "Continue Learning" card.
      fetchLastAccessedModule();
    }
  }

  void clearData() {
    _lastAccessedModule = null;
    _errorMessage = null;
    notifyListeners();
  }
}
