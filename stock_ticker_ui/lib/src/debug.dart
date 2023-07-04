import 'package:flutter/material.dart';
//import 'package:data_engine/data_engine.dart';

import 'state.dart';

class DebugView extends StatelessWidget {
  const DebugView({super.key});

  @override
  Widget build(BuildContext context) {
    final cash = InheritedState.cashOf(context);
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: const Text('Spawn Stock'),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                cash.update(cash.valueCents + 100 * 10000);
              },
              child: const Text(r'Make it rain ($10k)'),
            ),
          ],
        ),
      ],
    );
  }
}
