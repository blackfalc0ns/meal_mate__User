import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_capabilities_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';

@injectable
class FamilyCalendarViewModel extends Cubit<FamilyCalendarState> {
  FamilyCalendarViewModel(
    this._getMembersUseCase,
    this._getCalendarUseCase,
    this._getCalendarDayUseCase,
    this._getCapabilitiesUseCase,
  ) : super(const FamilyCalendarState());

  final GetFamilyMembersUseCase _getMembersUseCase;
  final GetCalendarUseCase _getCalendarUseCase;
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  final GetFamilyMemberCapabilitiesUseCase _getCapabilitiesUseCase;

  int _memberRequestToken = 0;
  int _calendarRequestToken = 0;
  int _dayRequestToken = 0;
  int _capabilitiesRequestToken = 0;
  String? _requestedMemberId;
  String? _requestedSubscriptionId;

  void applyDaySnapshot(CalendarDayEntity day) {
    doIntent(ApplyFamilyCalendarDaySnapshotEvent(day));
  }

  void _applyDaySnapshot(CalendarDayEntity day) {
    final date = day.date ?? state.selectedDate;
    if (date == null) return;

    final dayWithSelection = day.copyWith(isSelected: true);
    final updatedDays = state.days.map((existing) {
      final isSelected =
          existing.date != null &&
          existing.date!.year == date.year &&
          existing.date!.month == date.month &&
          existing.date!.day == date.day;
      if (isSelected) {
        return dayWithSelection;
      }
      return existing.copyWith(isSelected: false);
    }).toList();

    emit(
      state.copyWith(
        selectedDate: date,
        selectedDay: dayWithSelection,
        days: updatedDays,
        clearDayFailure: true,
      ),
    );
  }

  Future<void> doIntent(FamilyCalendarEvent event) async {
    switch (event) {
      case InitFamilyCalendarEvent():
        await _init(event);
      case SelectFamilyMemberEvent():
        await _selectMember(event.index, event.localeName);
      case SelectFamilyCalendarDayEvent():
        await _selectDay(event.day, event.localeName);
      case ChangeFamilyCalendarMonthEvent():
        _changeMonth(event.months);
      case RetryFamilyCalendarEvent():
        await _retry(event.localeName);
      case RetryFamilyCalendarDayEvent():
        await _retryDayDetails(event.localeName);
      case RetryFamilyCapabilitiesEvent():
        await _loadCapabilitiesForActiveMember();
      case ApplyFamilyCalendarDaySnapshotEvent():
        _applyDaySnapshot(event.day);
    }
  }

