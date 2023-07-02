import 'package:flutter/material.dart';
import 'package:data_engine/data_engine.dart';

import 'state.dart';

class AssetTableWidget extends StatefulWidget {
  const AssetTableWidget({super.key});

  @override
  State<AssetTableWidget> createState() => _AssetTableWidgetState();
}

class _AssetTableWidgetState extends State<AssetTableWidget> {
  int _sortColumnIndex = 0;

  static void _sort(int columnIndex, bool ascending) {
    throw 'sort!';
  }

  @override
  Widget build(BuildContext context) {
    final stocks = InheritedState.assetsOf(context);
    return DataTable(
      sortColumnIndex: _sortColumnIndex,
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Value'), onSort: _sort),
      ],
      rows: stocks.value.map<DataRow>((Asset asset) {
        return DataRow(cells: <DataCell>[
          DataCell(Text(asset.name)),
          DataCell(Text('\$${asset.value}')),
        ]);
      }).toList(),
    );
  }
}
