import 'package:flutter/material.dart';
import 'package:data_engine/data_engine.dart';

import 'state.dart';

class AssetTableWidget extends StatefulWidget {
  const AssetTableWidget({super.key});

  @override
  State<AssetTableWidget> createState() => _AssetTableWidgetState();
}

class _AssetTableWidgetState extends State<AssetTableWidget> {
  @override
  Widget build(BuildContext context) {
    final assets = InheritedState.assetsOf(context);
    return _SortableAssetTable(assets: assets);
  }
}

class _SortableAssetTable extends StatefulWidget {
  const _SortableAssetTable({required this.assets});

  final Assets assets;

  @override
  _SortableAssetTableState createState() => _SortableAssetTableState();
}

class _SortableAssetTableState extends State<_SortableAssetTable> {
  int _sortColumnIndex = 0;
  bool _ascending = true;

  void _sort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0: // name
        setState(() {
          if (_sortColumnIndex == columnIndex) {
            _ascending = !_ascending;
          } else {
            _ascending = true;
            _sortColumnIndex = columnIndex;
          }
          final ascensionMultiplier = _ascending ? 1 : -1;
          assets.sort((Asset a, Asset b) {
            return ascensionMultiplier * (a.name.compareTo(b.name));
          });
        });
      case 1: // value
        setState(() {
          if (_sortColumnIndex == columnIndex) {
            _ascending = !_ascending;
          } else {
            _ascending = false; // Default to largest first
            _sortColumnIndex = columnIndex;
          }
          final ascensionMultiplier = _ascending ? 1 : -1;
          assets.sort((Asset a, Asset b) {
            return ascensionMultiplier * (a.valueCents - b.valueCents);
          });
        });
      case 2: // shares owned
        setState(() {
          if (_sortColumnIndex == columnIndex) {
            _ascending = !_ascending;
          } else {
            _ascending = false; // Default to largest first
            _sortColumnIndex = columnIndex;
          }
          // TODO sorting
        });
      default:
        throw UnimplementedError('huh?! $columnIndex');
    }
  }

  @override
  void initState() {
    super.initState();

    assets = widget.assets.value
        .take(widget.assets.value.length)
        .toList(growable: false);

    _sort(_sortColumnIndex, _ascending);
  }

  late final List<Asset> assets;

  @override
  Widget build(BuildContext context) {
    final portfolio = InheritedState.portfolioOf(context);
    return DataTable(
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _ascending,
      columns: <DataColumn>[
        DataColumn(label: const Text('Name'), onSort: _sort),
        DataColumn(label: const Text('Value'), onSort: _sort),
        DataColumn(label: const Text('Shares\nowned'), onSort: _sort),
        const DataColumn(label: Text('Transaction')),
      ],
      rows: assets.map<DataRow>((Asset asset) {
        return DataRow(cells: <DataCell>[
          DataCell(Text(asset.name)),
          DataCell(Text('\$${asset.value}')),
          DataCell(Text('${portfolio.value[asset] ?? 'nada'}')),
          DataCell(_TransactionForm(asset)),
        ]);
      }).toList(),
    );
  }
}

// Does this even need to be stateful?!
class _TransactionForm extends StatefulWidget {
  const _TransactionForm(this.asset);

  final Asset asset;

  @override
  State<StatefulWidget> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<_TransactionForm> {
  int? currentValue;

  @override
  Widget build(BuildContext context) {
    final portfolio = InheritedState.portfolioOf(context);
    final cash = InheritedState.cashOf(context);
    return Form(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 60,
            child: DropdownButtonFormField<int>(
              items: const <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: 1, child: Text('1')),
                DropdownMenuItem<int>(value: 10, child: Text('10')),
                DropdownMenuItem<int>(value: 100, child: Text('100')),
              ],
              onChanged: (int? value) => currentValue = value,
            ),
          ),
          ButtonBar(
            children: <Widget>[
              TextButton(
                child: const Text('Buy'),
                onPressed: () {
                  assert(currentValue != null);

                  final previousValue = portfolio.value[widget.asset] ?? 0;
                  final costCents = currentValue! * widget.asset.valueCents;
                  assert(cash.valueCents >= costCents);
                  portfolio.value[widget.asset] = previousValue + currentValue!;
                  portfolio.update(portfolio.value);

                  // TODO am I mixing dollars and cents?!
                  cash.update(
                    cash.valueCents - costCents,
                  );
                },
              ),
              TextButton(
                child: const Text('Sell'),
                onPressed: () {
                  assert(currentValue != null);

                  final previousValue = portfolio.value[widget.asset] ?? 0;
                  assert(previousValue >= currentValue!);
                  portfolio.value[widget.asset] = previousValue - currentValue!;
                  portfolio.update(portfolio.value);

                  // TODO am I mixing dollars and cents?!
                  cash.update(
                    cash.valueCents - (currentValue! * widget.asset.valueCents),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
