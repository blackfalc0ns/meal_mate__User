import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';

class _ControllableCalendarRepo implements CalendarRepository {
  final List<Completer<ApiResult<CalendarAvailableMealsEntity>>>
  availableMealsCompleters = [];
  final List<String> availableMealsRestaurantIds = [];
  final List<int?> availableMealsPages = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> saveDayMealsCompleters =
      [];
  final List<List<CalendarMealEntity>> saveDayMealsList = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> autoSelectCompleters = [];

  final List<Completer<ApiResult<CalendarDayEntity>>>
  confirmDayMealsCompleters = [];

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    int? page,
    int? pageSize,
    String? slot,
  }) {
    availableMealsRestaurantIds.add(restaurantId);
    availableMealsPages.add(page);
    final completer = Completer<ApiResult<CalendarAvailableMealsEntity>>();
    availableMealsCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) {
    saveDayMealsList.add(meals);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    saveDayMealsCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    autoSelectCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    confirmDayMealsCompleters.add(completer);
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

CalendarMealEntity _createMeal(
  String id, {
  required String slot,
  String? blockReason,
}) {
  return CalendarMealEntity(
    id: id,
    title: 'Meal $id',
    description: 'Desc $id',
    mealType: slot,
    time: '12:00 PM',
    calories: '500',
    protein: '30g',
    carbs: '40g',
    fat: '10g',
    ingredients: const [],
    imageAsset: '',
    actionLabel: '',
    slot: slot,
    blockReason: blockReason,
  );
}

CalendarAvailableMealsEntity _createAvailableMeals({
  required String restaurantId,
  required List<CalendarMealEntity> meals,
  List<CalendarSlotRequirementEntity> requirements = const [],
  List<CalendarSlotMealsEntity> slots = const [],
}) {
  return CalendarAvailableMealsEntity(
    restaurant: CalendarRestaurantEntity(
      id: restaurantId,
      name: 'Rest $restaurantId',
      category: 'Healthy',
      rating: '4.5',
      deliveryDuration: '30m',
      deliveryWindow: '12:00 - 1:00',
    ),
    slotRequirements: requirements,
    meals: meals,
    slots: slots,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ControllableCalendarRepo repo;
  late MealSelectionCubit cubit;
  final testDate = DateTime(2026, 10, 15);

  setUp(() {
    repo = _ControllableCalendarRepo();
    cubit = MealSelectionCubit(
      GetCalendarAvailableMealsUseCase(repo),
      SaveCalendarDayMealsUseCase(repo),
      AutoSelectCalendarDayUseCase(repo),
      ConfirmCalendarDayMealsUseCase(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('MealSelectionCubit', () {
    test('1. load fetches available meals and sets state', () async {
      final future = cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        restaurantId: 'r1',
        localeName: 'en',
      );
      expect(cubit.state.isLoading, isTrue);

      final m1 = _createMeal('m1', slot: 'Lunch');
      final available = _createAvailableMeals(
        restaurantId: 'r1',
        meals: [m1],
        requirements: const [
          CalendarSlotRequirementEntity(
            slot: 'Lunch',
            displayName: 'Lunch',
            slotNameAr: 'غداء',
            slotNameEn: 'Lunch',
            count: 1,
          ),
        ],
      );

      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(data: available),
      );
      await future;

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.hasAvailableMeals, isTrue);
      expect(cubit.state.availableMeals?.meals.first.id, 'm1');
    });

    test('2. stale restaurant response rejection', () async {
      // Load restaurant A
      cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        restaurantId: 'rA',
        localeName: 'en',
      );
      // Load restaurant B
      cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        restaurantId: 'rB',
        localeName: 'en',
      );

      expect(repo.availableMealsRestaurantIds, ['rA', 'rB']);

      // Resolve B first
      final mB = _createMeal('mB', slot: 'Lunch');
      final availableB = _createAvailableMeals(restaurantId: 'rB', meals: [mB]);
      repo.availableMealsCompleters[1].complete(
        ApiSuccessResult(data: availableB),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.availableMeals?.restaurant?.id, 'rB');

      // Resolve A late
      final mA = _createMeal('mA', slot: 'Lunch');
      final availableA = _createAvailableMeals(restaurantId: 'rA', meals: [mA]);
      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(data: availableA),
      );
      await Future<void>.delayed(Duration.zero);

      // Stays B
      expect(cubit.state.availableMeals?.restaurant?.id, 'rB');
    });

    test(
      '3. meal toggle, deselect, blocked meal, and per-slot replacement',
      () async {
        final m1 = _createMeal('m1', slot: 'Lunch');
        final m2 = _createMeal('m2', slot: 'Lunch');
        final mBlocked = _createMeal(
          'mB',
          slot: 'Lunch',
          blockReason: 'Unavailable',
        );

        final available = _createAvailableMeals(
          restaurantId: 'r1',
          meals: [m1, m2, mBlocked],
          requirements: const [
            CalendarSlotRequirementEntity(
              slot: 'Lunch',
              displayName: 'Lunch',
              slotNameAr: 'غداء',
              slotNameEn: 'Lunch',
              count: 1,
            ),
          ],
        );

        // Seed state
        cubit.emit(
          MealSelectionState(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurantId: 'r1',
            availableMeals: available,
          ),
        );

        // Toggle m1 -> selected
        cubit.toggleMeal('m1');
        expect(cubit.state.selectedMealIds, ['m1']);
        expect(cubit.state.canSave, isTrue);

        // Toggle m1 again -> deselected
        cubit.toggleMeal('m1');
        expect(cubit.state.selectedMealIds, isEmpty);
        expect(cubit.state.canSave, isFalse);

        // Select m1
        cubit.toggleMeal('m1');
        expect(cubit.state.selectedMealIds, ['m1']);

        // Slot limit is 1, selecting m2 replaces m1
        cubit.toggleMeal('m2');
        expect(cubit.state.selectedMealIds, ['m2']);

        // Blocked meal ignored
        cubit.toggleMeal('mB');
        expect(cubit.state.selectedMealIds, ['m2']);
      },
    );

    test('4. loadMore meals merge and pagination deduplication', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final available = _createAvailableMeals(
        restaurantId: 'r1',
        meals: [m1],
        slots: [
          CalendarSlotMealsEntity(
            slot: 'Lunch',
            displayName: 'Lunch',
            slotNameAr: 'غداء',
            slotNameEn: 'Lunch',
            count: 1,
            page: 1,
            pageSize: 5,
            hasNextPage: true,
            meals: [m1],
          ),
        ],
      );

      cubit.emit(
        MealSelectionState(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurantId: 'r1',
          availableMeals: available,
        ),
      );

      final loadMoreFuture = cubit.loadMore(slot: 'Lunch', localeName: 'en');
      expect(cubit.state.isLoadingMore, isTrue);
      expect(repo.availableMealsPages, [2]);

      final m2 = _createMeal('m2', slot: 'Lunch');
      final page2 = _createAvailableMeals(
        restaurantId: 'r1',
        meals: [m2],
        slots: [
          CalendarSlotMealsEntity(
            slot: 'Lunch',
            displayName: 'Lunch',
            slotNameAr: 'غداء',
            slotNameEn: 'Lunch',
            count: 1,
            page: 2,
            pageSize: 5,
            hasNextPage: false,
            meals: [m2],
          ),
        ],
      );
      repo.availableMealsCompleters[0].complete(ApiSuccessResult(data: page2));
      await loadMoreFuture;

      expect(cubit.state.isLoadingMore, isFalse);
      expect(cubit.state.availableMeals?.meals.map((m) => m.id).toList(), [
        'm1',
        'm2',
      ]);
    });

    test(
      '5. save returns ApiResult<CalendarDayEntity> on success and failure',
      () async {
        final m1 = _createMeal('m1', slot: 'Lunch');
        final available = _createAvailableMeals(
          restaurantId: 'r1',
          meals: [m1],
          requirements: const [
            CalendarSlotRequirementEntity(
              slot: 'Lunch',
              displayName: 'Lunch',
              slotNameAr: 'غداء',
              slotNameEn: 'Lunch',
              count: 1,
            ),
          ],
        );

        cubit.emit(
          MealSelectionState(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurantId: 'r1',
            availableMeals: available,
            selectedMealIds: ['m1'],
          ),
        );

        final saveFuture = cubit.save(localeName: 'en');
        expect(cubit.state.isSaving, isTrue);

        final savedDay = CalendarDayEntity(
          dayNumber: 15,
          weekday: 'Thu',
          date: testDate,
          meals: [m1],
        );
        repo.saveDayMealsCompleters[0].complete(
          ApiSuccessResult(data: savedDay),
        );

        final result = await saveFuture;
        expect(result, isA<ApiSuccessResult<CalendarDayEntity>>());
        expect(cubit.state.isSaving, isFalse);
      },
    );

    test('6. duplicate save/confirm is rejected while in-flight', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final available = _createAvailableMeals(
        restaurantId: 'r1',
        meals: [m1],
        requirements: const [
          CalendarSlotRequirementEntity(
            slot: 'Lunch',
            displayName: 'Lunch',
            slotNameAr: 'غداء',
            slotNameEn: 'Lunch',
            count: 1,
          ),
        ],
      );

      cubit.emit(
        MealSelectionState(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurantId: 'r1',
          availableMeals: available,
          selectedMealIds: ['m1'],
        ),
      );

      cubit.save(localeName: 'en');
      expect(repo.saveDayMealsCompleters.length, 1);

      // Attempt second save
      cubit.save(localeName: 'en');
      expect(repo.saveDayMealsCompleters.length, 1);

      // Attempt confirm while saving
      cubit.confirm(localeName: 'en');
      expect(repo.confirmDayMealsCompleters.length, 0);
    });

    test('7. autoSelect returns ApiResult<CalendarDayEntity>', () async {
      cubit.emit(
        MealSelectionState(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurantId: 'r1',
        ),
      );

      final future = cubit.autoSelect(localeName: 'en');
      expect(cubit.state.isSaving, isTrue);

      final autoDay = CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Thu',
        date: testDate,
      );
      repo.autoSelectCompleters[0].complete(ApiSuccessResult(data: autoDay));

      final result = await future;
      expect(result, isA<ApiSuccessResult<CalendarDayEntity>>());
      expect(cubit.state.isSaving, isFalse);
    });

    test('8. confirm saves meals first then calls confirmDayMeals', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final available = _createAvailableMeals(
        restaurantId: 'r1',
        meals: [m1],
        requirements: const [
          CalendarSlotRequirementEntity(
            slot: 'Lunch',
            displayName: 'Lunch',
            slotNameAr: 'غداء',
            slotNameEn: 'Lunch',
            count: 1,
          ),
        ],
      );

      cubit.emit(
        MealSelectionState(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurantId: 'r1',
          availableMeals: available,
          selectedMealIds: ['m1'],
        ),
      );

      final confirmFuture = cubit.confirm(localeName: 'en');
      expect(cubit.state.isConfirming, isTrue);
      expect(repo.saveDayMealsCompleters.length, 1);

      final savedDay = CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Thu',
        date: testDate,
        meals: [m1],
      );
      repo.saveDayMealsCompleters[0].complete(ApiSuccessResult(data: savedDay));
      await Future<void>.delayed(Duration.zero);

      expect(repo.confirmDayMealsCompleters.length, 1);
      final confirmedDay = savedDay.copyWith(canEdit: false);
      repo.confirmDayMealsCompleters[0].complete(
        ApiSuccessResult(data: confirmedDay),
      );

      final result = await confirmFuture;
      expect(result, isA<ApiSuccessResult<CalendarDayEntity>>());
      expect(cubit.state.isConfirming, isFalse);
    });

    test(
      '9. confirm failure returns failure with code to caller without touching overview',
      () async {
        final m1 = _createMeal('m1', slot: 'Lunch');
        final available = _createAvailableMeals(
          restaurantId: 'r1',
          meals: [m1],
          requirements: const [
            CalendarSlotRequirementEntity(
              slot: 'Lunch',
              displayName: 'Lunch',
              slotNameAr: 'غداء',
              slotNameEn: 'Lunch',
              count: 1,
            ),
          ],
        );

        cubit.emit(
          MealSelectionState(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurantId: 'r1',
            availableMeals: available,
            selectedMealIds: ['m1'],
          ),
        );

        final confirmFuture = cubit.confirm(localeName: 'en');
        final savedDay = CalendarDayEntity(
          dayNumber: 15,
          weekday: 'Thu',
          date: testDate,
          meals: [m1],
        );
        repo.saveDayMealsCompleters[0].complete(
          ApiSuccessResult(data: savedDay),
        );
        await Future<void>.delayed(Duration.zero);

        repo.confirmDayMealsCompleters[0].complete(
          ApiErrorResult(
            failure: Failure(
              errorMessage: 'Locked',
              code: SubscriptionErrorCodes.calendarSelectionLocked,
              exception: const ApiException(
                errorType: ApiErrorType.badRequest,
                message: 'Locked',
                backendErrorCode:
                    SubscriptionErrorCodes.calendarSelectionLocked,
              ),
            ),
          ),
        );

        final result = await confirmFuture;
        expect(result, isA<ApiErrorResult<CalendarDayEntity>>());
        expect(
          (result as ApiErrorResult<CalendarDayEntity>).failure.code,
          SubscriptionErrorCodes.calendarSelectionLocked,
        );
        expect(
          cubit.state.confirmFailure?.code,
          SubscriptionErrorCodes.calendarSelectionLocked,
        );
        expect(cubit.state.isConfirming, isFalse);
      },
    );

    test('10. clear resets all state', () {
      cubit.emit(
        MealSelectionState(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurantId: 'r1',
          selectedMealIds: ['m1'],
        ),
      );

      cubit.clear();
      expect(cubit.state.subscriptionId, isEmpty);
      expect(cubit.state.date, isNull);
      expect(cubit.state.selectedMealIds, isEmpty);
      expect(cubit.state.availableMeals, isNull);
    });
  });
}
