import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kite_admin/feature/library/appointment/init.dart';
import 'package:kite_admin/feature/library/appointment/page/result.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../entity.dart';

class LibraryPage extends StatelessWidget {
  final service = LibraryAppointmentInitializer.appointmentService;

  final ValueNotifier<List<ApplicationRecord>?> app = ValueNotifier(null);
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  LibraryPage({Key? key}) : super(key: key);

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
        type: PlutoColumnType.select(['上午', '下午', '晚上']),
        readOnly: true,
      ),
      PlutoColumn(
        width: 120,
        title: '学号',
        field: 'studentId',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        width: 80,
        title: '状态',
        field: 'status',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        width: 80,
        title: '序号',
        field: 'index',
        type: PlutoColumnType.text(),
        readOnly: true,
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
      onLoaded: (PlutoGridOnLoadedEvent event) {
        event.stateManager.setShowColumnFilter(true);
      },
      configuration: PlutoGridConfiguration(
        /// If columnFilterConfig is not set, the default setting is applied.
        ///
        /// Return the value returned by resolveDefaultColumnFilter through the resolver function.
        /// Prevents errors returning filters that are not in the filters list.
        columnFilterConfig: PlutoGridColumnFilterConfig(
          filters: const [
            ...FilterHelper.defaultFilters,
          ],
          resolveDefaultColumnFilter: (column, resolver) {
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
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
                  currentDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    reloadApplicationList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆预约'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              app.value = null;
              reloadApplicationList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () async {
              final applicationList = app.value;
              final path = (await getTemporaryDirectory()).path +
                  '/${selectedDate.value.month}月${selectedDate.value.day}日导出数据.csv';

              final file = File(path);
              String content = '申请ID,场次,学号,序号,状态\n';
              for (final e in applicationList!) {
                content +=
                    '${e.id},${periodToString(e.period % 10)},${e.user},${e.index},${e.status == 1 ? "已入馆" : "未入馆"}\n';
              }
              file.writeAsString(content);
              OpenFile.open(path, type: 'text/csv');
            },
          ),
        ],
      ),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/scanner');
          if (result != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrResultPage(result as String)));
          }
        },
      ),
    );
  }
}
