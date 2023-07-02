import 'package:flutter/material.dart';
import 'package:data_engine/data_engine.dart';

import 'state.dart';

class AssetTableWidget extends StatelessWidget {
  const AssetTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final stocks = InheritedState.assetsOf(context);
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Value')),
      ],
      rows: stocks.value.map<DataRow>((Asset asset) {
        return DataRow(cells: <DataCell>[
          DataCell(Text(asset.name)),
          DataCell(Text('\$${asset.value}')),
        ]);
      }).toList(),
      //rows: const <DataRow>[
      //  DataRow(
      //    cells: <DataCell>[
      //      DataCell(
      //        Text('Alphabet'),
      //      ),
      //      DataCell(
      //        Text('\$12'),
      //      ),
      //    ],
      //  ),
      //],
    );
  }
}
