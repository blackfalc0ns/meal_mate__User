import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyProgramActionsSection extends StatelessWidget {
  const FamilyProgramActionsSection({
    super.key,
    required this.state,
    required this.onSelectUnreadyMember,
  });

  final FamilyPlanState state;
  final ValueChanged<int> onSelectUnreadyMember;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyProgramActions(
          nextText: locale.family_next_package_days,
          nextIcon: Icons.arrow_forward_ios_rounded,
          onNextPressed: () {
            final unreadyIndex = state.members.indexWhere(
              (member) => member.programId == null || member.programId!.isEmpty,
            );
            if (unreadyIndex != -1) {
              onSelectUnreadyMember(unreadyIndex);
              return;
            }
            final firstProgramId =
                state.members.firstOrNull?.programId ??
                state.selectedProgram?.programId;
            context.pushNamed(
              AppRoutes.familyPackageDaysSetup,
              arguments: firstProgramId,
            );
          },
        ),
      ],
    );
  }
}
