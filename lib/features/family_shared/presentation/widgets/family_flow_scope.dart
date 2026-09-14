import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FamilyFlowScope extends StatefulWidget {
  const FamilyFlowScope({super.key, required this.child});

  final Widget child;

  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FamilyFlowInherited>() !=
      null;

  static ValueListenable<String?>? familyNameListenableOf(
    BuildContext context,
  ) => context
      .dependOnInheritedWidgetOfExactType<_FamilyFlowInherited>()
      ?.familyName;

  static void updateFamilyName(BuildContext context, String? name) {
    final notifier = context
        .dependOnInheritedWidgetOfExactType<_FamilyFlowInherited>()
        ?.familyName;
    final normalizedName = name?.trim();
    if (notifier == null ||
        normalizedName == null ||
        normalizedName.isEmpty ||
        notifier.value == normalizedName) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifier.value != normalizedName) notifier.value = normalizedName;
    });
  }

  @override
  State<FamilyFlowScope> createState() => _FamilyFlowScopeState();
}

class _FamilyFlowScopeState extends State<FamilyFlowScope> {
  final ValueNotifier<String?> _familyName = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _familyName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FamilyFlowInherited(familyName: _familyName, child: widget.child);
  }
}

class _FamilyFlowInherited extends InheritedWidget {
  const _FamilyFlowInherited({required this.familyName, required super.child});

  final ValueNotifier<String?> familyName;

  @override
  bool updateShouldNotify(_FamilyFlowInherited oldWidget) =>
      familyName != oldWidget.familyName;
}
