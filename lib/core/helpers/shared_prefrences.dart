import 'package:shared_preferences/shared_preferences.dart';

import '../../injection_container.dart';

class CacheHelper {
  final sharedPref = getIt<SharedPreferences>();

  dynamic getData({required String key}) {
    dynamic data = sharedPref.get(key);

    if (data != null) {
      if (data is String) {
        return data.toString();
      } else if (data is int) {
        return data.toInt();
      } else if (data is double) {
        return data.toDouble();
      } else if (data is bool) {
        return data;
      }
    }
  }

  Future<bool> saveData({required String key, required dynamic val}) {
    if (val is bool) {
      return sharedPref.setBool(key, val);
    } else if (val is String) {
      return sharedPref.setString(key, val);
    } else if (val is int) {
      return sharedPref.setInt(key, val);
    } else {
      return sharedPref.setDouble(key, val);
    }
  }

  List<String> getDataList({required String key}) {
    return sharedPref.getStringList(key) ?? [];
  }

  Future<bool> saveDataList({required String key, required List<String> valList}) {
    return sharedPref.setStringList(key, valList);
  }
}
