import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() async {
  Hive.init(Directory.current.path + '/.dart_tool/hive');
  // I am not sure where Hive stores it on desktop/cli, probably need to mock token or skip it.
}
