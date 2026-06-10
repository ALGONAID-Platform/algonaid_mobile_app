import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/last_accessed_module_model.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/module_grades_model.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/module_model.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

abstract class ModuleLocalDataSource {
  Future<void> cacheLastAccessedModule(LastAccessedModuleModel moduleToCache);
  Future<LastAccessedModuleModel?> getLastAccessedModule();
   Future<void> saveModules(int courseId, List<ModuleModel> modules);
  List<ModuleModel> getModules(int courseId);
  Future<void> clearModules(int courseId);
  Future<void> saveModuleGrades(int moduleId, ModuleGradesModel grades);
  Future<ModuleGradesModel?> getModuleGrades(int moduleId);
}



class ModuleLocalDataSourceImpl implements ModuleLocalDataSource {
    @override
  Future<void> cacheLastAccessedModule(LastAccessedModuleModel moduleToCache) async {
    final box = Hive.box<LastAccessedModuleModel>(AppConstants.boxLastAccessedModule);
    await box.put('LAST_ACCESSED', moduleToCache);
  }

  @override
  Future<LastAccessedModuleModel?> getLastAccessedModule() async {
    final box = Hive.box<LastAccessedModuleModel>(AppConstants.boxLastAccessedModule);
    return box.get('LAST_ACCESSED');
  }
  @override
  List<ModuleModel> getModules(int courseId) {
    final box = Hive.box<ModuleModel>(AppConstants.boxModules);
    return box.values.where((module) => module.courseId == courseId).toList();
  }

  @override
  Future<void> saveModules(int courseId, List<ModuleModel> modules) async {
    final box = Hive.box<ModuleModel>(AppConstants.boxModules);
    await clearModules(courseId);
    await box.addAll(modules);
  }

  @override
  Future<void> clearModules(int courseId) async {
    final box = Hive.box<ModuleModel>(AppConstants.boxModules);
    final keysToDelete = box.keys.where((key) {
      final module = box.get(key);
      return module?.courseId == courseId;
    }).toList();

    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }

  @override
  Future<void> saveModuleGrades(int moduleId, ModuleGradesModel grades) async {
    await CacheHelper.saveData(
      key: '${AppConstants.cacheModuleGradesPrefix}$moduleId',
      value: jsonEncode(grades.toJson()),
    );
  }

  @override
  Future<ModuleGradesModel?> getModuleGrades(int moduleId) async {
    final jsonString = CacheHelper.getString(
      key: '${AppConstants.cacheModuleGradesPrefix}$moduleId',
    );
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return ModuleGradesModel.fromJson(decoded as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
