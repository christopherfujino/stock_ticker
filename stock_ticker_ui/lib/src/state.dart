import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) => InheritedState(
        parent: this,
        cash: Cash(cashValue,
            (int nextValue) => setState(() => cashValue = nextValue)),
        child: widget.child,
      );
}

enum StateAspect {
  cash,
}

class InheritedState extends InheritedModel<StateAspect> {
  const InheritedState({
    super.key,
    required super.child,
    required this.parent,
    required this.cash,
  });

  final WrapperState parent;

  //static InheritedState of(BuildContext context) =>
  //    context.dependOnInheritedWidgetOfExactType<InheritedState>()!;

  static Cash cashOf(BuildContext ctx) {
    return InheritedModel.inheritFrom<InheritedState>(
      ctx,
      aspect: StateAspect.cash,
    )!
        .cash;
  }

  final Cash cash;

  @override
  bool updateShouldNotify(InheritedState oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
      InheritedState oldWidget, Set<StateAspect> dependencies) {
    return dependencies.any((StateAspect aspect) => switch (aspect) {
          StateAspect.cash => oldWidget.cash.value != cash.value,
        });
  }
}

class Cash {
  Cash(this.value, this.update);

  final int value;
  final void Function(int) update;
}
