import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'family_calendar_member_presentation.dart';
import 'family_day_member_selector.dart';
import 'family_member_calendar_loading_skeleton.dart';

class FamilyMemberCalendarMemberSelectorSection extends StatefulWidget {
  const FamilyMemberCalendarMemberSelectorSection({
    super.key,
    this.fallbackMemberId,
    this.fallbackSubscriptionId,
    this.showLoading = true,
    required this.onMemberSelected,
  });
  final String? fallbackMemberId;
  final String? fallbackSubscriptionId;
  final bool showLoading;
  final ValueChanged<int> onMemberSelected;
  @override
  State<FamilyMemberCalendarMemberSelectorSection> createState() =>
      _FamilyMemberCalendarMemberSelectorSectionState();
}

class _FamilyMemberCalendarMemberSelectorSectionState
    extends State<FamilyMemberCalendarMemberSelectorSection> {
  List<FamilyMemberSummaryEntity>? _sourceMembers;
  String? _localeName;
  String? _fallbackName;
  String? _fallbackMemberId;
  String? _fallbackSubscriptionId;
  List<FamilyDayMemberEntity> _members = const [];

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        List<FamilyMemberSummaryEntity> members,
        int index,
        String fallbackName,
        bool loading,
      })
    >(
      selector: (state) => (
        members: state.members,
        index: state.selectedMemberIndex,
        fallbackName: state.members.isEmpty ? state.displayName : '',
        loading: widget.showLoading && state.isLoadingMembers,
      ),
      builder: (context, data) {
        if (data.loading) {
          return const FamilyMemberCalendarLoadingSkeleton(
            includeMemberSelector: true,
          );
        }
        if (!identical(_sourceMembers, data.members) ||
            _localeName != locale.localeName ||
            _fallbackName != data.fallbackName ||
            _fallbackMemberId != widget.fallbackMemberId ||
            _fallbackSubscriptionId != widget.fallbackSubscriptionId) {
          _sourceMembers = data.members;
          _localeName = locale.localeName;
          _fallbackName = data.fallbackName;
          _fallbackMemberId = widget.fallbackMemberId;
          _fallbackSubscriptionId = widget.fallbackSubscriptionId;
          _members = data.members.isNotEmpty
              ? data.members
                    .map(
                      (member) => presentFamilyCalendarMember(member, locale),
                    )
                    .toList()
              : data.fallbackName.isEmpty
              ? const []
              : [
                  presentFamilyCalendarMember(
                    null,
                    locale,
                    displayName: data.fallbackName,
                    memberId: widget.fallbackMemberId,
                    subscriptionId: widget.fallbackSubscriptionId,
                  ),
                ];
        }
        if (_members.isEmpty) return const SizedBox.shrink();
        return FamilyDayMemberSelector(
          members: _members,
          selectedIndex: data.index.clamp(0, _members.length - 1),
          onMemberSelected: widget.onMemberSelected,
        );
      },
    );
  }
}
