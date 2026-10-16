import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_actions.dart';

class FamilySetupActions extends StatelessWidget {
  const FamilySetupActions({
    super.key,
    required this.onAddMember,
    required this.onNext,
    this.isSavingMember = false,
  });

  final VoidCallback onAddMember;
  final VoidCallback onNext;
  final bool isSavingMember;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return FamilyFlowActions(
      secondaryText: locale.family_add_member_button,
      secondaryIcon: Icons.add_rounded,
      onSecondaryPressed: onAddMember,
      isSecondaryLoading: isSavingMember,
      primaryText: locale.family_next_program,
      primaryIcon: Icons.chevron_left_rounded,
      onPrimaryPressed: onNext,
    );
  }
}
