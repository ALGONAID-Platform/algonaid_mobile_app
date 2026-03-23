import 'package:algonaid_mobail_app/core/utils/hive/init_hive.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    // Hive.registerAdapter<BooksModel>(BooksModelAdapter());
    
    await Hive.initFlutter();
    await initHive();
  }
}
