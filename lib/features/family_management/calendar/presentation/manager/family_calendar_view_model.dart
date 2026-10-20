import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_capabilities_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';

@injectable
class FamilyCalendarViewModel extends Cubit<FamilyCalendarState> {
  FamilyCalendarViewModel(
    GetFamilyMembersUseCase getMembersUseCase,
    GetCalendarUseCase getCalendarUseCase,
    GetCalendarDayUseCase getCalendarDayUseCase,
    GetFamilyMemberCapabilitiesUseCase getCapabilitiesUseCase, {
    FamilyContextViewModel? familyContextViewModel,
  }) : this._(
         getMembersUseCase,
         getCalendarUseCase,
         getCalendarDayUseCase,
         getCapabilitiesUseCase,
         familyContextViewModel,
       );

  @visibleForTesting
  FamilyCalendarViewModel.test([
    GetFamilyMembersUseCase? getMembersUseCase,
    GetCalendarUseCase? getCalendarUseCase,
    GetCalendarDayUseCase? getCalendarDayUseCase,
    GetFamilyMemberCapabilitiesUseCase? getCapabilitiesUseCase,
  ]) : this._(
         getMembersUseCase,
         getCalendarUseCase,
         getCalendarDayUseCase,
         getCapabilitiesUseCase,
         null,
       );

  FamilyCalendarViewModel._(
    this._getMembersUseCase,
    this._getCalendarUseCase,
    this._getCalendarDayUseCase,
    this._getCapabilitiesUseCase,
    FamilyContextViewModel? familyContextViewModel,
  ) : super(
        FamilyCalendarState(
          fallbackCapabilities:
              familyContextViewModel?.state.primaryContext?.capabilities ??
              const [],
        ),
      ) {
    _contextSubscription = familyContextViewModel?.stream.listen((
      contextState,
    ) {
      if (!isClosed) {
        emit(
          state.copyWith(
            fallbackCapabilities:
                contextState.primaryContext?.capabilities ?? const [],
          ),
        );
      }
    });
  }

  final GetFamilyMembersUseCase? _getMembersUseCase;
  final GetCalendarUseCase? _getCalendarUseCase;
  final GetCalendarDayUseCase? _getCalendarDayUseCase;
  final GetFamilyMemberCapabilitiesUseCase? _getCapabilitiesUseCase;
  StreamSubscription<dynamic>? _contextSubscription;

  @override
  Future<void> close() async {
    await _contextSubscription?.cancel();
    return super.close();
  }

  void applyDaySnapshot(CalendarDayEntity day) {
    final date = day.date;
    final updatedDays = state.days.map((existing) {
      if (date != null &&
          existing.date != null &&
          existing.date!.year == date.year &&
          existing.date!.month == date.month &&
          existing.date!.day == date.day) {
        return day;
      }
      return existing;
    }).toList();
    emit(state.copyWith(selectedDay: day, days: updatedDays));
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
      case RetryFamilyCapabilitiesEvent():
        await _loadCapabilitiesForActiveMember();
    }
  }

  Future<void> _init(InitFamilyCalendarEvent event) async {
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
        memberId: event.args?.memberId,
        subscriptionId: event.args?.subscriptionId,
      );
    }

    emit(
      state.copyWith(
        members: members,
        selectedMemberIndex: selectedIndex,
        currentSubscriptionId: event.args?.subscriptionId,
        currentMemberName: event.args?.displayName,
        visibleMonth: visibleMonth,
        selectedDate: initialDate,
        memberCapabilities: const [],
        clearCapabilitiesFailure: true,
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    if (members.isEmpty) {
      if (_getMembersUseCase == null) return;
      emit(state.copyWith(isLoadingMembers: true));
      final membersResult = await _getMembersUseCase(locale: event.localeName);
      if (isClosed) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
          members = data;
          if (members.isNotEmpty) {
            selectedIndex = _findMemberIndex(
              members,
              memberId: event.args?.memberId,
              subscriptionId: event.args?.subscriptionId,
            );
          }
          emit(
            state.copyWith(
              members: members,
              selectedMemberIndex: selectedIndex,
              isLoadingMembers: false,
            ),
          );
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
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
    if (subId == null || subId.isEmpty || _getCalendarUseCase == null) {
      return;
    }

    emit(state.copyWith(isLoadingCalendar: true, clearCalendarFailure: true));

    final result = await _getCalendarUseCase(
      subscriptionId: subId,
      localeName: localeName,
    );

    if (isClosed) return;
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
            selectedDay: matchedSelectedDay ?? state.selectedDay,
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
    if (activeMember != null &&
        activeMember.memberId.isNotEmpty &&
        _getCapabilitiesUseCase != null) {
      emit(state.copyWith(clearCapabilitiesFailure: true));
      final capResult = await _getCapabilitiesUseCase(activeMember.memberId);
      if (isClosed) return;
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
    if (_getCalendarDayUseCase == null) return;
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(isLoadingDay: true, clearDayFailure: true));

    final result = await _getCalendarDayUseCase(
      subscriptionId: subscriptionId,
      date: formattedDate,
      localeName: localeName,
    );

    if (isClosed) return;
    if (state.activeSubscriptionId != subscriptionId ||
        state.selectedDate?.year != date.year ||
        state.selectedDate?.month != date.month ||
        state.selectedDate?.day != date.day)
      return;

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
      if (_getMembersUseCase == null) return;
      emit(state.copyWith(isLoadingMembers: true, clearCalendarFailure: true));
      final membersResult = await _getMembersUseCase(locale: localeName);
      if (isClosed) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
          emit(state.copyWith(members: data, isLoadingMembers: false));
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
          return;
      }
    }

    await _loadCalendarForActiveMember(localeName);
  }
}
