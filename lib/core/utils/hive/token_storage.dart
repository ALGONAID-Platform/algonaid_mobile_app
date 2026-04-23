import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';

class TokenStorage {
  static String? _token; // In-memory token storage

  static Future<void> saveToken(String token) async {
    _token = token;
    await CacheHelper.saveData(key: AppConstants.tokenKey, value: token);
  }

  static String? getToken() {
    _token ??= CacheHelper.getString(key: AppConstants.tokenKey);
    if (_token == null || _token!.trim().isEmpty) {
      return null;
    }
    return _token;
  }

  static Future<void> deleteToken() async {
    _token = null;
    await CacheHelper.removeData(key: AppConstants.tokenKey);
  }
}
