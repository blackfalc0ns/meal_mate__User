import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_capabilities_usecase.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FakeFamilyMemberRepository implements FamilyMemberRepository {
  List<FamilyCapabilityEntity> capabilitiesToReturn = [];

  @override
  Future<ApiResult<List<FamilyCapabilityEntity>>> getMemberCapabilities(
    String memberId,
  ) async {
    return ApiSuccessResult(data: capabilitiesToReturn);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSaveDayMealsUseCase implements SaveCalendarDayMealsUseCase {
  ApiResult<CalendarDayEntity>? result;

  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) async {
    return result ??
        ApiSuccessResult(
          data: const CalendarDayEntity(
            dayNumber: 1,
            weekday: 'Mon',
            canEdit: true,
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGetCalendarUseCase implements GetCalendarUseCase {
  @override
  Future<ApiResult<CalendarSubscriptionEntity>> call({
    required String subscriptionId,
    required String localeName,
  }) async {
    return ApiSuccessResult(
      data: CalendarSubscriptionEntity(
        subscriptionId: subscriptionId,
        days: [
          CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thu',
            date: DateTime(2026, 10, 15),
            canEdit: true,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Family Calendar Capability Gating & State Tests', () {
    test('1. Granular capabilities evaluate independently: add-only', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: true),
          FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
          FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
        ],
      );

      expect(state.canEditMealsAndDays, isTrue);
      expect(state.canSelectRestaurant, isFalse);
      expect(state.canUnitExchange, isFalse);
      expect(state.canConfirmMeals, isFalse);
      expect(state.canViewCalendar, isTrue);
    });

    test('2. Granular capabilities evaluate independently: replace-only', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'unitExchange', allowed: true),
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
          FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
        ],
      );

      expect(state.canUnitExchange, isTrue);
      expect(state.canEditMealsAndDays, isFalse);
      expect(state.canSelectRestaurant, isFalse);
      expect(state.canConfirmMeals, isFalse);
    });

    test('3. Granular capabilities evaluate independently: confirm-only', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: true),
          FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
          FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
        ],
      );

      expect(state.canConfirmMeals, isTrue);
      expect(state.canUnitExchange, isFalse);
      expect(state.canEditMealsAndDays, isFalse);
      expect(state.canSelectRestaurant, isFalse);
    });

    test('4. Granular capabilities evaluate independently: restaurant-only', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'selectRestaurant', allowed: true),
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
          FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
        ],
      );

      expect(state.canSelectRestaurant, isTrue);
      expect(state.canEditMealsAndDays, isFalse);
      expect(state.canUnitExchange, isFalse);
      expect(state.canConfirmMeals, isFalse);
    });

    test('5. Read-only scenario: canViewCalendar is true, all edit capabilities false', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
          FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
        ],
      );

      expect(state.canViewCalendar, isTrue);
      expect(state.canSelectRestaurant, isFalse);
      expect(state.canEditMealsAndDays, isFalse);
      expect(state.canUnitExchange, isFalse);
      expect(state.canConfirmMeals, isFalse);
    });

    test('6. Legacy fallback: editDailyMeals enables all granular editing capabilities', () {
      const state = FamilyCalendarState(
        memberCapabilities: [
          FamilyCapabilityEntity(action: 'editDailyMeals', allowed: true),
        ],
      );

      expect(state.canSelectRestaurant, isTrue);
      expect(state.canEditMealsAndDays, isTrue);
      expect(state.canUnitExchange, isTrue);
      expect(state.canConfirmMeals, isTrue);
    });

    test('7. Closed-day checks: isEditable is false when server locks day despite capabilities', () {
      const dayDeadlinePassed = CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Thu',
        canEdit: true,
        editBlockReason: 'selection_deadline_passed',
      );
      expect(dayDeadlinePassed.isLocked, isTrue);
      expect(dayDeadlinePassed.isEditable, isFalse);

      const dayLocked = CalendarDayEntity(
        dayNumber: 16,
        weekday: 'Fri',
        canEdit: true,
        editBlockReason: 'day_locked',
      );
      expect(dayLocked.isLocked, isTrue);
      expect(dayLocked.isEditable, isFalse);

      const dayFrozen = CalendarDayEntity(
        dayNumber: 17,
        weekday: 'Sat',
        canEdit: true,
        editBlockReason: 'day_frozen',
      );
      expect(dayFrozen.isLocked, isTrue);
      expect(dayFrozen.isEditable, isFalse);

      const dayCanEditFalse = CalendarDayEntity(
        dayNumber: 18,
        weekday: 'Sun',
        canEdit: false,
      );
      expect(dayCanEditFalse.isLocked, isTrue);
      expect(dayCanEditFalse.isEditable, isFalse);
    });

    test('8. Ineligible subscription: switching to member with null subscription does not leak previous subscription', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      final capabilitiesUseCase = GetFamilyMemberCapabilitiesUseCase(fakeRepo);
      final calendarUseCase = FakeGetCalendarUseCase();

      final viewModel = FamilyCalendarViewModel(
        null,
        calendarUseCase,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        capabilitiesUseCase,
      );

      const memberWithSub = FamilyMemberSummaryEntity(
        memberId: 'm-1',
        displayName: 'Member One',
        role: 1,
        ageYears: 35,
        isPaused: false,
        programName: 'Balanced',
        remainingDays: 14,
        setupStatus: 2,
        subscriptionId: 'sub-active-1',
      );
      const memberWithoutSub = FamilyMemberSummaryEntity(
        memberId: 'm-2',
        displayName: 'Member Two',
        role: 2,
        ageYears: 10,
        isPaused: false,
        programName: 'Youth',
        remainingDays: 0,
        setupStatus: 1,
        subscriptionId: null,
      );

      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: const FamilyMemberCalendarArgs(
            members: [memberWithSub, memberWithoutSub],
            memberId: 'm-1',
            subscriptionId: 'sub-active-1',
          ),
          initialDate: DateTime(2026, 10, 15),
          localeName: 'en',
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(viewModel.state.activeSubscriptionId, equals('sub-active-1'));

      // Switch to member without subscription
      viewModel.doIntent(
        const SelectFamilyMemberEvent(index: 1, localeName: 'en'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(viewModel.state.selectedMemberIndex, equals(1));
      expect(viewModel.state.activeSubscriptionId, isNull);
      expect(viewModel.state.currentMember?.effectiveSubscriptionId, isNull);

      viewModel.close();
    });

    test('9. ViewModel fetches member capabilities on member selection/init', () async {
      final fakeRepo = FakeFamilyMemberRepository();
      fakeRepo.capabilitiesToReturn = const [
        FamilyCapabilityEntity(action: 'selectRestaurant', allowed: true),
        FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
      ];
      final capabilitiesUseCase = GetFamilyMemberCapabilitiesUseCase(fakeRepo);
      final calendarUseCase = FakeGetCalendarUseCase();

      final viewModel = FamilyCalendarViewModel(
        null,
        calendarUseCase,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        capabilitiesUseCase,
      );

      const member = FamilyMemberSummaryEntity(
        memberId: 'm-capabilities-test',
        displayName: 'Test Member',
        role: 2,
        ageYears: 20,
        isPaused: false,
        programName: 'Active',
        remainingDays: 10,
        setupStatus: 2,
        subscriptionId: 'sub-cap-1',
      );

      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: const FamilyMemberCalendarArgs(
            members: [member],
            memberId: 'm-capabilities-test',
            subscriptionId: 'sub-cap-1',
          ),
          initialDate: DateTime(2026, 10, 15),
          localeName: 'en',
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.memberCapabilities.length, equals(2));
      expect(viewModel.state.canSelectRestaurant, isTrue);
      expect(viewModel.state.canConfirmMeals, isFalse);

      viewModel.close();
    });

    test('10. 403 Forbidden handling on save meals: records saveMealsFailure and does not claim success', () async {
      final fakeSave = FakeSaveDayMealsUseCase();
      fakeSave.result = ApiErrorResult(
        failure: Failure(
          errorMessage: 'Forbidden: action not permitted for actor',
          code: 'FORBIDDEN',
          exception: ApiException(
            statusCode: 403,
            message: 'Forbidden',
            errorType: ApiErrorType.forbidden,
          ),
        ),
      );

      final viewModel = FamilyCalendarViewModel(
        null,
        FakeGetCalendarUseCase(),
        null,
        null,
        null,
        fakeSave,
        null,
        null,
        null,
        null,
      );

      viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: const FamilyMemberCalendarArgs(
            members: [
              FamilyMemberSummaryEntity(
                memberId: 'm-1',
                displayName: 'Member One',
                role: 1,
                ageYears: 30,
                isPaused: false,
                programName: 'Standard',
                remainingDays: 10,
                setupStatus: 2,
                subscriptionId: 'sub-1',
              ),
            ],
            subscriptionId: 'sub-1',
          ),
          localeName: 'en',
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Attempt save
      viewModel.doIntent(const SaveFamilyDayMealsEvent(localeName: 'en'));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.saveMealsSuccess, isFalse);
      expect(viewModel.state.saveMealsFailure, isNotNull);
      expect(viewModel.state.saveMealsFailure?.exception.statusCode, equals(403));

      viewModel.close();
    });
  });
}
