import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_summary_card.dart';

class FamilyPackageDaysMemberSection extends StatelessWidget {
  const FamilyPackageDaysMemberSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    final members = state.members;
    final selectedMember = state.selectedMember;

    final displayedMembers = members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final isSelected = index == state.selectedMemberIndex;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: '',
        status: member.isReady
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !member.isReady,
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
              context.read<FamilyPackageDaysViewModel>().doIntent(
                SelectFamilyMemberPackageDaysEvent(index),
              );
            },
          ),
          const SizedBox(height: Spacing.familyProgramSummaryTopGap),
        ],
        if (activeMemberDetails != null) ...[
          FamilyProgramSummaryCard(member: activeMemberDetails),
          const SizedBox(height: Spacing.familyPackageTitleTopGap),
        ],
      ],
    );
  }
}
