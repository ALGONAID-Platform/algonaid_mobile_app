// ملف core/errors/exceptions.dart

// هذا كلاس يمثل "الاستثناءات" القادمة من السيرفر
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

// يمكنك أيضاً إضافة استثناءات أخرى مثل:
class CacheException implements Exception {} // لأخطاء Hive