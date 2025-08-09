import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> isNetworkAvailable() async {
    try {
      final statusList = await Connectivity().checkConnectivity();
      return statusList.any((s) => s != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
