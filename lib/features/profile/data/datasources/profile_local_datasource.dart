import 'dart:convert';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/features/profile/data/models/total_points_model.dart';
import 'package:algonaid_mobile_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveTotalPoints(TotalPointsModel points);
  Future<TotalPointsModel?> getTotalPoints();
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getUserProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<void> saveTotalPoints(TotalPointsModel points) async {
    await CacheHelper.saveData(
      key: AppConstants.cacheTotalPoints,
      value: jsonEncode(points.toJson()),
    );
  }

  @override
  Future<TotalPointsModel?> getTotalPoints() async {
    final jsonString = CacheHelper.getString(
      key: AppConstants.cacheTotalPoints,
    );
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return TotalPointsModel.fromJson(decoded as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    await CacheHelper.saveData(
      key: AppConstants.cacheUserProfile,
      value: jsonEncode(profile.toJson()),
    );
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    final jsonString = CacheHelper.getString(
      key: AppConstants.cacheUserProfile,
    );
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return UserProfileModel.fromJson(decoded as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
