import 'package:dio/dio.dart';
import 'package:kite_admin/session/kite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/library/appointment/init.dart';
import 'storage/init.dart';

class Global {
  static late SharedPreferences sharedPreferences;
  static late KiteSession kiteSession;
  static Dio dio = Dio();

  static Future<void> init() async {
    Global.sharedPreferences = await SharedPreferences.getInstance();
    Storage.init(sharedPreferences);
    kiteSession = KiteSession(dio, Storage.jwt);
    LibraryAppointmentInitializer.init(kiteSession: kiteSession);
  }
}
