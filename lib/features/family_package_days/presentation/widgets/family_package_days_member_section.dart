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
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyPackageDaysMemberSection extends StatelessWidget {
  const FamilyPackageDaysMemberSection({
    super.key,
    this.state,
    this.showSummary = true,
    this.isLoading = false,
  });

  final FamilyPackageDaysState? state;
  final bool showSummary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      return _buildContent(context, state!);
    }
    return BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
      buildWhen: (previous, current) =>
          previous.members != current.members ||
          previous.selectedMemberIndex != current.selectedMemberIndex ||
          previous.isPlanSaving != current.isPlanSaving ||
          previous.selectedBundleIndex != current.selectedBundleIndex ||
          previous.selectedDurationIndex != current.selectedDurationIndex ||
          previous.customDurationDays != current.customDurationDays ||
          previous.selectedTierIndex != current.selectedTierIndex,
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, FamilyPackageDaysState state) {
    final locale = context.localization;
    final members = state.members;
    final selectedMember = state.selectedMember;

    final displayedMembers = members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final isSelected = index == state.selectedMemberIndex;
      final isCompleted = state.isMemberPlanReady(member);
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: resolveFamilyMemberAvatar(member.gender, index),
        status: isCompleted
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !isCompleted,
      );
    }).toList();

    final activeMemberDetails = selectedMember != null
        ? FamilyProgramMemberDetailsUiModel(
            name: selectedMember.displayName,
            imageAsset: resolveFamilyMemberAvatar(
              selectedMember.gender,
              state.selectedMemberIndex,
            ),
            age: '${selectedMember.ageYears} ${locale.family_year}',
            gender: selectedMember.gender == 2
                ? locale.family_gender_female
                : locale.family_gender_male,
            roleLabel: selectedMember.isManager ? locale.family_owner : '',
          )
        : (members.isNotEmpty
              ? FamilyProgramMemberDetailsUiModel(
                  name: members.first.displayName,
                  imageAsset: resolveFamilyMemberAvatar(
                    members.first.gender,
                    0,
                  ),
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
            onSelectMember: isLoading
                ? null
                : (index) {
                    context.read<FamilyPackageDaysViewModel>().doIntent(
                      SelectFamilyMemberPackageDaysEvent(index),
                    );
                    if (index >= 0 && index < members.length) {
                      FamilyFlowScope.setTargetMember(
                        context,
                        members[index].memberId,
                      );
                    }
                  },
          ),
          const SizedBox(height: Spacing.sm),
        ],
        if (showSummary && activeMemberDetails != null) ...[
          FamilyProgramSummaryCard(member: activeMemberDetails),
        ],
      ],
    );
  }
}
