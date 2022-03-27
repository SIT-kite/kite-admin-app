import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature/index.dart';
import 'storage/init.dart';
import 'util/logger.dart';

final _routes = {
  '/scanner': (context) => const ScannerPage(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/library': (context) => LibraryPage(),
  '/feedback': (context) => const FeedbackPage(),
  '/about': (context) => const AboutPage(),
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
    bool hasLogin = Storage.jwt.jwtToken != null;
    Widget materialApp = MaterialApp(
      title: "KiteAdmin",
      home: hasLogin ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _onGenerateRoute,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      builder: (context, widget) {
        ScreenUtil.setContext(context);
        return MediaQuery(
          // 设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
    );
    final withKeyboardListener = KeyboardListener(
      onKeyEvent: (event) {
        if (event is KeyUpEvent && LogicalKeyboardKey.escape == event.logicalKey) {
          Navigator.pop(context);
        }
      },
      focusNode: FocusNode(),
      child: materialApp,
    );
    final withScreenUtil = ScreenUtilInit(builder: () => withKeyboardListener);
    return withScreenUtil;
  }
}
