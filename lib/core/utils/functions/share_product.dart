// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

// void shareProduct(String imageUrl, String description) async {
//   try {
//     // 1. تحميل الصورة
//     final response = await http.get(Uri.parse(imageUrl));
//     final bytes = response.bodyBytes;

//     // 2. حفظ الصورة مؤقتًا
//     final tempDir = await getTemporaryDirectory();
//     final file = await File('${tempDir.path}/product.jpg').create();
//     await file.writeAsBytes(bytes);

//     // 3. مشاركة الصورة مع النص
//     await Share.shareXFiles(
//       [XFile(file.path)],
//       text: description,
//     );
//   } catch (e) {
//     print('Error sharing product: $e');
//   }
// }