import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kite_admin/component/text_checkbox.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆预约管理'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '2022年3月24日',
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextButton(
                  child: const Text('切换日期'),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                      selectableDayPredicate: (date) {
                        return date.weekday != 1 && date.weekday != 2;
                      },
                    );
                  },
                )
              ],
            ),
            Wrap(
              children: const [
                TextCheckbox(title: Text('上午')),
                TextCheckbox(title: Text('下午')),
                TextCheckbox(title: Text('筛选逾约用户')),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('XXX (1910412345)'),
                    subtitle: Text('进馆时间: 08:24'),
                    trailing: Icon(Icons.check, color: Colors.green),
                  ),
                  ListTile(
                    title: Text('XXX (1910412345)'),
                    subtitle: Text('未进馆'),
                  ),
                  ListTile(
                    title: Text('XXX (1910412345)'),
                    subtitle: Text('未按预约时间入馆'),
                    trailing: Icon(Icons.error, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/scanner');
          print('扫码结果: $result');
        },
      ),
    );
  }
}
