import '../../../../core/network/api_service.dart';
import '../models/total_points_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<TotalPointsModel> getTotalPoints();
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<TotalPointsModel> getTotalPoints() async {
    final response = await apiService.get(endpoint: '/progress/total-points');
    return TotalPointsModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await apiService.get(endpoint: '/users/profile');
    final responseData = response as Map<String, dynamic>;
    if (responseData.containsKey('user')) {
      return UserProfileModel.fromJson(responseData['user'] as Map<String, dynamic>);
    }
    return UserProfileModel.fromJson(responseData);
  }

  @override
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data) async {
    final response = await apiService.patch(
      endpoint: '/users/profile',
      data: data,
    );
    final responseData = response as Map<String, dynamic>;
    if (responseData.containsKey('user')) {
      return UserProfileModel.fromJson(responseData['user'] as Map<String, dynamic>);
    }
    return UserProfileModel.fromJson(responseData);
  }
}
