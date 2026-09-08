import 'package:flutter/widgets.dart';

class FamilyFlowScope extends InheritedWidget {
  const FamilyFlowScope({super.key, required super.child});

  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FamilyFlowScope>() != null;

  @override
  bool updateShouldNotify(FamilyFlowScope oldWidget) => false;
}
