import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyMemberCalendarMemberSelectorSection extends StatelessWidget {
  const FamilyMemberCalendarMemberSelectorSection({
    super.key,
    required this.members,
    required this.selectedIndex,
    this.fallbackDisplayName,
    this.fallbackMemberId,
    this.fallbackSubscriptionId,
    required this.isLoading,
    required this.onMemberSelected,
  });

  final List<FamilyMemberSummaryEntity> members;
  final int selectedIndex;
  final String? fallbackDisplayName;
  final String? fallbackMemberId;
  final String? fallbackSubscriptionId;
  final bool isLoading;
  final ValueChanged<int> onMemberSelected;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const FamilyMemberCalendarLoadingSkeleton(
        includeMemberSelector: true,
      );
    }

    final locale = context.localization;
    List<FamilyDayMemberEntity> selectorMembers = [];

    if (members.isNotEmpty) {
      selectorMembers = members.map((m) {
        return FamilyDayMemberEntity(
          name: m.displayName,
          ageLabel: m.ageYears == null
              ? ''
              : locale.family_member_age_years(m.ageYears!),
          statusLabel: m.isPaused
              ? locale.family_member_paused_label
              : locale.family_member_active_label,
          imageAsset: Assets.profileAvatar,
          memberId: m.memberId,
          subscriptionId: m.effectiveSubscriptionId,
        );
      }).toList();
    } else if (fallbackDisplayName != null && fallbackDisplayName!.isNotEmpty) {
      selectorMembers = [
        FamilyDayMemberEntity(
          name: fallbackDisplayName!,
          ageLabel: '',
          statusLabel: locale.family_member_active_label,
          imageAsset: Assets.profileAvatar,
          memberId: fallbackMemberId,
          subscriptionId: fallbackSubscriptionId,
        ),
      ];
    }

    if (selectorMembers.isEmpty) {
      return const SizedBox.shrink();
    }

    final safeSelectedMemberIndex = selectedIndex
        .clamp(0, selectorMembers.length - 1)
        .toInt();

    return FamilyDayMemberSelector(
      members: selectorMembers,
      selectedIndex: safeSelectedMemberIndex,
      onMemberSelected: onMemberSelected,
    );
  }
}
