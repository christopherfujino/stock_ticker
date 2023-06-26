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

  int cash = 0;

  @override
  Widget build(BuildContext context) => InheritedState(
        parent: this,
        setParentState: setState,
        child: widget.child,
      );
}

class InheritedState extends InheritedWidget {
  const InheritedState({
    super.key,
    required super.child,
    required this.parent,
    required this.setParentState,
  });

  final WrapperState parent;
  final void Function(void Function()) setParentState;

  static InheritedState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedState>()!;

  int get cash => parent.cash;
  set cash(int newCash) => setParentState(() => parent.cash = newCash);

  @override
  bool updateShouldNotify(InheritedState oldWidget) => true;
}
