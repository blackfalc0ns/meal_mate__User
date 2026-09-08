import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyPaymentMembersSection extends StatelessWidget {
  const FamilyPaymentMembersSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;

    final summary = state.summary;
    final activeMemberId =
        state.selectedSummaryMemberId ?? summary?.selectedMember?.memberId;
    final summaryMembers = summary?.members ?? const [];
    final fallbackMembers = state.members;
    final displayedMembers = summaryMembers.isNotEmpty
        ? _summaryMemberUiModels(summaryMembers, activeMemberId, locale)
        : _fallbackMemberUiModels(fallbackMembers, locale);

    if (displayedMembers.isEmpty) {
      return const SizedBox.shrink();
    }

    return FamilyProgramMemberStrip(
      members: displayedMembers,
      onSelectMember: state.isSummaryLoading
          ? null
          : (index) {
              final memberId = _memberIdAt(
                index: index,
                summaryMembers: summaryMembers,
                fallbackMembers: fallbackMembers,
              );
              if (memberId == null) return;
              context.read<FamilyCheckoutViewModel>().doIntent(
                GetFamilySummaryEvent(memberId: memberId),
              );
            },
    );
  }

  List<FamilyProgramMemberUiModel> _summaryMemberUiModels(
    List<FamilySummaryMemberEntity> members,
    String? activeMemberId,
    dynamic locale,
  ) {
    return members.map((member) {
      final isSelected = activeMemberId != null
          ? member.memberId == activeMemberId
          : member.isManager;
      final isReady = member.isReady || member.setupStatus == 3;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: '',
        status: isReady
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !isReady,
      );
    }).toList();
  }

  List<FamilyProgramMemberUiModel> _fallbackMemberUiModels(
    List<FamilyMemberEntity> members,
    dynamic locale,
  ) {
    return members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final isSelected = index == state.selectedMemberIndex;
      final isReady = member.setupStatus == 3;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: '',
        status: isReady
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !isReady,
      );
    }).toList();
  }

  String? _memberIdAt({
    required int index,
    required List<FamilySummaryMemberEntity> summaryMembers,
    required List<FamilyMemberEntity> fallbackMembers,
  }) {
    if (summaryMembers.isNotEmpty &&
        index >= 0 &&
        index < summaryMembers.length) {
      return summaryMembers[index].memberId;
    }
    if (fallbackMembers.isNotEmpty &&
        index >= 0 &&
        index < fallbackMembers.length) {
      return fallbackMembers[index].memberId;
    }
    return null;
  }
}
