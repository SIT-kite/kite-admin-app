import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite_admin/global.dart';
import 'package:kite_admin/util/flash.dart';
import 'package:kite_admin/util/logger.dart';

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

    TableRow row(String key, String value, {Color? color}) =>
        TableRow(children: [Text(key, style: textStyle), Text(value, style: textStyle?.copyWith(color: color))]);

    // 记录进馆
    Future.delayed(Duration.zero, () async {
      final service = LibraryAppointmentInitializer.appointmentService;
      await service.updateApplication(data.application.id, 1);

      showBasicFlash(context, Text('${data.application.user} 记录入馆'));
    });

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
                  row('场次', '${data.application.period}',
                      color:
                          data.application.period != LibraryAppointmentInitializer.currentPeriod ? Colors.red : null),
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

  Future<void> beep() async {
    await Future.delayed(const Duration(milliseconds: 200));
    Log.info('报警声');
    await Global.player.play('warn.wav');
  }

  Widget buildBody(BuildContext context) {
    final data = QrCodeResponse.fromJson(jsonDecode(content));

    try {
      if (!verify(data)) {
        beep();
        return buildDecryptionFailureView(context, '签名校验失败');
      }
    } catch (e) {
      beep();
      return buildDecryptionFailureView(context, '无法识别的二维码');
    }

    bool notVerified = data.application.period != LibraryAppointmentInitializer.currentPeriod;
    if (notVerified) {
      beep();
    }
    return buildSuccessfulView(context, data);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      Navigator.of(context).pop();
    });
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
