import 'support/family_calendar_view_model_factory.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';

class _FakeCalendarRepository implements CalendarRepository {
  String? lastCalendarSubscriptionId;
  String? lastDaySubscriptionId;
  String? lastDayDate;

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) async {
    lastCalendarSubscriptionId = subscriptionId;
    return ApiSuccessResult(
      data: CalendarSubscriptionEntity(
        subscriptionId: subscriptionId,
        days: [
          CalendarDayEntity(
            dayNumber: 20,
            weekday: 'الأحد',
            date: DateTime(2026, 9, 20),
            hasMeals: true,
          ),
          CalendarDayEntity(
            dayNumber: 21,
            weekday: 'الإثنين',
            date: DateTime(2026, 9, 21),
            hasMeals: true,
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    lastDaySubscriptionId = subscriptionId;
    lastDayDate = date;
    return ApiSuccessResult(
      data: CalendarDayEntity(
        dayNumber: int.parse(date.split('-').last),
        weekday: 'الأحد',
        date: DateTime.parse(date),
        meals: const [
          CalendarMealEntity(
            id: 'm-1',
            title: 'دجاج مشوي',
            slot: 'lunch',
            mealType: 'غداء',
            time: '1:00 PM',
            calories: '450',
            protein: '35g',
            carbs: '40g',
            fat: '15g',
            ingredients: [],
            imageAsset: '',
            actionLabel: '',
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFamilyRepository implements FamilyOverviewRepository {
  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilyMembers({
    String locale = 'ar',
  }) async {
    return const ApiSuccessResult(
      data: [
        FamilyMemberSummaryEntity(
          memberId: 'mem-1',
          displayName: 'أحمد',
          subscriptionId: 'sub-ahmed',
          role: 1,
          ageYears: 14,
          isPaused: false,
          programName: 'VIP',
          remainingDays: 10,
          setupStatus: 1,
        ),
        FamilyMemberSummaryEntity(
          memberId: 'mem-2',
          displayName: 'سارة',
          subscriptionId: 'sub-sarah',
          role: 1,
          ageYears: 8,
          isPaused: false,
          programName: 'Standard',
          remainingDays: 5,
          setupStatus: 1,
        ),
      ],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControllableCalendarRepository implements CalendarRepository {
  int getCalendarCallCount = 0;
  int getDayCallCount = 0;
  final List<Completer<ApiResult<CalendarSubscriptionEntity>>>
  getCalendarCompleters = [];
  final List<Completer<ApiResult<CalendarDayEntity>>> getDayCompleters = [];

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) {
    getCalendarCallCount++;
    final completer = Completer<ApiResult<CalendarSubscriptionEntity>>();
    getCalendarCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    getDayCallCount++;
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    getDayCompleters.add(completer);
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('initializes and loads calendar using member subscription id', () async {
    final calendarRepo = _FakeCalendarRepository();
    final familyRepo = _FakeFamilyRepository();

    final viewModel = createFamilyCalendarViewModel(
      members: GetFamilyMembersUseCase(familyRepo),
      calendar: GetCalendarUseCase(calendarRepo),
      day: GetCalendarDayUseCase(calendarRepo),
    );
    addTearDown(viewModel.close);

    final targetDate = DateTime(2026, 9, 20);
    viewModel.doIntent(
      InitFamilyCalendarEvent(
        args: FamilyMemberCalendarArgs(
          memberId: 'mem-2',
          displayName: 'سارة',
          subscriptionId: 'sub-sarah',
          date: targetDate,
        ),
        initialDate: targetDate,
        localeName: 'ar',
      ),
    );

    await Future<void>.delayed(Duration.zero);

    expect(calendarRepo.lastCalendarSubscriptionId, 'sub-sarah');
    expect(calendarRepo.lastDaySubscriptionId, 'sub-sarah');
    expect(calendarRepo.lastDayDate, '2026-09-20');
    expect(viewModel.state.displayName, 'سارة');
    expect(viewModel.state.days.length, 2);
    expect(viewModel.state.selectedDay?.meals.length, 1);
  });

  test('switches family member and reloads their specific calendar', () async {
    final calendarRepo = _FakeCalendarRepository();
    final familyRepo = _FakeFamilyRepository();

    final viewModel = createFamilyCalendarViewModel(
      members: GetFamilyMembersUseCase(familyRepo),
      calendar: GetCalendarUseCase(calendarRepo),
      day: GetCalendarDayUseCase(calendarRepo),
    );
    addTearDown(viewModel.close);

    final targetDate = DateTime(2026, 9, 20);
    viewModel.doIntent(
      InitFamilyCalendarEvent(initialDate: targetDate, localeName: 'ar'),
    );

    await Future<void>.delayed(Duration.zero);

    // Initial member loaded from repo is 'أحمد' (index 0)
    expect(viewModel.state.displayName, 'أحمد');
    expect(calendarRepo.lastCalendarSubscriptionId, 'sub-ahmed');

    // Switch to index 1 ('سارة')
    viewModel.doIntent(
      const SelectFamilyMemberEvent(index: 1, localeName: 'ar'),
    );

    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.displayName, 'سارة');
    expect(calendarRepo.lastCalendarSubscriptionId, 'sub-sarah');
  });

  test(
    'does not reuse previous subscription when selected member has none',
    () async {
      final calendarRepo = _FakeCalendarRepository();
      final viewModel = createFamilyCalendarViewModel(
        calendar: GetCalendarUseCase(calendarRepo),
        day: GetCalendarDayUseCase(calendarRepo),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: const FamilyMemberCalendarArgs(
            memberId: 'mem-1',
            subscriptionId: 'sub-a',
            members: [
              FamilyMemberSummaryEntity(
                memberId: 'mem-1',
                displayName: 'A',
                role: 1,
                ageYears: 10,
                isPaused: false,
                subscriptionId: 'sub-a',
                programName: '',
                remainingDays: 1,
                setupStatus: 1,
              ),
              FamilyMemberSummaryEntity(
                memberId: 'mem-2',
                displayName: 'B',
                role: 1,
                ageYears: 10,
                isPaused: false,
                subscriptionId: null,
                programName: '',
                remainingDays: 1,
                setupStatus: 1,
              ),
            ],
          ),
          initialDate: DateTime(2026, 9, 20),
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      viewModel.doIntent(
        const SelectFamilyMemberEvent(index: 1, localeName: 'ar'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(calendarRepo.lastCalendarSubscriptionId, 'sub-a');
      expect(viewModel.state.activeSubscriptionId, isNull);
    },
  );

  test(
    'late result from an older day request cannot replace current data',
    () async {
      final calendarRepo = _ControllableCalendarRepository();
      final viewModel = createFamilyCalendarViewModel(
        calendar: GetCalendarUseCase(calendarRepo),
        day: GetCalendarDayUseCase(calendarRepo),
      );
      addTearDown(viewModel.close);

      final subDate = DateTime(2026, 9, 20);
      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            memberId: 'm1',
            subscriptionId: 'sub-1',
            date: subDate,
            members: const [
              FamilyMemberSummaryEntity(
                memberId: 'm1',
                displayName: 'M1',
                role: 1,
                ageYears: 10,
                subscriptionId: 'sub-1',
                isPaused: false,
                programName: 'Plan',
                remainingDays: 5,
                setupStatus: 1,
              ),
            ],
          ),
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      calendarRepo.getCalendarCompleters[0].complete(
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [
              CalendarDayEntity(
                dayNumber: 20,
                weekday: 'الأحد',
                date: DateTime(2026, 9, 20),
              ),
              CalendarDayEntity(
                dayNumber: 21,
                weekday: 'الإثنين',
                date: DateTime(2026, 9, 21),
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(calendarRepo.getDayCompleters.length, 1);
      final day20Completer = calendarRepo.getDayCompleters[0];

      viewModel.doIntent(
        SelectFamilyCalendarDayEvent(
          day: CalendarDayEntity(
            dayNumber: 21,
            weekday: 'الإثنين',
            date: DateTime(2026, 9, 21),
          ),
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(calendarRepo.getDayCompleters.length, 2);
      final day21Completer = calendarRepo.getDayCompleters[1];

      day21Completer.complete(
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 21,
            weekday: 'الإثنين',
            date: DateTime(2026, 9, 21),
            meals: const [
              CalendarMealEntity(
                id: 'm-21',
                title: 'Meal 21',
                slot: 'lunch',
                mealType: 'غداء',
                time: '1:00 PM',
                calories: '500',
                protein: '30g',
                carbs: '50g',
                fat: '10g',
                ingredients: [],
                imageAsset: '',
                actionLabel: '',
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.date, DateTime(2026, 9, 21));
      expect(viewModel.state.selectedDay?.meals.first.title, 'Meal 21');

      day20Completer.complete(
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 20,
            weekday: 'الأحد',
            date: DateTime(2026, 9, 20),
            meals: const [
              CalendarMealEntity(
                id: 'm-20',
                title: 'Meal 20',
                slot: 'lunch',
                mealType: 'غداء',
                time: '1:00 PM',
                calories: '500',
                protein: '30g',
                carbs: '50g',
                fat: '10g',
                ingredients: [],
                imageAsset: '',
                actionLabel: '',
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDate, DateTime(2026, 9, 21));
      expect(viewModel.state.selectedDay?.date, DateTime(2026, 9, 21));
      expect(viewModel.state.selectedDay?.meals.first.title, 'Meal 21');
    },
  );

  test(
    'late calendar response from an earlier request cannot overwrite newer request',
    () async {
      final calendarRepo = _ControllableCalendarRepository();
      final viewModel = createFamilyCalendarViewModel(
        calendar: GetCalendarUseCase(calendarRepo),
        day: GetCalendarDayUseCase(calendarRepo),
      );
      addTearDown(viewModel.close);

      const members = [
        FamilyMemberSummaryEntity(
          memberId: 'm1',
          displayName: 'M1',
          role: 1,
          ageYears: 10,
          subscriptionId: 'sub-1',
          isPaused: false,
          programName: 'Plan',
          remainingDays: 5,
          setupStatus: 1,
        ),
      ];

      // Request 1
      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            memberId: 'm1',
            subscriptionId: 'sub-1',
            date: DateTime(2026, 9, 20),
            members: members,
          ),
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(calendarRepo.getCalendarCompleters.length, 1);
      final req1Completer = calendarRepo.getCalendarCompleters[0];

      // Request 2 (e.g. retry / refresh on the same subscription)
      viewModel.doIntent(const RetryFamilyCalendarEvent(localeName: 'ar'));
      await Future<void>.delayed(Duration.zero);
      expect(calendarRepo.getCalendarCompleters.length, 2);
      final req2Completer = calendarRepo.getCalendarCompleters[1];

      // Request 2 completes first with newer data
      req2Completer.complete(
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [
              CalendarDayEntity(
                dayNumber: 25,
                weekday: 'الجمعة',
                date: DateTime(2026, 9, 25),
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.days.first.dayNumber, 25);

      // Request 1 completes late with older data
      req1Completer.complete(
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [
              CalendarDayEntity(
                dayNumber: 20,
                weekday: 'الأحد',
                date: DateTime(2026, 9, 20),
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      // Should still be newer data (dayNumber 25), NOT overwritten by req 1
      expect(viewModel.state.days.first.dayNumber, 25);
    },
  );

  test(
    'day-details retry repeats only the day details fetch, not calendar',
    () async {
      final calendarRepo = _ControllableCalendarRepository();
      final viewModel = createFamilyCalendarViewModel(
        calendar: GetCalendarUseCase(calendarRepo),
        day: GetCalendarDayUseCase(calendarRepo),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            memberId: 'm1',
            subscriptionId: 'sub-1',
            date: DateTime(2026, 9, 20),
            members: const [
              FamilyMemberSummaryEntity(
                memberId: 'm1',
                displayName: 'M1',
                role: 1,
                ageYears: 10,
                subscriptionId: 'sub-1',
                isPaused: false,
                programName: 'Plan',
                remainingDays: 5,
                setupStatus: 1,
              ),
            ],
          ),
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      calendarRepo.getCalendarCompleters[0].complete(
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [
              CalendarDayEntity(
                dayNumber: 20,
                weekday: 'الأحد',
                date: DateTime(2026, 9, 20),
              ),
            ],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      calendarRepo.getDayCompleters[0].complete(
        ApiErrorResult(failure: Failure(errorMessage: 'Server error')),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.dayFailure, isNotNull);
      final initialCalendarCalls = calendarRepo.getCalendarCallCount;
      final initialDayCalls = calendarRepo.getDayCallCount;

      viewModel.doIntent(const RetryFamilyCalendarDayEvent(localeName: 'ar'));
      await Future<void>.delayed(Duration.zero);

      expect(calendarRepo.getCalendarCallCount, initialCalendarCalls);
      expect(calendarRepo.getDayCallCount, initialDayCalls + 1);
    },
  );

  test(
    'ApplyFamilyCalendarDaySnapshotEvent updates selected day and keeps days selection consistent',
    () async {
      final calendarRepo = _FakeCalendarRepository();
      final viewModel = createFamilyCalendarViewModel(
        calendar: GetCalendarUseCase(calendarRepo),
        day: GetCalendarDayUseCase(calendarRepo),
      );
      addTearDown(viewModel.close);

      final targetDate = DateTime(2026, 9, 20);
      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            memberId: 'm1',
            subscriptionId: 'sub-1',
            date: targetDate,
            members: const [
              FamilyMemberSummaryEntity(
                memberId: 'm1',
                displayName: 'M1',
                role: 1,
                ageYears: 10,
                subscriptionId: 'sub-1',
                isPaused: false,
                programName: 'Plan',
                remainingDays: 5,
                setupStatus: 1,
              ),
            ],
          ),
          initialDate: targetDate,
          localeName: 'ar',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final snapshotDay = CalendarDayEntity(
        dayNumber: 20,
        weekday: 'الأحد',
        date: targetDate,
        hasMeals: true,
        meals: const [
          CalendarMealEntity(
            id: 'snapshot-meal',
            title: 'Snapshot Meal',
            slot: 'lunch',
            mealType: 'غداء',
            time: '1:00 PM',
            calories: '500',
            protein: '30g',
            carbs: '50g',
            fat: '10g',
            ingredients: [],
            imageAsset: '',
            actionLabel: '',
          ),
        ],
      );

      viewModel.doIntent(ApplyFamilyCalendarDaySnapshotEvent(snapshotDay));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.meals.first.title, 'Snapshot Meal');
      expect(viewModel.state.selectedDay?.isSelected, isTrue);
      expect(
        viewModel.state.days.firstWhere((d) => d.dayNumber == 20).isSelected,
        isTrue,
      );
    },
  );
}
