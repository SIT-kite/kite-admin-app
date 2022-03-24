import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'global.dart';

void main() async {
  await Global.init();
  runApp(KiteAdminApp());
}
