
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

Future<bool> hasNoInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  final hasNetwork = connectivityResult.isNotEmpty &&
      !connectivityResult.contains(ConnectivityResult.none);
  if (!hasNetwork) return true;

  if (kIsWeb) {
    return false;
  }

  try {
    final result = await InternetAddress.lookup('example.com')
        .timeout(const Duration(seconds: 2));
    return result.isEmpty || result.first.rawAddress.isEmpty;
  } on TimeoutException {
    return true;
  } on SocketException {
    return true;
  }
}
