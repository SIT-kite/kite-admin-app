import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        leadingWidth: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            ListTile(
              title: const Text('图书馆管理'),
              onTap: () {
                Navigator.of(context).pushNamed('/library');
              },
            ),
          ],
        ),
      ),
    );
  }
}
