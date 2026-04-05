import 'dart:io';
import 'package:flutter/foundation.dart';

const String API_PORT = String.fromEnvironment('API_PORT', defaultValue: '3000');
const String API_HOST = String.fromEnvironment('API_HOST', defaultValue: '');
const bool API_HTTPS = bool.fromEnvironment('API_HTTPS', defaultValue: false);
const bool USE_ANDROID_EMULATOR_HOST =
    bool.fromEnvironment('USE_ANDROID_EMULATOR_HOST', defaultValue: false);

const String LAN_IP = '172.24.96.1';
const String ANDROID_EMULATOR_HOST = '10.0.2.2';
const String IOS_SIMULATOR_HOST = '127.0.0.1';
const String DESKTOP_HOST = '127.0.0.1';

class EndPoint {
  static String get _scheme => API_HTTPS ? 'https' : 'http';
  static String get _host {
    if (API_HOST.isNotEmpty) {
      return API_HOST;
    }
    if (kIsWeb) {
      return 'localhost';
    }
    if (Platform.isAndroid) {
      return USE_ANDROID_EMULATOR_HOST ? ANDROID_EMULATOR_HOST : LAN_IP;
    }
    if (Platform.isIOS) {
      return IOS_SIMULATOR_HOST;
    }
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return DESKTOP_HOST;
    }
    return LAN_IP;
  }

  // Base url for app API
  static String get baseUrl => '$_scheme://$_host:$API_PORT/api/v1';
  // Base url for uploaded files
  static String get uploadsBaseUrl => '$_scheme://$_host:$API_PORT/uploads/';
  // API endpoints
  static String get signin => '$baseUrl/auth/signin';
  static String get signup => '$baseUrl/auth/signup';

  // For dynamic endpoints with parameters
  static String bookDetails(int id) => '/books/$id';
  static String lessonsByModule(int moduleId) =>
      '$baseUrl/lessons/module/$moduleId';
  static String lessonDetails(int lessonId) => '$baseUrl/lessons/$lessonId';
}
