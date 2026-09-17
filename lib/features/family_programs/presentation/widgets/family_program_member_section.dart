import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyProgramMemberSection extends StatelessWidget {
  const FamilyProgramMemberSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    final targetMemberId = FamilyFlowScope.targetMemberIdOf(context);
    final memberEntries = state.members
        .asMap()
        .entries
        .where(
          (entry) =>
              targetMemberId == null || entry.value.memberId == targetMemberId,
        )
        .toList();
    final members = memberEntries.map((entry) => entry.value).toList();
    final selectedMember = state.selectedMember;

    final displayedMembers = members.asMap().entries.map((entry) {
      final index = memberEntries[entry.key].key;
      final member = entry.value;
      final isSelected = index == state.selectedMemberIndex;
      final hasProgram =
          member.programId != null && member.programId!.isNotEmpty;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: '',
        status: hasProgram
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !hasProgram,
      );
    }).toList();

    final activeMemberDetails = selectedMember != null
        ? FamilyProgramMemberDetailsUiModel(
            name: selectedMember.displayName,
            imageAsset: '',
            age: '${selectedMember.ageYears} ${locale.family_year}',
            gender: selectedMember.gender == 2
                ? locale.family_gender_female
                : locale.family_gender_male,
            roleLabel: selectedMember.isManager ? locale.family_owner : '',
          )
        : (members.isNotEmpty
              ? FamilyProgramMemberDetailsUiModel(
                  name: members.first.displayName,
                  imageAsset: '',
                  age: '${members.first.ageYears} ${locale.family_year}',
                  gender: members.first.gender == 2
                      ? locale.family_gender_female
                      : locale.family_gender_male,
                  roleLabel: members.first.isManager ? locale.family_owner : '',
                )
              : null);

    return Column(
      children: [
        if (displayedMembers.isNotEmpty) ...[
          FamilyProgramMemberStrip(
            members: displayedMembers,
            onSelectMember: (index) {
              context.read<FamilyProgramsViewModel>().doIntent(
                SelectFamilyMemberEvent(memberEntries[index].key),
              );
            },
          ),
          const SizedBox(height: Spacing.xs),
        ],
        if (activeMemberDetails != null) ...[
          FamilyProgramSummaryCard(member: activeMemberDetails),
          const SizedBox(height: Spacing.familyProgramTitleTopGap),
        ],
      ],
    );
  }
}
