import 'package:crypton/crypton.dart';
import 'package:kite_admin/global.dart';
import 'package:kite_admin/session/kite.dart';

import 'dao.dart';
import 'service.dart';

class LibraryAppointmentInitializer {
  static late KiteSession kiteSession;
  static late AppointmentDao appointmentService;
  static late RSAPublicKey publicKey;
  static late int currentPeriod;

  static void init({
    required KiteSession kiteSession,
  }) {
    LibraryAppointmentInitializer.kiteSession = kiteSession;
    appointmentService = AppointmentService(kiteSession);

    Future.delayed(Duration.zero, () async {
      final pem = (await Global.dio.get('https://kite.sunnysab.cn/api/v2/library/publicKey')).data as String;
      publicKey = RSAPublicKey.fromPEM(pem);

      final current = await appointmentService.getCurrentPeriod();
      currentPeriod = current!.period!;
    });
  }
}
