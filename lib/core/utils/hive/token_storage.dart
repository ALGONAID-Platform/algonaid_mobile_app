import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokenStorage {
  static Future<void> init() async {
    await Hive.openBox(AppConstants.boxAuthTokenName);
  }

  static Future<void> saveToken(String token) async {
    var box = Hive.box(AppConstants.boxAuthTokenName);
    await box.put(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    var box = Hive.box(AppConstants.boxAuthTokenName);
    return box.get(AppConstants.tokenKey);
  }

  static Future<void> deleteToken() async {
    var box = Hive.box(AppConstants.boxAuthTokenName);
    await box.delete(AppConstants.tokenKey);
  }
}
