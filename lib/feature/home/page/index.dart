import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget buildMainMenu(String title, String path) {
    return Builder(
      builder: (context) {
        return ListTile(
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushNamed(path);
          },
        );
      },
    );
  }

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
            buildMainMenu('图书馆预约管理', '/library'),
            buildMainMenu('反馈', '/feedback'),
            buildMainMenu('关于', '/about'),
          ],
        ),
      ),
    );
  }
}
