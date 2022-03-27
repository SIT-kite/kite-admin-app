import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../entity.dart';
import '../init.dart';

class QrResultPage extends StatelessWidget {
  final String content;

  const QrResultPage(this.content, {Key? key}) : super(key: key);

  static bool verify(QrCodeResponse response) {
    var clearText =
        '${response.application.period}|${response.application.user}|${response.application.index}|${response.application.id}|${response.timestamp.millisecondsSinceEpoch ~/ 1000}';
    var sign = response.sign;

    print(clearText);
    print(sign);
    print(LibraryAppointmentInitializer.publicKey.toFormattedPEM());
    return LibraryAppointmentInitializer.publicKey
        .verifySHA256Signature(utf8.encode(clearText) as Uint8List, base64Decode(sign));
  }

  Widget buildDecryptionFailureView() {
    return const Center(child: Text('无法识别的二维码', textAlign: TextAlign.center));
  }

  Widget buildBody(BuildContext context) {
    final data = QrCodeResponse.fromJson(jsonDecode(content));

    if (!verify(data)) {
      return buildDecryptionFailureView();
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(data.application.user)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描结果')),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () async {
          final result = await Navigator.of(context).pushReplacementNamed('/scanner');
          if (result != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrResultPage(result as String)));
          }
        },
      ),
    );
  }
}
