import 'support/family_calendar_view_model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_current_restaurant_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_review_button.dart';

const _kDefaultRestaurant = CalendarRestaurantEntity(
  id: 'rest-1',
  name: 'Healthy Corner',
  category: 'Healthy',
  deliveryDuration: '30m',
  deliveryWindow: '12:00-1:00',
);

const _kDefaultMeal = CalendarMealEntity(
  id: 'meal-1',
  title: 'Chicken Rice',
  slot: 'lunch',
  mealType: 'Lunch',
  time: '1:00 PM',
  calories: '450',
  protein: '35g',
  carbs: '40g',
  fat: '15g',
  ingredients: [],
  imageAsset: '',
  actionLabel: 'Edit',
);

class _FakeGetCalendarDayUseCase implements GetCalendarDayUseCase {
  int callCount = 0;
  CalendarDayEntity? returnedDay;

  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    callCount++;
    return ApiSuccessResult(
      data:
          returnedDay ??
          CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Wednesday',
            date: DateTime(2026, 10, 15),
            canEdit: true,
            isLocked: false,
            restaurant: _kDefaultRestaurant,
            meals: const [],
          ),
    );
  }
}

class _FakeSaveCalendarDayMealsUseCase implements SaveCalendarDayMealsUseCase {
  ApiResult<CalendarDayEntity>? result;
  int callCount = 0;

  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) async {
    callCount++;
    return result ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Wednesday',
            date: DateTime(2026, 10, 15),
            canEdit: true,
            isLocked: false,
          ),
        );
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: const Locale('en'),
    home: child,
  );
}

