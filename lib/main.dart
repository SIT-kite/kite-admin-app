import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'app.dart';

void main() async {
  runApp(KiteAdminApp());
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final controller = MobileScannerController(facing: CameraFacing.back, torchEnabled: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                String? result = await Navigator.of(context).pushNamed<String?>('/scanner');
                print('扫码结果: ${result}');
              },
              child: Text('Hello'),
            )
          ],
        ));
  }
}
