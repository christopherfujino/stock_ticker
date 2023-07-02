import 'package:flutter/material.dart';

import 'src/state.dart';
import 'src/stock_view.dart';

void main() {
  runApp(
    const StateWrapper(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stock Ticker'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final cash = InheritedState.cashOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cash \$${cash.value}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const AssetTableWidget(),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () => cash.update(cash.value + 1),
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
      ),
    );
  }
}
