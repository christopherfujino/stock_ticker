import 'dart:async';

import 'package:flutter/material.dart';

import 'package:data_engine/data_engine.dart';

class StateWrapper extends StatefulWidget {
  const StateWrapper({
    super.key,
    required this.child,
    this.timerDuration = const Duration(seconds: 2),
  });

  final Widget child;
  final Duration timerDuration;

  @override
  State<StateWrapper> createState() => _WrapperState();
}

class _WrapperState extends State<StateWrapper> {
  _WrapperState();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      widget.timerDuration,
      (Timer _) => setState(() {
        moment += const Month(1);
        for (final asset in assets) {
          asset.lapseOneMonth();
        }
      }),
    );
  }

  late final Timer _timer;

  int cashValue = 0;
  List<Asset> assets = Asset.defaults;
  var portfolio = <Asset, int>{};
  Moment moment = const Moment(year: Year(1980), month: Month.january);

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) => InheritedState._(
        assets: Assets._(
          assets,
          (List<Asset> nextAssets) => setState(() => assets = nextAssets),
        ),
        cash: Cash._(
          cashValue,
          (int nextValue) => setState(() => cashValue = nextValue),
        ),
        portfolio: Portfolio._(
            portfolio,
            (Map<Asset, int> nextPortfolio) =>
                setState(() => portfolio = nextPortfolio)),
        now: Now(
          moment,
          (Moment nextMoment) => setState(
            () => moment = nextMoment,
          ),
        ),
        child: widget.child,
      );
}

enum StateAspect {
  cash,
  assets,
  portfolio,
  now,
}

class InheritedState extends InheritedModel<StateAspect> {
  const InheritedState._({
    //super.key,
    required super.child,
    required this.cash,
    required this.assets,
    required this.portfolio,
    required this.now,
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

  static Now nowOf(BuildContext ctx) {
    return InheritedModel.inheritFrom<InheritedState>(
      ctx,
      aspect: StateAspect.now,
    )!
        .now;
  }

  final Cash cash;
  final Assets assets;
  final Portfolio portfolio;
  final Now now;

  @override
  bool updateShouldNotify(InheritedState oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    InheritedState oldWidget,
    Set<StateAspect> dependencies,
  ) =>
      dependencies.any(
        (StateAspect aspect) => switch (aspect) {
          StateAspect.cash => oldWidget.cash != cash,
          StateAspect.assets => oldWidget.assets != assets,
          StateAspect.portfolio => oldWidget.portfolio != portfolio,
          StateAspect.now => oldWidget.now != now,
        },
      );
}

class Assets {
  Assets._(
    this.value,
    this.update,
  );

  final void Function(List<Asset> nextAssets) update;

  final List<Asset> value;
}

class Cash {
  Cash._(this.valueCents, this.update);

  final int valueCents;
  final void Function(int) update;

  @override
  int get hashCode => valueCents;

  @override
  operator ==(Object other) {
    return other is Cash && other.hashCode == hashCode;
  }
}

class Portfolio {
  Portfolio._(this.value, this.update);

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

class Now {
  const Now(this.value, this.update);

  final Moment value;
  final void Function(Moment) update;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Now && other.hashCode == value.hashCode;

  @override
  String toString() => value.toString();
}
