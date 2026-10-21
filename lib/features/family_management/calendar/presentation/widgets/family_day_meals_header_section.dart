import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyDayMealsHeaderSection extends StatelessWidget {
  const FamilyDayMealsHeaderSection({
    super.key,
    required this.members,
    required this.selectedMemberIndex,
    required this.displayName,
    this.fallbackMemberId,
    this.fallbackSubscriptionId,
    required this.selectedDate,
    required this.onMemberSelected,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onDatePressed,
  });

  final List<FamilyMemberSummaryEntity> members;
  final int selectedMemberIndex;
  final String displayName;
  final String? fallbackMemberId;
  final String? fallbackSubscriptionId;
  final DateTime selectedDate;
  final ValueChanged<int> onMemberSelected;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onDatePressed;

  List<FamilyDayMemberEntity> _buildSelectorMembers(BuildContext context) {
    final locale = context.localization;

    if (members.isNotEmpty) {
      return members.map((m) {
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
    }

    if (displayName.isNotEmpty) {
      return [
        FamilyDayMemberEntity(
          name: displayName,
          ageLabel: '',
          statusLabel: locale.family_member_active_label,
          imageAsset: Assets.profileAvatar,
          memberId: fallbackMemberId,
          subscriptionId: fallbackSubscriptionId,
        ),
      ];
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final selectorMembers = _buildSelectorMembers(context);
    final safeSelectedMemberIndex = selectorMembers.isEmpty
        ? 0
        : selectedMemberIndex.clamp(0, selectorMembers.length - 1).toInt();
    final selectedMember = selectorMembers.isNotEmpty
        ? selectorMembers[safeSelectedMemberIndex]
        : FamilyDayMemberEntity(
            name: displayName,
            ageLabel: '',
            statusLabel: locale.family_member_active_label,
            imageAsset: Assets.profileAvatar,
          );

    final dateLabel = intl.DateFormat.yMMMMEEEEd(
      locale.localeName,
    ).format(selectedDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectorMembers.isNotEmpty)
          FamilyDayMemberSelector(
            members: selectorMembers,
            selectedIndex: safeSelectedMemberIndex,
            onMemberSelected: onMemberSelected,
          ),
        FamilyDayHeader(
          dateLabel: dateLabel,
          onPreviousDay: onPreviousDay,
          onNextDay: onNextDay,
          onDatePressed: onDatePressed,
        ),
        FamilyDayMemberCard(member: selectedMember),
      ],
    );
  }
}
