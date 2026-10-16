import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_actions.dart';

class FamilyProgramActions extends StatelessWidget {
  const FamilyProgramActions({
    super.key,
    this.nextText,
    this.nextIcon,
    this.onNextPressed,
    this.isLoading = false,
    this.progress,
    this.progressLabel,
    this.showSecondary = false,
    this.secondaryText,
    this.onSecondaryPressed,
  });

  final String? nextText;
  final IconData? nextIcon;
  final VoidCallback? onNextPressed;
  final bool isLoading;
  final double? progress;
  final String? progressLabel;
  final bool showSecondary;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return FamilyFlowActions(
      showSecondary: showSecondary,
      secondaryText: secondaryText,
      onSecondaryPressed: onSecondaryPressed,
      primaryText: nextText,
      primaryIcon: nextIcon,
      onPrimaryPressed: onNextPressed,
      isPrimaryLoading: isLoading,
      progress: progress,
      progressLabel: progressLabel,
    );
  }
}
