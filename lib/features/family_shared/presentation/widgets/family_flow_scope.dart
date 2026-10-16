import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_view_model.dart';

class FamilyFlowScope extends StatefulWidget {
  const FamilyFlowScope({super.key, required this.child, this.targetMemberId});

  final Widget child;
  final String? targetMemberId;

  static String? targetMemberIdOf(BuildContext context) {
    try {
      final vmMemberId = context
          .select<FamilySubscriptionFlowViewModel, String?>(
            (vm) => vm.state.targetMemberId,
          );
      if (vmMemberId != null) return vmMemberId;
    } catch (_) {}
    return context
        .dependOnInheritedWidgetOfExactType<_FamilyFlowInherited>()
        ?.targetMemberId;
  }

  static void setTargetMember(BuildContext context, String? memberId) {
    try {
      context.read<FamilySubscriptionFlowViewModel>().setTargetMember(memberId);
    } catch (_) {}
  }

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
        .getInheritedWidgetOfExactType<_FamilyFlowInherited>()
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
  void initState() {
    super.initState();
    if (widget.targetMemberId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FamilyFlowScope.setTargetMember(context, widget.targetMemberId);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant FamilyFlowScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetMemberId != oldWidget.targetMemberId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FamilyFlowScope.setTargetMember(context, widget.targetMemberId);
        }
      });
    }
  }

  @override
  void dispose() {
    _familyName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FamilyFlowInherited(
      familyName: _familyName,
      targetMemberId: widget.targetMemberId,
      child: widget.child,
    );
  }
}

class _FamilyFlowInherited extends InheritedWidget {
  const _FamilyFlowInherited({
    required this.familyName,
    required this.targetMemberId,
    required super.child,
  });

  final ValueNotifier<String?> familyName;
  final String? targetMemberId;

  @override
  bool updateShouldNotify(_FamilyFlowInherited oldWidget) =>
      familyName != oldWidget.familyName ||
      targetMemberId != oldWidget.targetMemberId;
}
