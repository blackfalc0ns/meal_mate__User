import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_actions.dart';

class FamilySetupActionsSection extends StatelessWidget {
  const FamilySetupActionsSection({
    super.key,
    required this.isEditing,
    this.hasMemberInput = false,
    this.isLimitReached = false,
    this.canProceed = true,
    required this.isMemberSaving,
    required this.onAddOrUpdateMember,
    required this.onNext,
  });

  final bool isEditing;
  final bool hasMemberInput;
  final bool isLimitReached;
  final bool canProceed;
  final bool isMemberSaving;
  final VoidCallback onAddOrUpdateMember;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final isSecondaryEnabled = isEditing || !isLimitReached;

    final secondaryText = isEditing
        ? locale.profile_personal_info_save
        : (hasMemberInput
            ? locale.family_confirm_member_button
            : locale.family_add_member_button);

    final secondaryIcon = (isEditing || hasMemberInput)
        ? Icons.check_rounded
        : Icons.add_rounded;

    return FamilyFlowActions(
      showSecondary: true,
      secondaryText: secondaryText,
      secondaryIcon: secondaryIcon,
      onSecondaryPressed: isSecondaryEnabled ? onAddOrUpdateMember : null,
      isSecondaryLoading: isMemberSaving,
      primaryText: locale.family_next_program,
      primaryIcon: Icons.chevron_right_rounded,
      onPrimaryPressed: canProceed ? onNext : null,
    );
  }
}
