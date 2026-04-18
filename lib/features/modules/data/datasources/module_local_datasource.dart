import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ModuleLocalDataSource {
  Future<void> saveModules(List<ModuleModel> modules);
  List<ModuleModel> getModules(int courseId);
}

class ModuleLocalDataSourceImpl implements ModuleLocalDataSource {
  @override
  List<ModuleModel> getModules(int courseId) {
    final box = Hive.box<ModuleModel>(AppConstants.boxModules);
    return box.values
        .where((module) => module.courseId == courseId)
        .toList();
  }

  @override
  Future<void> saveModules(List<ModuleModel> modules) async {
    final box = Hive.box<ModuleModel>(AppConstants.boxModules);
    await box.clear(); // Clear existing modules to ensure fresh data
    await box.addAll(modules);
  }
}
