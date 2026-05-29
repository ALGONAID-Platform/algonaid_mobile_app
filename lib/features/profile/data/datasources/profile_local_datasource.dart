import 'dart:convert';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/features/profile/data/models/total_points_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveTotalPoints(TotalPointsModel points);
  Future<TotalPointsModel?> getTotalPoints();
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
    final jsonString = CacheHelper.getString(key: AppConstants.cacheTotalPoints);
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
}