  Future<void> _init(InitFamilyCalendarEvent event) async {
    _requestedMemberId = event.args?.memberId;
    _requestedSubscriptionId = event.args?.subscriptionId;

    final initialDate = event.initialDate ?? event.args?.date ?? DateTime.now();
    final visibleMonth = DateTime(initialDate.year, initialDate.month);

    List<FamilyMemberSummaryEntity> members = [];
    if (event.args?.members.isNotEmpty == true) {
      members = List.of(event.args!.members);
    }

    int selectedIndex = 0;
    if (members.isNotEmpty) {
      selectedIndex = _findMemberIndex(
        members,
        memberId: _requestedMemberId,
        subscriptionId: _requestedSubscriptionId,
      );
    }

    final selectedDayDate = state.selectedDay?.date;
    final isSameDate =
        selectedDayDate != null &&
        selectedDayDate.year == initialDate.year &&
        selectedDayDate.month == initialDate.month &&
        selectedDayDate.day == initialDate.day;

    emit(
      state.copyWith(
        members: members,
        selectedMemberIndex: selectedIndex,
        currentSubscriptionId: event.args?.subscriptionId,
        currentMemberName: event.args?.displayName,
        visibleMonth: visibleMonth,
        selectedDate: initialDate,
        clearSelectedDay: !isSameDate,
        isLoadingCalendar: false,
        isLoadingDay: false,
        memberCapabilities: const [],
        clearCapabilitiesFailure: true,
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    if (members.isEmpty) {
      final token = ++_memberRequestToken;
      emit(state.copyWith(isLoadingMembers: true));
      final membersResult = await _getMembersUseCase(locale: event.localeName);
      if (isClosed || token != _memberRequestToken) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
          members = data;
          if (members.isNotEmpty) {
            selectedIndex = _findMemberIndex(
              members,
              memberId: _requestedMemberId,
              subscriptionId: _requestedSubscriptionId,
            );
          }
          final selectedMember =
              members.isNotEmpty && selectedIndex < members.length
              ? members[selectedIndex]
              : null;
          emit(
            state.copyWith(
              members: members,
              selectedMemberIndex: selectedIndex,
              currentSubscriptionId:
                  selectedMember?.effectiveSubscriptionId ?? '',
              currentMemberName: selectedMember?.displayName,
              isLoadingMembers: false,
            ),
          );
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
          return;
      }
    }

    await _loadCalendarForActiveMember(event.localeName);
  }

  int _findMemberIndex(
    List<FamilyMemberSummaryEntity> members, {
    String? memberId,
    String? subscriptionId,
  }) {
    if (members.isEmpty) return 0;
    final foundIndex = members.indexWhere((m) {
      if (memberId != null && memberId.isNotEmpty && m.memberId == memberId) {
        return true;
      }
      if (subscriptionId != null &&
          subscriptionId.isNotEmpty &&
          m.subscriptionId == subscriptionId) {
        return true;
      }
      return false;
    });
    return foundIndex >= 0 ? foundIndex : 0;
  }

  Future<void> _selectMember(int index, String localeName) async {
    if (index < 0 || index >= state.members.length) return;
    if (index == state.selectedMemberIndex) return;

    _calendarRequestToken++;
    _dayRequestToken++;
    _capabilitiesRequestToken++;

    final selectedMember = state.members[index];
    emit(
      state.copyWith(
        selectedMemberIndex: index,
        // Use an empty value when the new member has no subscription so the
        // previous member's subscription cannot leak into subsequent calls.
        currentSubscriptionId: selectedMember.effectiveSubscriptionId ?? '',
        currentMemberName: selectedMember.displayName,
        days: const [],
        clearSelectedDay: true,
        memberCapabilities: const [],
        clearCapabilitiesFailure: true,
        isLoadingCalendar: false,
        isLoadingDay: false,
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    await _loadCalendarForActiveMember(localeName);
  }

  Future<void> _loadCalendarForActiveMember(String localeName) async {
    await _loadCapabilitiesForActiveMember();

    final subId = state.activeSubscriptionId;
    if (subId == null || subId.isEmpty) {
      return;
    }

    final token = ++_calendarRequestToken;
    emit(state.copyWith(isLoadingCalendar: true, clearCalendarFailure: true));

    final result = await _getCalendarUseCase(
      subscriptionId: subId,
      localeName: localeName,
    );

    if (isClosed || token != _calendarRequestToken) return;
    if (state.activeSubscriptionId != subId) return;

    switch (result) {
      case ApiSuccessResult():
        final targetDate = state.selectedDate ?? DateTime.now();
        CalendarDayEntity? matchedSelectedDay;

        final mappedDays = result.data.days.map((day) {
          final isSelected =
              day.date != null &&
              day.date!.year == targetDate.year &&
              day.date!.month == targetDate.month &&
              day.date!.day == targetDate.day;

          final updatedDay = day.copyWith(isSelected: isSelected);
          if (isSelected) {
            matchedSelectedDay = updatedDay;
          }
          return updatedDay;
        }).toList();

        emit(
          state.copyWith(
            days: mappedDays,
            selectedDay: matchedSelectedDay,
            clearSelectedDay: matchedSelectedDay == null,
            isLoadingCalendar: false,
          ),
        );

        await _fetchDayDetails(
          date: targetDate,
          subscriptionId: subId,
          localeName: localeName,
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingCalendar: false,
            calendarFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadCapabilitiesForActiveMember() async {
    final activeMember = state.currentMember;
    if (activeMember != null && activeMember.memberId.isNotEmpty) {
      final token = ++_capabilitiesRequestToken;
      emit(state.copyWith(clearCapabilitiesFailure: true));
      final capResult = await _getCapabilitiesUseCase(activeMember.memberId);
      if (isClosed || token != _capabilitiesRequestToken) return;
      if (state.currentMember?.memberId != activeMember.memberId) return;
      switch (capResult) {
        case ApiSuccessResult<List<FamilyCapabilityEntity>>():
          emit(state.copyWith(memberCapabilities: capResult.data));
        case ApiErrorResult<List<FamilyCapabilityEntity>>():
          emit(state.copyWith(capabilitiesFailure: capResult.failure));
      }
    }
  }

  Future<void> _selectDay(CalendarDayEntity day, String localeName) async {
    final newDate = day.date;
    if (newDate == null) return;

    final updatedDays = state.days.map((d) {
      final isSelected =
          d.date != null &&
          d.date!.year == newDate.year &&
          d.date!.month == newDate.month &&
          d.date!.day == newDate.day;
      return d.copyWith(isSelected: isSelected);
    }).toList();

    DateTime? newVisibleMonth = state.visibleMonth;
    if (newVisibleMonth != null &&
        (newVisibleMonth.year != newDate.year ||
            newVisibleMonth.month != newDate.month)) {
      newVisibleMonth = DateTime(newDate.year, newDate.month);
    }

    emit(
      state.copyWith(
        selectedDate: newDate,
        visibleMonth: newVisibleMonth,
        selectedDay: day.copyWith(isSelected: true),
        days: updatedDays,
      ),
    );

    final subId = state.activeSubscriptionId;
    if (subId != null && subId.isNotEmpty) {
      await _fetchDayDetails(
        date: newDate,
        subscriptionId: subId,
        localeName: localeName,
      );
    }
  }

  Future<void> _fetchDayDetails({
    required DateTime date,
    required String subscriptionId,
    required String localeName,
  }) async {
    final token = ++_dayRequestToken;
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(isLoadingDay: true, clearDayFailure: true));

    final result = await _getCalendarDayUseCase(
      subscriptionId: subscriptionId,
      date: formattedDate,
      localeName: localeName,
    );

    if (isClosed || token != _dayRequestToken) return;
    if (state.activeSubscriptionId != subscriptionId ||
        state.selectedDate?.year != date.year ||
        state.selectedDate?.month != date.month ||
        state.selectedDate?.day != date.day) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final dayWithSelection = result.data.copyWith(isSelected: true);
        final updatedDays = state.days.map((d) {
          if (d.date != null &&
              d.date!.year == date.year &&
              d.date!.month == date.month &&
              d.date!.day == date.day) {
            return dayWithSelection;
          }
          return d;
        }).toList();

        emit(
          state.copyWith(
            selectedDay: dayWithSelection,
            days: updatedDays,
            isLoadingDay: false,
          ),
        );

      case ApiErrorResult():
        emit(state.copyWith(isLoadingDay: false, dayFailure: result.failure));
    }
  }

  void _changeMonth(int months) {
    final currentMonth = state.visibleMonth ?? DateTime.now();
    emit(
      state.copyWith(
        visibleMonth: DateTime(currentMonth.year, currentMonth.month + months),
      ),
    );
  }

  Future<void> _retry(String localeName) async {
    if (state.members.isEmpty) {
      final token = ++_memberRequestToken;
      emit(state.copyWith(isLoadingMembers: true, clearCalendarFailure: true));
      final membersResult = await _getMembersUseCase(locale: localeName);
      if (isClosed || token != _memberRequestToken) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
          final selectedIndex = _findMemberIndex(
            data,
            memberId: _requestedMemberId,
            subscriptionId: _requestedSubscriptionId,
          );
          final selectedMember = data.isNotEmpty && selectedIndex < data.length
              ? data[selectedIndex]
              : null;
          emit(
            state.copyWith(
              members: data,
              selectedMemberIndex: selectedIndex,
              currentSubscriptionId:
                  selectedMember?.effectiveSubscriptionId ?? '',
              currentMemberName: selectedMember?.displayName,
              isLoadingMembers: false,
            ),
          );
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
          return;
      }
    }

    await _loadCalendarForActiveMember(localeName);
  }

  Future<void> _retryDayDetails(String localeName) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate;
    if (subId == null || subId.isEmpty || date == null) return;
    await _fetchDayDetails(
      date: date,
      subscriptionId: subId,
      localeName: localeName,
    );
  }
}
