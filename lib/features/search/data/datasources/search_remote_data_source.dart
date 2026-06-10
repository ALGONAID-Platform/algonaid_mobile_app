import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/network/api_service.dart';
import 'package:algonaid_mobile_app/features/search/data/models/global_search_model.dart';

abstract class SearchRemoteDataSource {
  Future<GlobalSearchModel> searchCourses(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService apiService;

  const SearchRemoteDataSourceImpl({required this.apiService});

  @override
  Future<GlobalSearchModel> searchCourses(String query) async {
    final response = await apiService.get(
      endpoint: EndPoint.searchCourses,
      query: {'q': query},
    );
    return GlobalSearchModel.fromJson(response as Map<String, dynamic>);
  }
}
