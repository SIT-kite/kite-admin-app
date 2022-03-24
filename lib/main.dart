import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  final pfs = await SharedPreferences.getInstance();
  runApp(KiteAdminApp());
}
