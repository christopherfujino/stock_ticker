import 'package:flutter/material.dart';

import 'package:data_engine/data_engine.dart';

class StateWrapper extends StatefulWidget {
  const StateWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<StateWrapper> createState() => _WrapperState();
}

class _WrapperState extends State<StateWrapper> {
  _WrapperState();

  int cashValue = 0;
  List<Asset> assets = Asset.defaults;
  var portfolio = <Asset, int>{};

  @override
  Widget build(BuildContext context) => InheritedState._(
        assets: Assets(
          assets,
          (List<Asset> nextAssets) => setState(() => assets = nextAssets),
        ),
        cash: Cash(
          cashValue,
          (int nextValue) => setState(() => cashValue = nextValue),
        ),
        portfolio: Portfolio(
            portfolio,
            (Map<Asset, int> nextPortfolio) =>
                setState(() => portfolio = nextPortfolio)),
        child: widget.child,
      );
}

enum StateAspect {
  cash,
  assets,
  portfolio,
}

class InheritedState extends InheritedModel<StateAspect> {
  const InheritedState._({
    //super.key,
    required super.child,
    required this.cash,
    required this.assets,
    required this.portfolio,
  });

  static Cash cashOf(BuildContext ctx) {
    return InheritedModel.inheritFrom<InheritedState>(
      ctx,
      aspect: StateAspect.cash,
    )!
        .cash;
  }

  static Assets assetsOf(BuildContext ctx) {
    return InheritedModel.inheritFrom<InheritedState>(
      ctx,
      aspect: StateAspect.assets,
    )!
        .assets;
  }

  static Portfolio portfolioOf(BuildContext ctx) {
    return InheritedModel.inheritFrom<InheritedState>(
      ctx,
      aspect: StateAspect.portfolio,
    )!
        .portfolio;
  }

  final Cash cash;
  final Assets assets;
  final Portfolio portfolio;

  @override
  bool updateShouldNotify(InheritedState oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    InheritedState oldWidget,
    Set<StateAspect> dependencies,
  ) =>
      dependencies.any(
        (StateAspect aspect) => switch (aspect) {
          StateAspect.cash => oldWidget.cash.value != cash.value,
          StateAspect.assets => oldWidget.assets != assets,
          StateAspect.portfolio => oldWidget.portfolio != portfolio,
        },
      );
}

class Assets {
  Assets(
    this.value,
    this.update,
  );

  final void Function(List<Asset>) update;

  final List<Asset> value;
}

class Cash {
  Cash(this.value, this.update);

  final int value;
  final void Function(int) update;

  @override
  int get hashCode => value;

  @override
  operator ==(Object other) {
    return other is Cash && other.hashCode == hashCode;
  }
}

class Portfolio {
  Portfolio(this.value, this.update);

  static int nextVersion = 0;

  final Map<Asset, int> value;
  final void Function(Map<Asset, int>) update;

  // TODO implement purchase to manage updating both assets owned and cash

  @override
  int get hashCode => Object.hashAllUnordered(
        value.entries.map<int>(
          (MapEntry<Asset, int> entry) =>
              // For the purposes of this map, the name is unique
              Object.hashAll(<Object>[entry.key.name, entry.value]),
        ),
      );

  @override
  operator ==(Object other) {
    return other is Portfolio && other.hashCode == hashCode;
  }
}
