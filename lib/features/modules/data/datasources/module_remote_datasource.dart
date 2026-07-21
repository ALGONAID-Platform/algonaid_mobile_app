// algonaid/lib/features/modules/data/datasources/module_remote_datasource.dart

import 'package:algonaid/core/constants/endpoints.dart';
import 'package:algonaid/core/network/api_service.dart';
import 'package:algonaid/features/modules/data/models/module_model.dart';
import 'package:algonaid/features/modules/data/models/last_accessed_module_model.dart';
import 'package:algonaid/features/modules/data/models/module_grades_model.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';

abstract class ModuleRemoteDataSource {
  Future<List<ModuleModel>> getModulesByCourse(int courseId);
  Future<LastAccessedModuleModel?> getLastAccessedModule();
  Future<ModuleGradesModel> getModuleGrades(int moduleId);
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final ApiService apiService;

  ModuleRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ModuleModel>> getModulesByCourse(int courseId) async {
    final isGuest = TokenStorage.getToken() == null;
    final response = await apiService.get(
      endpoint: isGuest ? EndPoint.modulesByCourseGuest(courseId) : EndPoint.modulesByCourse(courseId),
    );

    // Assuming the API returns a list of maps for modules
    final List<dynamic> moduleMaps = response as List<dynamic>;
    return moduleMaps.map((json) => ModuleModel.fromJson(json)).toList();
  }

  @override
  Future<LastAccessedModuleModel?> getLastAccessedModule() async {
    final response = await apiService.get(
      endpoint: EndPoint.lastAccessedModule,
    );

    if (response != null) {
      if (response is Map<String, dynamic>) {
        return LastAccessedModuleModel.fromJson(response);
      }
    }
    return null;
  }

  @override
  Future<ModuleGradesModel> getModuleGrades(int moduleId) async {
    final response = await apiService.get(
      endpoint: EndPoint.moduleGrades(moduleId),
    );

    return ModuleGradesModel.fromJson(response as Map<String, dynamic>);
  }
}
