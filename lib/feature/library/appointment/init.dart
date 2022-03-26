import 'package:kite_admin/session/kite.dart';

import 'dao.dart';
import 'service.dart';

class LibraryAppointmentInitializer {
  static late KiteSession kiteSession;
  static late AppointmentDao appointmentService;
  static void init({
    required KiteSession kiteSession,
  }) {
    LibraryAppointmentInitializer.kiteSession = kiteSession;
    appointmentService = AppointmentService(kiteSession);
  }
}
