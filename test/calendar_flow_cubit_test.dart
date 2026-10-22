import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_effect.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCalendarRepo implements CalendarRepository {
  ApiResult<CalendarSubscriptionEntity>? getCalendarResult;
  ApiResult<CalendarDayEntity>? getDayResult;
  ApiResult<CalendarRestaurantsPageEntity>? restaurantsResult;
  ApiResult<CalendarDayEntity>? setRestaurantResult;
  ApiResult<CalendarAvailableMealsEntity>? availableMealsResult;
  ApiResult<CalendarDayEntity>? saveMealsResult;
  ApiResult<CalendarDayEntity>? autoSelectResult;
  ApiResult<CalendarDayEntity>? confirmResult;

  int getCalendarCallCount = 0;

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) async {
    getCalendarCallCount++;
    return getCalendarResult ??
        ApiSuccessResult(
          data: const CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [],
          ),
        );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    return getDayResult ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thursday',
            date: DateTime.parse(date),
            status: 'open',
            canEdit: true,
          ),
        );
  }

  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) async {
    return restaurantsResult ??
        ApiSuccessResult(
          data: const CalendarRestaurantsPageEntity(
            restaurants: [],
            page: 1,
            pageSize: 20,
            totalCount: 0,
            totalPages: 0,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) async {
    return setRestaurantResult ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thursday',
            date: DateTime.parse(date),
            status: 'open',
            canEdit: true,
          ),
        );
  }

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    int? page,
    int? pageSize,
    String? slot,
  }) async {
    return availableMealsResult ??
        ApiSuccessResult(
          data: const CalendarAvailableMealsEntity(
            restaurant: null,
            meals: [],
            slotRequirements: [],
            slots: [],
          ),
        );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) async {
    return saveMealsResult ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thursday',
            date: DateTime.parse(date),
            status: 'open',
            canEdit: true,
            meals: meals,
          ),
        );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    return autoSelectResult ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thursday',
            date: DateTime.parse(date),
            status: 'open',
            canEdit: true,
          ),
        );
  }

  @override
  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    return confirmResult ??
        ApiSuccessResult(
          data: CalendarDayEntity(
            dayNumber: 15,
            weekday: 'Thursday',
            date: DateTime.parse(date),
            status: 'confirmed',
            canEdit: false,
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeProfileRepo implements SubscriptionBillingRepository {
  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription() async {
    return ApiSuccessResult(
      data: const SubscriptionBillingCurrentEntity(
        emptyStateCode: '',
        subscription: null,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeCalendarRepo calendarRepo;
  late _FakeProfileRepo profileRepo;
  late SharedPrefHelper prefHelper;
  late CalendarOverviewViewModel overviewCubit;
  late RestaurantPickerViewModel restaurantPickerCubit;
  late MealSelectionViewModel mealSelectionCubit;
  late CalendarFlowViewModel flowCubit;

  final testDate = DateTime.utc(2026, 10, 15);

  const testRestaurantOption = CalendarRestaurantOptionEntity(
    id: 'rest-1',
    name: 'Burger House',
    description: 'Tasty burgers',
    mealCount: 5,
    rating: '4.8',
    logoType: CalendarRestaurantLogoType.burgerKing,
  );

  CalendarMealEntity createMeal(String id, {String slot = 'Lunch'}) {
    return CalendarMealEntity(
      id: id,
      title: 'Meal $id',
      slot: slot,
      mealType: 'Meal',
      time: '12:00',
      calories: '500',
      protein: '30g',
      carbs: '40g',
      fat: '15g',
      ingredients: const [],
      imageAsset: '',
      actionLabel: 'Select',
    );
  }

  CalendarDayEntity createDay(
    DateTime date, {
    bool isEditable = true,
    bool isLocked = false,
    List<CalendarMealEntity> meals = const [],
    CalendarRestaurantEntity? restaurant,
  }) {
    return CalendarDayEntity(
      dayNumber: date.day,
      weekday: 'Thursday',
      date: date,
      status: isEditable ? 'open' : 'frozen',
      canEdit: isEditable,
      isLocked: isLocked,
      meals: meals,
      restaurant: restaurant,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.currentSubscriptionId: 'sub-test',
    });
    final prefs = await SharedPreferences.getInstance();
    prefHelper = SharedPrefHelper(prefs);

    calendarRepo = _FakeCalendarRepo();
    profileRepo = _FakeProfileRepo();

    overviewCubit = CalendarOverviewViewModel(
      GetCalendarUseCase(calendarRepo),
      GetCalendarDayUseCase(calendarRepo),
      GetCurrentCustomerSubscriptionUseCase(profileRepo),
      prefHelper,
    );

    restaurantPickerCubit = RestaurantPickerViewModel(
      GetCalendarRestaurantsUseCase(calendarRepo),
      SetCalendarDayRestaurantUseCase(calendarRepo),
    );

    mealSelectionCubit = MealSelectionViewModel(
      GetCalendarAvailableMealsUseCase(calendarRepo),
      SaveCalendarDayMealsUseCase(calendarRepo),
      AutoSelectCalendarDayUseCase(calendarRepo),
      ConfirmCalendarDayMealsUseCase(calendarRepo),
    );

    flowCubit = CalendarFlowViewModel(
      overviewViewModel: overviewCubit,
      restaurantPickerViewModel: restaurantPickerCubit,
      mealSelectionViewModel: mealSelectionCubit,
    );
  });

  tearDown(() async {
    await flowCubit.close();
    await mealSelectionCubit.close();
    await restaurantPickerCubit.close();
    await overviewCubit.close();
  });

  group('CalendarFlowCubit', () {
    test('1. Initial state has null effect', () {
      expect(flowCubit.state.effect, isNull);
    });

    test(
      '2. openRestaurantPicker triggers restaurant cubit for editable day',
      () {
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [createDay(testDate, isEditable: true)],
          ),
        );

        flowCubit.openRestaurantPicker();

        expect(restaurantPickerCubit.state.isLoading, isTrue);
        expect(flowCubit.state.effect, isA<OpenRestaurantPickerEffect>());
        final effect = flowCubit.state.effect as OpenRestaurantPickerEffect;
        expect(effect.id, 1);
        expect(effect.date, testDate);
        expect(effect.subscriptionId, 'sub-1');
      },
    );

    test(
      '3. selectRestaurant success replaces overview day, loads meals, and emits OpenMealPickerEffect',
      () async {
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [createDay(testDate)],
          ),
        );

        final returnedDay = createDay(
          testDate,
          restaurant: const CalendarRestaurantEntity(
            id: 'rest-1',
            name: 'Burger House',
            category: 'Fast Food',
            rating: '4.8',
            deliveryDuration: '30m',
            deliveryWindow: '12-2',
          ),
        );
        calendarRepo.setRestaurantResult = ApiSuccessResult(data: returnedDay);

        await flowCubit.selectRestaurant(restaurant: testRestaurantOption);

        expect(overviewCubit.state.selectedDay?.restaurant?.id, 'rest-1');
        expect(mealSelectionCubit.state.subscriptionId, 'sub-1');
        expect(mealSelectionCubit.state.restaurantId, 'rest-1');
        expect(flowCubit.state.effect, isA<OpenMealPickerEffect>());
        final effect = flowCubit.state.effect as OpenMealPickerEffect;
        expect(effect.id, 1);
        expect(effect.restaurantId, 'rest-1');
        expect(effect.restaurant, testRestaurantOption);
      },
    );

    test(
      '4. selectRestaurant failure emits CalendarFailureEffect and handles errors',
      () async {
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [createDay(testDate)],
          ),
        );

        calendarRepo.setRestaurantResult = ApiErrorResult(
          failure: Failure(
            errorMessage: 'Locked',
            code: SubscriptionErrorCodes.calendarSelectionLocked,
          ),
        );

        await flowCubit.selectRestaurant(restaurant: testRestaurantOption);

        expect(flowCubit.state.effect, isA<CalendarFailureEffect>());
        final effect = flowCubit.state.effect as CalendarFailureEffect;
        expect(
          effect.failure.code,
          SubscriptionErrorCodes.calendarSelectionLocked,
        );
      },
    );

    test(
      '5. openMealPicker loads meals into mealSelectionCubit and emits OpenMealPickerEffect',
      () {
        final initialDay = createDay(
          testDate,
          restaurant: const CalendarRestaurantEntity(
            id: 'rest-1',
            name: 'Burger House',
            category: 'Fast Food',
            rating: '4.8',
            deliveryDuration: '30m',
            deliveryWindow: '12-2',
          ),
        );
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        flowCubit.openMealPicker(restaurant: testRestaurantOption);

        expect(mealSelectionCubit.state.subscriptionId, 'sub-1');
        expect(mealSelectionCubit.state.restaurantId, 'rest-1');
        expect(flowCubit.state.effect, isA<OpenMealPickerEffect>());
        final effect = flowCubit.state.effect as OpenMealPickerEffect;
        expect(effect.id, 1);
        expect(effect.restaurantId, 'rest-1');
      },
    );

    test(
      '6. saveMeals success replaces overview day, clears mealSelection, and emits MealsSavedEffect',
      () async {
        final initialDay = createDay(testDate);
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        final meal1 = createMeal('m1');
        mealSelectionCubit.emit(
          mealSelectionCubit.state.copyWith(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurantId: 'rest-1',
            selectedMealIds: ['m1'],
            availableMeals: CalendarAvailableMealsEntity(
              restaurant: const CalendarRestaurantEntity(
                id: 'rest-1',
                name: 'Burger House',
                category: 'Fast Food',
                rating: '4.8',
                deliveryDuration: '30m',
                deliveryWindow: '12-2',
              ),
              meals: [meal1],
              slotRequirements: const [
                CalendarSlotRequirementEntity(
                  slot: 'Lunch',
                  displayName: 'Lunch',
                  slotNameAr: 'الغداء',
                  slotNameEn: 'Lunch',
                  count: 1,
                ),
              ],
              slots: const [
                CalendarSlotMealsEntity(
                  slot: 'Lunch',
                  displayName: 'Lunch',
                  slotNameAr: 'الغداء',
                  slotNameEn: 'Lunch',
                  count: 1,
                ),
              ],
            ),
          ),
        );

        final savedDay = createDay(testDate, meals: [meal1]);
        calendarRepo.saveMealsResult = ApiSuccessResult(data: savedDay);

        await flowCubit.saveMeals();

        expect(overviewCubit.state.selectedDay?.meals.length, 1);
        expect(mealSelectionCubit.state.subscriptionId, isEmpty);
        expect(mealSelectionCubit.state.availableMeals, isNull);
        expect(flowCubit.state.effect, isA<MealsSavedEffect>());
        final effect = flowCubit.state.effect as MealsSavedEffect;
        expect(effect.id, 1);
        expect(effect.day.meals.first.id, 'm1');
      },
    );

    test(
      '7. saveMeals failure emits CalendarFailureEffect without mutating overview',
      () async {
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [createDay(testDate)],
          ),
        );

        final meal1 = createMeal('m1');
        mealSelectionCubit.emit(
          mealSelectionCubit.state.copyWith(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurantId: 'rest-1',
            selectedMealIds: ['m1'],
            availableMeals: CalendarAvailableMealsEntity(
              restaurant: const CalendarRestaurantEntity(
                id: 'rest-1',
                name: 'Burger House',
                category: 'Fast Food',
                rating: '4.8',
                deliveryDuration: '30m',
                deliveryWindow: '12-2',
              ),
              meals: [meal1],
              slotRequirements: const [
                CalendarSlotRequirementEntity(
                  slot: 'Lunch',
                  displayName: 'Lunch',
                  slotNameAr: 'الغداء',
                  slotNameEn: 'Lunch',
                  count: 1,
                ),
              ],
              slots: const [
                CalendarSlotMealsEntity(
                  slot: 'Lunch',
                  displayName: 'Lunch',
                  slotNameAr: 'الغداء',
                  slotNameEn: 'Lunch',
                  count: 1,
                ),
              ],
            ),
          ),
        );

        calendarRepo.saveMealsResult = ApiErrorResult(
          failure: Failure(errorMessage: 'Server Error', code: 'server_error'),
        );

        await flowCubit.saveMeals();

        expect(flowCubit.state.effect, isA<CalendarFailureEffect>());
        final effect = flowCubit.state.effect as CalendarFailureEffect;
        expect(effect.failure.code, 'server_error');
        expect(overviewCubit.state.selectedDay?.meals, isEmpty);
      },
    );

    test(
      '8. confirmMeals success forces non-editable status, preserves meals if response meals empty, and emits MealsConfirmedEffect',
      () async {
        final existingMeal = createMeal('m1');
        final initialDay = createDay(
          testDate,
          isEditable: true,
          meals: [existingMeal],
        );
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        // Backend returns confirmed day with empty meals
        final confirmedFromBackend = createDay(
          testDate,
          isEditable: true,
          meals: const [],
        );
        calendarRepo.confirmResult = ApiSuccessResult(
          data: confirmedFromBackend,
        );

        await flowCubit.confirmMeals();

        final updatedDay = overviewCubit.state.selectedDay;
        expect(updatedDay?.canEdit, isFalse);
        expect(updatedDay?.meals.length, 1);
        expect(updatedDay?.meals.first.id, 'm1');
        expect(mealSelectionCubit.state.subscriptionId, isEmpty);

        expect(flowCubit.state.effect, isA<MealsConfirmedEffect>());
        final effect = flowCubit.state.effect as MealsConfirmedEffect;
        expect(effect.id, 1);
        expect(effect.day.canEdit, isFalse);
        expect(effect.day.meals.length, 1);
      },
    );

    test(
      '9. confirmMeals failure with calendarSelectionLocked marks day locked and non-editable',
      () async {
        final initialDay = createDay(
          testDate,
          isEditable: true,
          isLocked: false,
        );
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        calendarRepo.confirmResult = ApiErrorResult(
          failure: Failure(
            errorMessage: 'Selection is locked',
            code: SubscriptionErrorCodes.calendarSelectionLocked,
          ),
        );

        await flowCubit.confirmMeals();

        final updatedDay = overviewCubit.state.selectedDay;
        expect(updatedDay?.canEdit, isFalse);
        expect(updatedDay?.isLocked, isTrue);

        expect(flowCubit.state.effect, isA<CalendarFailureEffect>());
        final effect = flowCubit.state.effect as CalendarFailureEffect;
        expect(
          effect.failure.code,
          SubscriptionErrorCodes.calendarSelectionLocked,
        );
      },
    );

    test(
      '10. confirmMeals failure with calendarDayUnavailable reloads overview calendar',
      () async {
        final initialDay = createDay(testDate, isEditable: true);
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        calendarRepo.confirmResult = ApiErrorResult(
          failure: Failure(
            errorMessage: 'Day unavailable',
            code: SubscriptionErrorCodes.calendarDayUnavailable,
          ),
        );

        final initialCallCount = calendarRepo.getCalendarCallCount;
        await flowCubit.confirmMeals();

        expect(
          calendarRepo.getCalendarCallCount,
          greaterThan(initialCallCount),
        );
        expect(flowCubit.state.effect, isA<CalendarFailureEffect>());
        final effect = flowCubit.state.effect as CalendarFailureEffect;
        expect(
          effect.failure.code,
          SubscriptionErrorCodes.calendarDayUnavailable,
        );
      },
    );

    test(
      '11. autoSelectMeals success replaces overview day and emits MealsSavedEffect',
      () async {
        final initialDay = createDay(testDate);
        overviewCubit.emit(
          CalendarOverviewState(
            subscriptionId: 'sub-1',
            selectedDate: testDate,
            days: [initialDay],
          ),
        );

        final autoSelectedDay = createDay(
          testDate,
          meals: [createMeal('auto-1')],
        );
        calendarRepo.autoSelectResult = ApiSuccessResult(data: autoSelectedDay);

        await flowCubit.autoSelectMeals();

        expect(overviewCubit.state.selectedDay?.meals.first.id, 'auto-1');
        expect(flowCubit.state.effect, isA<MealsSavedEffect>());
        final effect = flowCubit.state.effect as MealsSavedEffect;
        expect(effect.id, 1);
        expect(effect.day.meals.first.id, 'auto-1');
      },
    );

    test(
      '12. closeMealPicker clears meal selection and emits CloseMealPickerEffect',
      () {
        mealSelectionCubit.emit(
          mealSelectionCubit.state.copyWith(
            subscriptionId: 'sub-1',
            restaurantId: 'rest-1',
          ),
        );

        flowCubit.closeMealPicker();

        expect(mealSelectionCubit.state.subscriptionId, isEmpty);
        expect(flowCubit.state.effect, isA<CloseMealPickerEffect>());
        final effect = flowCubit.state.effect as CloseMealPickerEffect;
        expect(effect.id, 1);
      },
    );

    test('13. flowCubit.close does not close child cubits', () async {
      await flowCubit.close();

      expect(flowCubit.isClosed, isTrue);
      expect(overviewCubit.isClosed, isFalse);
      expect(restaurantPickerCubit.isClosed, isFalse);
      expect(mealSelectionCubit.isClosed, isFalse);
    });
  });
}
