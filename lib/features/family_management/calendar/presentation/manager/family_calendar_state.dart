import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyCalendarState {
  const FamilyCalendarState({
    this.members = const [],
    this.selectedMemberIndex = 0,
    this.currentSubscriptionId,
    this.currentMemberName,
    this.visibleMonth,
    this.selectedDate,
    this.selectedDay,
    this.days = const [],
    this.isLoadingMembers = false,
    this.isLoadingCalendar = false,
    this.isLoadingDay = false,
    this.calendarFailure,
    this.dayFailure,
    this.currentUserCapabilities = const [],
  });

  final List<FamilyMemberSummaryEntity> members;
  final int selectedMemberIndex;
  final String? currentSubscriptionId;
  final String? currentMemberName;
  final DateTime? visibleMonth;
  final DateTime? selectedDate;
  final CalendarDayEntity? selectedDay;
  final List<CalendarDayEntity> days;
  final bool isLoadingMembers;
  final bool isLoadingCalendar;
  final bool isLoadingDay;
  final Failure? calendarFailure;
  final Failure? dayFailure;
  final List<FamilyCapabilityEntity> currentUserCapabilities;

  bool get hasCalendarData => days.isNotEmpty;

  FamilyMemberSummaryEntity? get currentMember {
    if (selectedMemberIndex >= 0 && selectedMemberIndex < members.length) {
      return members[selectedMemberIndex];
    }
    return null;
  }

  String get displayName =>
      currentMember?.displayName ?? currentMemberName ?? '';

  String? get activeSubscriptionId {
    final subscription =
        currentMember?.effectiveSubscriptionId ?? currentSubscriptionId;
    return subscription?.isNotEmpty == true ? subscription : null;
  }

  bool canPerformAction(String action) {
    final capability = currentUserCapabilities
        .where((item) => item.action.toLowerCase() == action.toLowerCase())
        .firstOrNull;
    return capability?.allowed ?? false;
  }

  bool get canSelectRestaurant =>
      canPerformAction('selectRestaurant') ||
      canPerformAction('editDailyMeals');
  bool get canEditMealsAndDays =>
      canPerformAction('editMealsAndDays') ||
      canPerformAction('editDailyMeals');
  bool get canUnitExchange =>
      canPerformAction('unitExchange') || canPerformAction('editDailyMeals');
  bool get canConfirmMeals =>
      canPerformAction('confirmMeals') || canPerformAction('editDailyMeals');
  bool get canViewCalendar =>
      canPerformAction('viewCalendar') ||
      canPerformAction('viewFamilyCalendars');

  FamilyCalendarState copyWith({
    List<FamilyMemberSummaryEntity>? members,
    int? selectedMemberIndex,
    String? currentSubscriptionId,
    String? currentMemberName,
    DateTime? visibleMonth,
    DateTime? selectedDate,
    CalendarDayEntity? selectedDay,
    List<CalendarDayEntity>? days,
    bool? isLoadingMembers,
    bool? isLoadingCalendar,
    bool? isLoadingDay,
    Failure? calendarFailure,
    Failure? dayFailure,
    List<FamilyCapabilityEntity>? currentUserCapabilities,
    bool clearCalendarFailure = false,
    bool clearDayFailure = false,
    bool clearSelectedDay = false,
  }) => FamilyCalendarState(
    members: members ?? this.members,
    selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
    currentSubscriptionId: currentSubscriptionId ?? this.currentSubscriptionId,
    currentMemberName: currentMemberName ?? this.currentMemberName,
    visibleMonth: visibleMonth ?? this.visibleMonth,
    selectedDate: selectedDate ?? this.selectedDate,
    selectedDay: clearSelectedDay ? null : selectedDay ?? this.selectedDay,
    days: days ?? this.days,
    isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
    isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
    isLoadingDay: isLoadingDay ?? this.isLoadingDay,
    calendarFailure: clearCalendarFailure
        ? null
        : calendarFailure ?? this.calendarFailure,
    dayFailure: clearDayFailure ? null : dayFailure ?? this.dayFailure,
    currentUserCapabilities:
        currentUserCapabilities ?? this.currentUserCapabilities,
  );
}
