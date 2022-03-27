import 'package:flutter/material.dart';
import 'package:kite_admin/feature/library/appointment/init.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../entity.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final service = LibraryAppointmentInitializer.appointmentService;

  ValueNotifier<List<ApplicationRecord>?> app = ValueNotifier(null);
  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  @override
  void initState() {
    reloadApplicationList();
    super.initState();
  }

  void reloadApplicationList() {
    service.getApplication(date: selectedDate.value).then((value) {
      app.value = value;
    });
  }

  String periodToString(int period) {
    return {1: '上午', 2: '下午', 3: '晚上'}[period % 10] ?? '未知';
  }

  Widget buildTable(List<ApplicationRecord> applications) {
    List<PlutoColumn> columns = [
      PlutoColumn(
        width: 80,
        title: '场次',
        field: 'period',
        type: PlutoColumnType.select(['上午', '下午', '晚上'], enableColumnFilter: true),
      ),
      PlutoColumn(
        width: 120,
        title: '学号',
        field: 'studentId',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 80,
        title: '状态',
        field: 'status',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 80,
        title: '序号',
        field: 'index',
        type: PlutoColumnType.text(),
      ),
    ];

    List<PlutoRow> rows = applications.map((e) {
      return PlutoRow(cells: {
        'period': PlutoCell(value: periodToString(e.period % 10)),
        'studentId': PlutoCell(value: e.user),
        'status': PlutoCell(value: e.status == 1 ? '已入馆' : '未入馆'),
        'index': PlutoCell(value: '${e.index} (${e.text})')
      });
    }).toList();

    return PlutoGrid(
      columns: columns,
      rows: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图书馆预约')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ValueListenableBuilder<DateTime>(
                  valueListenable: selectedDate,
                  builder: (context, value, child) {
                    return Text(
                      '${value.year} 年 ${value.month} 月 ${value.day} 日',
                      style: Theme.of(context).textTheme.headline5,
                    );
                  }),
              TextButton(
                child: const Text('切换日期'),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    currentDate: selectedDate.value,
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now().add(const Duration(days: 1)),
                    selectableDayPredicate: (date) => date.weekday != 1 && date.weekday != 2,
                  );

                  if (date != null) selectedDate.value = date;
                  app.value = null;
                  reloadApplicationList();
                },
              )
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<List<ApplicationRecord>?>(
              valueListenable: app,
              builder: (BuildContext context, List<ApplicationRecord>? value, Widget? child) {
                if (value == null) return const Center(child: CircularProgressIndicator());
                return buildTable(value);
              },
            ),
          ),
        ],
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
