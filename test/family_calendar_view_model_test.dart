import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
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
    return ApiSuccessResult(
      data: const [
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

void main() {
  test('initializes and loads calendar using member subscription id', () async {
    final calendarRepo = _FakeCalendarRepository();
    final familyRepo = _FakeFamilyRepository();

    final viewModel = FamilyCalendarViewModel(
      GetFamilyMembersUseCase(familyRepo),
      GetCalendarUseCase(calendarRepo),
      GetCalendarDayUseCase(calendarRepo),
      GetCalendarRestaurantsUseCase(calendarRepo),
      GetCalendarAvailableMealsUseCase(calendarRepo),
      SaveCalendarDayMealsUseCase(calendarRepo),
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

    final viewModel = FamilyCalendarViewModel(
      GetFamilyMembersUseCase(familyRepo),
      GetCalendarUseCase(calendarRepo),
      GetCalendarDayUseCase(calendarRepo),
      GetCalendarRestaurantsUseCase(calendarRepo),
      GetCalendarAvailableMealsUseCase(calendarRepo),
      SaveCalendarDayMealsUseCase(calendarRepo),
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

  test('does not reuse previous subscription when selected member has none', () async {
    final calendarRepo = _FakeCalendarRepository();
    final viewModel = FamilyCalendarViewModel(
      null,
      GetCalendarUseCase(calendarRepo),
      GetCalendarDayUseCase(calendarRepo),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(
      InitFamilyCalendarEvent(
        args: FamilyMemberCalendarArgs(
          memberId: 'mem-1',
          subscriptionId: 'sub-a',
          members: const [
            FamilyMemberSummaryEntity(
              memberId: 'mem-1', displayName: 'A', role: 1, ageYears: 10,
              isPaused: false, subscriptionId: 'sub-a', programName: '',
              remainingDays: 1, setupStatus: 1,
            ),
            FamilyMemberSummaryEntity(
              memberId: 'mem-2', displayName: 'B', role: 1, ageYears: 10,
              isPaused: false, subscriptionId: null, programName: '',
              remainingDays: 1, setupStatus: 1,
            ),
          ],
        ),
        initialDate: DateTime(2026, 9, 20),
        localeName: 'ar',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    viewModel.doIntent(const SelectFamilyMemberEvent(index: 1, localeName: 'ar'));
    await Future<void>.delayed(Duration.zero);

    expect(calendarRepo.lastCalendarSubscriptionId, 'sub-a');
    expect(viewModel.state.activeSubscriptionId, isEmpty);
  });
}
