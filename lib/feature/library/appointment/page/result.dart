import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity.dart';
import '../init.dart';

class QrResultPage extends StatelessWidget {
  final String content;

  const QrResultPage(this.content, {Key? key}) : super(key: key);

  static bool verify(QrCodeResponse response) {
    final clearText =
        '${response.application.period}|${response.application.user}|${response.application.index}|${response.application.id}|${response.timestamp.millisecondsSinceEpoch ~/ 1000}';
    final sign = response.sign;

    return LibraryAppointmentInitializer.publicKey
        .verifySHA256Signature(utf8.encode(clearText) as Uint8List, base64Decode(sign));
  }

  Widget buildDecryptionFailureView(BuildContext context, String message) {
    final titleStyle = Theme.of(context).textTheme.headline3;
    return Center(child: Text(message, textAlign: TextAlign.center, style: titleStyle));
  }

  Widget buildSuccessfulView(BuildContext context, QrCodeResponse data) {
    final titleStyle = Theme.of(context).textTheme.headline3;
    final textStyle = Theme.of(context).textTheme.headline6;

    TableRow row(String key, String value) =>
        TableRow(children: [Text(key, style: textStyle), Text(value, style: textStyle)]);

    return Card(
      margin: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.application.user, style: titleStyle),
            const Divider(height: 5, thickness: 3, indent: 8, endIndent: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Table(
                children: [
                  row('预约ID', '${data.application.id}'),
                  row('场次', '${data.application.period}'),
                  row('序号', '${data.application.index}'),
                ],
              ),
            ),
            Text('生成于 ${DateFormat('MM 月 dd 日 HH:mm:ss').format(data.timestamp.toLocal())}', style: textStyle),
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final data = QrCodeResponse.fromJson(jsonDecode(content));

    try {
      if (!verify(data)) {
        return buildDecryptionFailureView(context, '签名校验失败');
      }
    } catch (e) {
      return buildDecryptionFailureView(context, '无法识别的二维码');
    }
    return buildSuccessfulView(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描结果')),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/scanner');
          Navigator.of(context).pop();
          if (result != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrResultPage(result as String)));
          }
        },
      ),
    );
  }
}
