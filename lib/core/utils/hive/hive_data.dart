import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 1. دالة لحفظ قائمة كاملة (مع مسح القديم) - تستخدم للكاش (مثل Home Feed)
Future<void> cacheList<T>(List<T> data, String boxName) async {
  var box = Hive.isBoxOpen(boxName)
      ? Hive.box<T>(boxName)
      : await Hive.openBox<T>(boxName);
  await box.clear(); // ✅ صحيح هنا لأننا نريد استبدال القائمة
  await box.addAll(data);
}

/// 2. دالة لحفظ عنصر واحد فقط (تحديث أو إضافة) بدون مسح الباقي
Future<void> saveSingleItem<T>(T item, String boxName, dynamic key) async {
  var box = Hive.isBoxOpen(boxName)
      ? Hive.box<T>(boxName)
      : await Hive.openBox<T>(boxName);
  await box.put(key, item); // ✅ نستخدم put لتحديث مفتاح محدد
}

/// 3. دالة لجلب كل البيانات كقائمة
List<T> getAllData<T>(String boxName) {
  if (!Hive.isBoxOpen(boxName)) return [];
  var box = Hive.box<T>(boxName);
  return box.values.toList();
}

/// 4. دالة لجلب عنصر واحد محدد بالمفتاح
T? getSingleItem<T>(String boxName, dynamic key) {
  if (!Hive.isBoxOpen(boxName)) return null;
  var box = Hive.box<T>(boxName);
  return box.get(key);
}

/// 5. دالة Pagination (كما هي، صحيحة)
List<T> getPaginatedData<T>(String boxName, int pageNumber) {
  if (!Hive.isBoxOpen(boxName)) return [];
  var box = Hive.box<T>(boxName);
  final int limit = AppConstants.itemsPerPage;
  int startIndex = pageNumber * limit;
  int endIndex = startIndex + limit;

  if (startIndex >= box.length) return [];
  if (endIndex > box.length) endIndex = box.length;

  return box.values.toList().sublist(startIndex, endIndex);
}
