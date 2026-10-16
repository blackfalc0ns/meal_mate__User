import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_actions.dart';

class FamilyProgramActions extends StatelessWidget {
  const FamilyProgramActions({
    super.key,
    this.nextText,
    this.nextIcon,
    this.onNextPressed,
  });

  final String? nextText;
  final IconData? nextIcon;
  final VoidCallback? onNextPressed;

  @override
  Widget build(BuildContext context) {
    return FamilyFlowActions(
      primaryText: nextText,
      primaryIcon: nextIcon,
      onPrimaryPressed: onNextPressed,
    );
  }
}

