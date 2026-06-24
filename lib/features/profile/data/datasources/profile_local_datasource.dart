import 'dart:convert';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/features/profile/data/models/total_points_model.dart';
import 'package:algonaid_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:algonaid_mobile_app/features/profile/data/models/user_badge_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveTotalPoints(TotalPointsModel points);
  Future<TotalPointsModel?> getTotalPoints();
  TotalPointsModel? getTotalPointsSync();
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getUserProfile();
  UserProfileModel? getUserProfileSync();
  Future<void> saveUserBadges(List<UserBadgeModel> badges);
  Future<List<UserBadgeModel>?> getUserBadges();
  List<UserBadgeModel>? getUserBadgesSync();
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
  TotalPointsModel? getTotalPointsSync() {
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

  @override
  UserProfileModel? getUserProfileSync() {
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

  @override
  Future<void> saveUserBadges(List<UserBadgeModel> badges) async {
    final listJson = badges.map((e) => e.toJson()).toList();
    await CacheHelper.saveData(
      key: 'cache_user_badges',
      value: jsonEncode(listJson),
    );
  }

  @override
  Future<List<UserBadgeModel>?> getUserBadges() async {
    final jsonString = CacheHelper.getString(
      key: 'cache_user_badges',
    );
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        return decoded
            .map((e) => UserBadgeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  List<UserBadgeModel>? getUserBadgesSync() {
    final jsonString = CacheHelper.getString(
      key: 'cache_user_badges',
    );
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        return decoded
            .map((e) => UserBadgeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
