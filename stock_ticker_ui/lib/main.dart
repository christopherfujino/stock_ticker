import 'package:flutter/material.dart';

import 'src/debug.dart';
import 'src/state.dart';
import 'src/stock_view.dart';

void main() {
  runApp(
    const StateWrapper(
      child: Root(),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DefaultTabController(
        length: 2,
        child: MyHomePage(title: 'Stock Ticker'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        bottom: const TabBar(
          tabs: <Widget>[Text('Market'), Text('Debug')],
        ),
      ),
      body: const TabBarView(
        children: <Widget>[
          GameView(),
          DebugView(),
        ],
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final cash = InheritedState.cashOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const StatsView(),
          const AssetTableWidget(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => cash.update(cash.valueCents + 1),
                child: const Text('Beg'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('No-op'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cash = InheritedState.cashOf(context);
    final now = InheritedState.nowOf(context);
    return Table(
      children: <TableRow>[
        TableRow(children: <Widget>[
          const Text('Date', textAlign: TextAlign.right),
          Text(now.toString()),
        ]),
        TableRow(
          children: <Widget>[
            const Text('Cash', textAlign: TextAlign.right),
            Text(
              '\$${(cash.valueCents.toDouble() / 100.0).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
