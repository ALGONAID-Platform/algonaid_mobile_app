import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/last_accessed_module_model.dart';
import 'package:hive/hive.dart';

abstract class ModuleLocalDataSource {
  Future<void> cacheLastAccessedModule(LastAccessedModuleModel moduleToCache);
  Future<LastAccessedModuleModel?> getLastAccessedModule();
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
}
