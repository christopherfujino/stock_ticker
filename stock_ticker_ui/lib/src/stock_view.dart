import 'package:flutter/material.dart';

class StockTableWidget extends StatelessWidget {
  const StockTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Value')),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text('Alphabet'),
            ),
            DataCell(
              Text('\$12'),
            ),
          ],
        ),
      ],
    );
  }
}
