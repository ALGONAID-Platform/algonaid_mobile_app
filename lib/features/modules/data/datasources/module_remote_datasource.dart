// algonaid_mobail_app/lib/features/modules/data/datasources/module_remote_datasource.dart

import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';

abstract class ModuleRemoteDataSource {
  Future<List<ModuleModel>> getModulesByCourse(int courseId);
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final ApiService apiService;

  ModuleRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ModuleModel>> getModulesByCourse(int courseId) async {
    final response = await apiService.get(
      endpoint: EndPoint.modulesByCourse(courseId),
    );

    // Assuming the API returns a list of maps for modules
    final List<dynamic> moduleMaps = response as List<dynamic>;
    return moduleMaps.map((json) => ModuleModel.fromJson(json)).toList();
  }
}
