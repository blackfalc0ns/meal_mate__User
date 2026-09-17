import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyProgramActionsSection extends StatelessWidget {
  const FamilyProgramActionsSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyProgramActions(
          nextText: locale.family_allergies_next_location,
          nextIcon: Icons.arrow_forward_ios_rounded,
          onNextPressed: state.selectedMember?.hasProgram != true
              ? null
              : () {
                  context.read<FamilyProgramsViewModel>().doIntent(
                    const SaveFamilyProgramsEvent(),
                  );
                },
        ),
      ],
    );
  }
}
