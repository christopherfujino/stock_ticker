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
    return DataTable(
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _ascending,
      columns: <DataColumn>[
        DataColumn(label: const Text('Name'), onSort: _sort),
        DataColumn(label: const Text('Value'), onSort: _sort),
      ],
      rows: assets.map<DataRow>((Asset asset) {
        return DataRow(cells: <DataCell>[
          DataCell(Text(asset.name)),
          DataCell(Text('\$${asset.value}')),
        ]);
      }).toList(),
    );
  }
}
