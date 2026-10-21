import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'family_calendar_member_presentation.dart';
import 'family_day_date_section.dart';
import 'family_day_member_card.dart';
import 'family_member_calendar_member_selector_section.dart';

class FamilyDayMealsHeaderSection extends StatelessWidget {
  const FamilyDayMealsHeaderSection({
    super.key,
    this.fallbackMemberId,
    this.fallbackSubscriptionId,
    required this.fallbackDate,
    required this.onMemberSelected,
    required this.onPreviousDay,
    required this.onNextDay,
  });
  final String? fallbackMemberId;
  final String? fallbackSubscriptionId;
  final DateTime fallbackDate;
  final ValueChanged<int> onMemberSelected;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FamilyMemberCalendarMemberSelectorSection(
          fallbackMemberId: fallbackMemberId,
          fallbackSubscriptionId: fallbackSubscriptionId,
          showLoading: false,
          onMemberSelected: onMemberSelected,
        ),
        FamilyDayDateSection(
          fallbackDate: fallbackDate,
          onPreviousDay: onPreviousDay,
          onNextDay: onNextDay,
        ),
        BlocSelector<
          FamilyCalendarViewModel,
          FamilyCalendarState,
          ({FamilyMemberSummaryEntity? member, String name})
        >(
          selector: (state) =>
              (member: state.currentMember, name: state.displayName),
          builder: (context, data) => FamilyDayMemberCard(
            member: presentFamilyCalendarMember(
              data.member,
              locale,
              displayName: data.name,
              memberId: fallbackMemberId,
              subscriptionId: fallbackSubscriptionId,
            ),
          ),
        ),
      ],
    );
  }
}
