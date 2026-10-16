import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyProgramActionsSection extends StatelessWidget {
  const FamilyProgramActionsSection({super.key, required this.state});

  final FamilyProgramsState state;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    final members = state.members;
    final totalCount = members.length;
    final completedCount = members
        .where((m) => m.programId != null && m.programId!.isNotEmpty)
        .length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final allCompleted = totalCount > 0 && completedCount == totalCount;

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyProgramActions(
          nextText: locale.family_allergies_next_location,
          nextIcon: Icons.arrow_forward_ios_rounded,
          isLoading: state.isPlanSaving,
          progress: progress,
          progressLabel: totalCount > 1 && !allCompleted
              ? '($completedCount/$totalCount)'
              : null,
          onNextPressed: state.isPlanSaving || !allCompleted
              ? null
              : () {
                  context.read<FamilyProgramsViewModel>().doIntent(
                    const SaveFamilyProgramsEvent(),
                  );
                },
        ),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}
