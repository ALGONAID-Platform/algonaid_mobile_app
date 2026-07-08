import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_last_accessed_module_usecase.dart';
import 'package:algonaid_mobile_app/features/modules/domain/usecases/get_cached_last_accessed_module_usecase.dart';

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

  Future<void> fetchLastAccessedModule() async {
    // 1. قراءة الكاش وتحديد حالة التحميل — إشعار واحد للحالة الأولية
    final cachedResult = await getCachedLastAccessedModuleUseCase();
    cachedResult.fold(
      (failure) {},
      (module) {
        if (module != null) _lastAccessedModule = module;
      },
    );
    // نُظهر التحميل فقط إذا لم يكن هناك كاش
    _isLoading = _lastAccessedModule == null;
    notifyListeners(); // ← إشعار أول للحالة الأولية (مع الكاش إن وُجد)

    // 2. الجلب من الشبكة — إشعار واحد عند الانتهاء
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
    notifyListeners(); // ← إشعار ثانٍ ووحيد عند اكتمال البيانات
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
