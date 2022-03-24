import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆管理'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            ListTile(
              title: const Text('扫码进馆'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('查看本次预约名单'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('查看本次已入馆人员'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
