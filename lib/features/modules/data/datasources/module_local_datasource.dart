import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/last_accessed_module_model.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:hive/hive.dart';

abstract class ModuleLocalDataSource {
  Future<void> cacheLastAccessedModule(LastAccessedModuleModel moduleToCache);
  Future<LastAccessedModuleModel?> getLastAccessedModule();
   Future<void> saveModules(int courseId, List<ModuleModel> modules);
  List<ModuleModel> getModules(int courseId);
  Future<void> clearModules(int courseId);
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
}
