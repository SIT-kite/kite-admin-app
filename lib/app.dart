import 'package:flutter/material.dart';
import 'package:kite_admin/component/scanner.dart';

import 'util/logger.dart';

final _routes = {
  '/scanner': (context) => const ScannerPage(),
};
Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  Log.info('跳转路由: ${settings.name}');
  return MaterialPageRoute(
    builder: (context) => _routes[settings.name]!(context),
    settings: settings,
  );
}

class KiteAdminApp extends StatelessWidget {
  const KiteAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Title",
      home: Home(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
