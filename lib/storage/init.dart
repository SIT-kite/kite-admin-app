import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class Storage {
  static late JwtDao jwt;
  static Future<void> init(SharedPreferences sharedPreferences) async {
    jwt = JwtStorage(sharedPreferences);
  }
}
