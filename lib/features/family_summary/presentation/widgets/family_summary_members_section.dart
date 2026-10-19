import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilySummaryMembersSection extends StatelessWidget {
  const FamilySummaryMembersSection({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyCheckoutViewModel, FamilyCheckoutState>(
      buildWhen: (prev, curr) =>
          prev.summary?.members != curr.summary?.members ||
          prev.members != curr.members ||
          prev.activeMemberId != curr.activeMemberId ||
          prev.selectedSummaryMemberId != curr.selectedSummaryMemberId ||
          prev.isSummaryLoading != curr.isSummaryLoading,
      builder: (context, state) {
        final locale = context.localization;

        final summary = state.summary;
        final activeMemberId =
            state.selectedSummaryMemberId ??
            summary?.selectedMemberId ??
            summary?.selectedMember?.memberId;
        final summaryMembers = summary?.members ?? const [];
        final fallbackMembers = state.members;
        final displayedMembers = summaryMembers.isNotEmpty
            ? _summaryMemberUiModels(
                summaryMembers,
                fallbackMembers,
                activeMemberId,
                locale,
              )
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
      },
    );
  }

  List<FamilyProgramMemberUiModel> _summaryMemberUiModels(
    List<FamilySummaryMemberEntity> members,
    List<FamilyMemberEntity> fallbackMembers,
    String? activeMemberId,
    dynamic locale,
  ) {
    final fallbackMap = {for (final m in fallbackMembers) m.memberId: m};
    return members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final matchingFlowMember = fallbackMap[member.memberId];
      final isManager =
          member.isManager ||
          matchingFlowMember?.isManager == true ||
          (fallbackMembers.firstOrNull?.memberId == member.memberId) ||
          index == 0;
      final isSelected = activeMemberId != null
          ? member.memberId == activeMemberId
          : isManager;
      final isSubscribed = matchingFlowMember?.subscribeNow ?? false;
      final isReady = member.isReady || member.setupStatus == 2;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: resolveFamilyMemberAvatar(
          matchingFlowMember?.gender ?? 1,
          index,
        ),
        status: !isSubscribed
            ? locale.family_member_unsubscribed_status
            : member.setupStatus == 0
            ? locale.family_member_no_plan_selected
            : isReady
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !isReady && isSubscribed,
        isExcluded: !isSubscribed,
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
      final isSubscribed = member.subscribeNow;
      final isReady = member.isReady;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: resolveFamilyMemberAvatar(member.gender, index),
        status: !isSubscribed
            ? locale.family_member_unsubscribed_status
            : member.setupStatus == 0
            ? locale.family_member_no_plan_selected
            : isReady
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !isReady && isSubscribed,
        isExcluded: !isSubscribed,
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

typedef FamilyPaymentMembersSection = FamilySummaryMembersSection;
