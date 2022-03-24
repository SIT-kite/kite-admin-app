import 'package:flutter/material.dart';

import 'feature/index.dart';
import 'util/logger.dart';

final _routes = {
  '/scanner': (context) => const ScannerPage(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/library': (context) => const LibraryPage(),
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
    return const MaterialApp(
      title: "KiteAdmin",
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
