
  import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasNoInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none);
  }