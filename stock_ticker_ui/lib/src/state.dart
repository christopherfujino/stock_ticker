import 'package:flutter/material.dart';

import 'package:data_engine/data_engine.dart';

class StateWrapper extends StatefulWidget {
  const StateWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<StateWrapper> createState() => WrapperState();
}

class WrapperState extends State<StateWrapper> {
  WrapperState();

  int cashValue = 0;
  List<Asset> assets = Asset.defaults;

  @override
  Widget build(BuildContext context) => InheritedState(
        parent: this,
        cash: Cash(
          cashValue,
          (int nextValue) => setState(() => cashValue = nextValue),
        ),
        assets: Assets(
          assets,
          (List<Asset> nextAssets) => setState(() => assets = nextAssets),
        ),
        child: widget.child,
      );
}

enum StateAspect {
  cash,
  assets,
}

class InheritedState extends InheritedModel<StateAspect> {
  const InheritedState({
    super.key,
    required super.child,
    required this.parent,
    required this.cash,
    required this.assets,
  });

  final WrapperState parent;

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

  final Cash cash;
  final Assets assets;

  @override
  bool updateShouldNotify(InheritedState oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    InheritedState oldWidget,
    Set<StateAspect> dependencies,
  ) =>
      dependencies.any((StateAspect aspect) => switch (aspect) {
            StateAspect.cash => oldWidget.cash.value != cash.value,
            StateAspect.assets => oldWidget.assets.version != assets.version,
          });
}

class Assets {
  Assets(
    this.value,
    this.update,
  ) : version = nextVersion++;

  // TODO make a factory
  static int nextVersion = 0;

  final void Function(List<Asset>) update;

  final int version;

  final List<Asset> value;
}

class Cash {
  Cash(this.value, this.update);

  final int value;
  final void Function(int) update;
}
