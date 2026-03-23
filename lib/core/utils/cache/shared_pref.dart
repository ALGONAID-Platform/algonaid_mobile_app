// المسار: core/database/cache/cache_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  // 1️⃣ دالة التهيئة (يجب استدعاؤها في main.dart)
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // ============================================================
  // 2️⃣ دوال الحفظ (Generic Method) - تحفظ أي نوع بيانات بذكاء
  // ============================================================
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    if (value is List<String>) return await _sharedPreferences.setStringList(key, value);

    return false; // إذا كان النوع غير مدعوم
  }

  // ============================================================
  // 3️⃣ دوال الجلب (Getters)
  // ============================================================
  
  // جلب نص (مثل التوكن أو الاسم)
  static String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  // جلب قيمة منطقية (مثل هل المستخدم زار التطبيق من قبل؟)
  // القيمة الافتراضية null إذا لم تكن موجودة
  static bool? getBool({required String key}) {
    return _sharedPreferences.getBool(key);
  }

  // جلب رقم صحيح (مثل الـ ID)
  static int? getInt({required String key}) {
    return _sharedPreferences.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _sharedPreferences.getDouble(key);
  }

  // ============================================================
  // 4️⃣ دوال الحذف والتنظيف
  // ============================================================

  // حذف مفتاح معين (مثلاً حذف التوكن فقط)
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  // مسح كل شيء (عند تسجيل الخروج بالكامل)
  static Future<bool> clearData() async {
    return await _sharedPreferences.clear();
  }

  // ============================================================
  // 5️⃣ دوال مساعدة خاصة (Helpers) - لتسهيل الاستخدام
  // ============================================================
  
  // هل يوجد مفتاح بهذا الاسم؟
  static bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }
}