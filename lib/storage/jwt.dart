import 'package:kite_admin/storage/dao/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JwtStorage implements JwtDao {
  final SharedPreferences _preferences;
  JwtStorage(this._preferences);

  static const ns = '/jwt';

  @override
  String? get jwtToken {
    return _preferences.getString(ns);
  }

  set jwtToken(String? val) {
    if (val == null) {
      _preferences.remove(ns);
      return;
    }
    _preferences.setString(ns, val);
  }
}