void main() {
  group('Task 6: Granular Calendar Capabilities State Tests', () {
    test(
      'Capability getters evaluate independent granular actions correctly',
      () {
        const stateAddOnly = FamilyCalendarState(
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: true),
            FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
            FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
            FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
            FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          ],
        );

        expect(stateAddOnly.canEditMealsAndDays, isTrue);
        expect(stateAddOnly.canUnitExchange, isFalse);
        expect(stateAddOnly.canConfirmMeals, isFalse);
        expect(stateAddOnly.canSelectRestaurant, isFalse);
        expect(stateAddOnly.canViewCalendar, isTrue);

        const stateReplaceOnly = FamilyCalendarState(
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
            FamilyCapabilityEntity(action: 'unitExchange', allowed: true),
            FamilyCapabilityEntity(action: 'confirmMeals', allowed: false),
            FamilyCapabilityEntity(action: 'selectRestaurant', allowed: false),
          ],
        );

        expect(stateReplaceOnly.canEditMealsAndDays, isFalse);
        expect(stateReplaceOnly.canUnitExchange, isTrue);
        expect(stateReplaceOnly.canConfirmMeals, isFalse);
        expect(stateReplaceOnly.canSelectRestaurant, isFalse);

        const stateConfirmOnly = FamilyCalendarState(
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'confirmMeals', allowed: true),
          ],
        );

        expect(stateConfirmOnly.canConfirmMeals, isTrue);
        expect(stateConfirmOnly.canEditMealsAndDays, isFalse);
        expect(stateConfirmOnly.canUnitExchange, isFalse);

        const stateRestaurantOnly = FamilyCalendarState(
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'selectRestaurant', allowed: true),
          ],
        );

        expect(stateRestaurantOnly.canSelectRestaurant, isTrue);
        expect(stateRestaurantOnly.canEditMealsAndDays, isFalse);
      },
    );

    test('Legacy editDailyMeals fallback grants all granular meal actions', () {
      const legacyState = FamilyCalendarState(
        memberCapabilities: const [
          FamilyCapabilityEntity(action: 'editDailyMeals', allowed: true),
        ],
      );

      expect(legacyState.canSelectRestaurant, isTrue);
      expect(legacyState.canEditMealsAndDays, isTrue);
      expect(legacyState.canUnitExchange, isTrue);
      expect(legacyState.canConfirmMeals, isTrue);
    });
  });

  group('Task 6: Granular Calendar Action Gating Widget Tests', () {
    testWidgets('Empty slot add button requires canEditMealsAndDays', (
      tester,
    ) async {
      final fakeDayUseCase = _FakeGetCalendarDayUseCase();
      final vm = createFamilyCalendarViewModel(day: fakeDayUseCase);

      // Initialize state with canEditMealsAndDays = false
      vm.emit(
        FamilyCalendarState(
          currentSubscriptionId: 'sub-1',
          selectedDate: DateTime(2026, 10, 15),
          selectedDay: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Wednesday',
            date: DateTime(2026, 10, 15),
            canEdit: true,
            isLocked: false,
            meals: const [],
          ),
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: false),
          ],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          FamilyDayMealsScreen(
            args: FamilyDayMealsArgs(
              subscriptionId: 'sub-1',
              date: DateTime(2026, 10, 15),
              memberName: 'Test Member',
            ),
            viewModel: vm,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final mealCard = tester.widget<FamilyDayMealCard>(
        find.byType(FamilyDayMealCard),
      );
      expect(mealCard.onEditPressed, isNull);

      // Now enable canEditMealsAndDays
      final newState = vm.state.copyWith(
        memberCapabilities: const [
          FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: true),
        ],
      );
      print(
        'DEBUG: newState.canEditMealsAndDays: ${newState.canEditMealsAndDays}',
      );
      print('DEBUG: newState.selectedDay: ${newState.selectedDay}');
      print(
        'DEBUG: newState.selectedDay?.isEditable: ${newState.selectedDay?.isEditable}',
      );
      vm.emit(newState);
      await tester.pump(const Duration(milliseconds: 100));

      final mealCardEnabled = tester.widget<FamilyDayMealCard>(
        find.byType(FamilyDayMealCard),
      );
      print(
        'DEBUG: mealCardEnabled.onEditPressed: ${mealCardEnabled.onEditPressed}',
      );
      expect(mealCardEnabled.onEditPressed, isNotNull);
    });

    testWidgets('Filled slot replacement requires canUnitExchange', (
      tester,
    ) async {
      final fakeDayUseCase = _FakeGetCalendarDayUseCase();
      final vm = createFamilyCalendarViewModel(day: fakeDayUseCase);

      // Initialize state with filled meal and unitExchange = false
      vm.emit(
        FamilyCalendarState(
          currentSubscriptionId: 'sub-1',
          selectedDate: DateTime(2026, 10, 15),
          selectedDay: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Wednesday',
            date: DateTime(2026, 10, 15),
            canEdit: true,
            isLocked: false,
            restaurant: _kDefaultRestaurant,
            meals: const [_kDefaultMeal],
          ),
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'unitExchange', allowed: false),
            FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: true),
          ],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          FamilyDayMealsScreen(
            args: FamilyDayMealsArgs(
              subscriptionId: 'sub-1',
              date: DateTime(2026, 10, 15),
              memberName: 'Test Member',
            ),
            viewModel: vm,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final mealCard = tester.widget<FamilyDayMealCard>(
        find.byType(FamilyDayMealCard),
      );
      expect(mealCard.onEditPressed, isNull);

      // Enable unitExchange
      vm.emit(
        vm.state.copyWith(
          memberCapabilities: const [
            FamilyCapabilityEntity(action: 'unitExchange', allowed: true),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final mealCardEnabled = tester.widget<FamilyDayMealCard>(
        find.byType(FamilyDayMealCard),
      );
      expect(mealCardEnabled.onEditPressed, isNotNull);
    });

    testWidgets(
      'Locked or closed day (canEdit: false) disables all actions regardless of capabilities',
      (tester) async {
        final fakeDayUseCase = _FakeGetCalendarDayUseCase();
        final vm = createFamilyCalendarViewModel(day: fakeDayUseCase);

        vm.emit(
          FamilyCalendarState(
            currentSubscriptionId: 'sub-1',
            selectedDate: DateTime(2026, 10, 15),
            selectedDay: CalendarDayEntity(
              dayNumber: 15,
              weekday: 'Wednesday',
              date: DateTime(2026, 10, 15),
              canEdit: false, // Day is locked/closed!
              isLocked: true,
              restaurant: _kDefaultRestaurant,
              meals: const [_kDefaultMeal],
            ),
            memberCapabilities: const [
              FamilyCapabilityEntity(action: 'unitExchange', allowed: true),
              FamilyCapabilityEntity(action: 'editMealsAndDays', allowed: true),
              FamilyCapabilityEntity(action: 'selectRestaurant', allowed: true),
              FamilyCapabilityEntity(action: 'confirmMeals', allowed: true),
            ],
          ),
        );

        await tester.pumpWidget(
          _wrap(
            FamilyDayMealsScreen(
              args: FamilyDayMealsArgs(
                subscriptionId: 'sub-1',
                date: DateTime(2026, 10, 15),
                memberName: 'Test Member',
              ),
              viewModel: vm,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        final restaurantCard = tester.widget<FamilyDayCurrentRestaurantCard>(
          find.byType(FamilyDayCurrentRestaurantCard),
        );
        expect(restaurantCard.onChangeRestaurant, isNull);

        final mealCard = tester.widget<FamilyDayMealCard>(
          find.byType(FamilyDayMealCard),
        );
        expect(mealCard.onEditPressed, isNull);

        final reviewButton = tester.widget<FamilyDayReviewButton>(
          find.byType(FamilyDayReviewButton),
        );
        expect(reviewButton.onPressed, isNull);
      },
    );
  });

  group('Task 6: 403 Stale UI Rejection Handling', () {
    test(
      '403 forbidden rejection on saveDayMeals triggers day refetch',
      () async {
        final fakeDayUseCase = _FakeGetCalendarDayUseCase();
        final fakeSaveUseCase = _FakeSaveCalendarDayMealsUseCase();

        fakeSaveUseCase.result = ApiErrorResult(
          failure: Failure.fromException(
            const ApiException(
              errorType: ApiErrorType.forbidden,
              message: 'Permission denied',
              statusCode: 403,
            ),
          ),
        );

        final calendar = createFamilyCalendarViewModel(day: fakeDayUseCase);
        calendar.emit(
          FamilyCalendarState(
            currentSubscriptionId: 'sub-1',
            selectedDate: DateTime(2026, 10, 15),
            selectedDay: CalendarDayEntity(
              dayNumber: 15,
              weekday: 'Wednesday',
              date: DateTime(2026, 10, 15),
              meals: const [_kDefaultMeal],
            ),
          ),
        );
        final vm = FamilyMealSelectionViewModel(
          calendar: calendar,
          getCalendarDayUseCase: fakeDayUseCase,
          saveDayMealsUseCase: fakeSaveUseCase,
        );

        expect(fakeDayUseCase.callCount, equals(0));

        vm.doIntent(const SaveFamilyDayMealsEvent(localeName: 'en'));
        await pumpEventQueue();

        expect(fakeSaveUseCase.callCount, equals(1));
        // Re-fetched day details following 403
        expect(fakeDayUseCase.callCount, equals(1));
        expect(vm.state.saveMealsFailure, isNotNull);
      },
    );
  });
}
