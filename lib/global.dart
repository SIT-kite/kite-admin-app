import 'package:shared_preferences/shared_preferences.dart';

import 'storage/init.dart';

class Global {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    Global.sharedPreferences = await SharedPreferences.getInstance();
    Storage.init(sharedPreferences);
  }
}
