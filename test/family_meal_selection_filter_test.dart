import 'support/family_meal_selection_view_model_factory.dart';
import 'support/family_calendar_view_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';

void main() {
  test(
    'selecting a meal category requests its slot from the backend',
    () async {
      final repository = _RecordingCalendarRepository();
      final calendar = createFamilyCalendarViewModel();
      addTearDown(calendar.close);
      final viewModel = createFamilyMealSelectionViewModel(
        calendar: calendar,

        subscriptionId: 'subscription-1',

        date: DateTime(2026, 9, 15),

        memberName: 'Member',

        getAvailableMealsUseCase: GetCalendarAvailableMealsUseCase(repository),

        setDayRestaurantUseCase: SetCalendarDayRestaurantUseCase(repository),
      );
      addTearDown(viewModel.close);

      final date = DateTime(2026, 9, 15);
      calendar.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            subscriptionId: 'subscription-1',
            displayName: 'Member',
            date: date,
          ),
          localeName: 'en',
        ),
      );
      viewModel.doIntent(
        const SelectFamilyRestaurantEvent(
          restaurant: _restaurant,
          localeName: 'en',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      repository.requestedSlots.clear();
      const cases = <(int, String?)>[
        (0, null),
        (1, 'breakfast'),
        (2, 'lunch'),
        (3, 'dinner'),
        (4, 'snack'),
      ];

      for (final (index, expectedSlot) in cases) {
        viewModel.doIntent(
          SelectFamilyMealCategoryEvent(index: index, localeName: 'en'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(repository.requestedSlots.last, expectedSlot);
        expect(viewModel.state.selectedCategoryIndex, index);
      }
    },
  );

  test(
    'selects the required meals in one slot and sends all of them',
    () async {
      final repository = _RecordingCalendarRepository();
      final calendar = createFamilyCalendarViewModel();
      addTearDown(calendar.close);
      final viewModel = createFamilyMealSelectionViewModel(
        calendar: calendar,

        subscriptionId: 'subscription-1',

        date: DateTime(2026, 9, 15),

        memberName: 'Member',

        getAvailableMealsUseCase: GetCalendarAvailableMealsUseCase(repository),

        saveDayMealsUseCase: SaveCalendarDayMealsUseCase(repository),

        setDayRestaurantUseCase: SetCalendarDayRestaurantUseCase(repository),
      );
      addTearDown(viewModel.close);

      calendar.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            subscriptionId: 'subscription-1',
            displayName: 'Member',
            date: DateTime(2026, 9, 15),
          ),
          localeName: 'en',
        ),
      );
      viewModel.doIntent(
        const SelectFamilyRestaurantEvent(
          restaurant: _restaurant,
          localeName: 'en',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(repository.requestOrder.take(2), ['restaurant', 'meals']);

      for (final meal in repository.availableMeals) {
        viewModel.doIntent(SelectMealForSlotEvent(meal: meal, slot: meal.slot));
      }

      expect(viewModel.state.selectedMealsForDay.map((meal) => meal.id), [
        'meal-1',
        'meal-2',
        'meal-3',
      ]);
      expect(viewModel.state.selectedNutritionTotals.calories, 1200);
      expect(viewModel.state.selectedNutritionTotals.proteinG, 90);
      expect(viewModel.state.selectedNutritionTotals.carbsG, 120);
      expect(viewModel.state.selectedNutritionTotals.fatG, 30);

      viewModel.doIntent(const SaveFamilyDayMealsEvent(localeName: 'en'));
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedMeals.map((meal) => meal.id), [
        'meal-1',
        'meal-2',
        'meal-3',
      ]);
    },
  );

  test('does not load meals when setting the restaurant fails', () async {
    final repository = _RecordingCalendarRepository(failSetRestaurant: true);
    final calendar = createFamilyCalendarViewModel();
    addTearDown(calendar.close);
    final viewModel = createFamilyMealSelectionViewModel(
      calendar: calendar,

      subscriptionId: 'subscription-1',

      date: DateTime(2026, 9, 15),

      memberName: 'Member',

      getAvailableMealsUseCase: GetCalendarAvailableMealsUseCase(repository),

      setDayRestaurantUseCase: SetCalendarDayRestaurantUseCase(repository),
    );
    addTearDown(viewModel.close);

    calendar.doIntent(
      InitFamilyCalendarEvent(
        args: FamilyMemberCalendarArgs(
          subscriptionId: 'subscription-1',
          displayName: 'Member',
          date: DateTime(2026, 9, 15),
        ),
        localeName: 'en',
      ),
    );
    viewModel.doIntent(
      const SelectFamilyRestaurantEvent(
        restaurant: _restaurant,
        localeName: 'en',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(repository.requestOrder, ['restaurant']);
    expect(viewModel.state.availableMeals, isNull);
    expect(viewModel.state.availableMealsFailure?.code, 'restaurant.failed');
  });

  test('hydrates selected meals from backend isSelected values', () async {
    final repository = _RecordingCalendarRepository(returnSelectedMeals: true);
    final calendar = createFamilyCalendarViewModel();
    addTearDown(calendar.close);
    final viewModel = createFamilyMealSelectionViewModel(
      calendar: calendar,

      subscriptionId: 'subscription-1',

      date: DateTime(2026, 9, 15),

      memberName: 'Member',

      getAvailableMealsUseCase: GetCalendarAvailableMealsUseCase(repository),

      setDayRestaurantUseCase: SetCalendarDayRestaurantUseCase(repository),
    );
    addTearDown(viewModel.close);

    calendar.doIntent(
      InitFamilyCalendarEvent(
        args: FamilyMemberCalendarArgs(
          subscriptionId: 'subscription-1',
          displayName: 'Member',
          date: DateTime(2026, 9, 15),
        ),
        localeName: 'en',
      ),
    );
    viewModel.doIntent(
      const SelectFamilyRestaurantEvent(
        restaurant: _restaurant,
        localeName: 'en',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.selectedMealsForDay, hasLength(3));
    expect(
      viewModel.state.selectedMealsForDay.every((meal) => meal.selected),
      isTrue,
    );
  });
}

const _restaurant = CalendarRestaurantOptionEntity(
  id: 'restaurant-1',
  name: 'Restaurant',
  description: '',
  mealCount: 2,
  rating: '4.5',
  logoType: CalendarRestaurantLogoType.healthyBowl,
);

class _RecordingCalendarRepository implements CalendarRepository {
  _RecordingCalendarRepository({
    this.failSetRestaurant = false,
    this.returnSelectedMeals = false,
  });

  final bool failSetRestaurant;
  final bool returnSelectedMeals;
  final List<String?> requestedSlots = [];
  final List<String> requestOrder = [];
  List<CalendarMealEntity> savedMeals = const [];

  final List<CalendarMealEntity> availableMeals = [
    _meal('meal-1'),
    _meal('meal-2'),
    _meal('meal-3'),
  ];

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
    requestOrder.add('meals');
    requestedSlots.add(slot);
    return ApiSuccessResult(
      data: CalendarAvailableMealsEntity(
        restaurant: null,
        meals: [
          _meal('meal-1').copyWith(selected: returnSelectedMeals),
          _meal('meal-2').copyWith(selected: returnSelectedMeals),
          _meal('meal-3').copyWith(selected: returnSelectedMeals),
        ],
        slotRequirements: const [
          CalendarSlotRequirementEntity(
            slot: 'lunch',
            displayName: 'Lunch',
            slotNameAr: 'الغداء',
            slotNameEn: 'Lunch',
            count: 3,
          ),
        ],
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
    requestOrder.add('restaurant');
    if (failSetRestaurant) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Could not set restaurant',
          code: 'restaurant.failed',
        ),
      );
    }
    return ApiSuccessResult(
      data: CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Tuesday',
        date: DateTime.parse(date),
        restaurantId: restaurantId,
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
    savedMeals = List.of(meals);
    return ApiSuccessResult(
      data: CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Tuesday',
        date: DateTime(2026, 9, 15),
        meals: meals,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CalendarMealEntity _meal(String id) => CalendarMealEntity(
  id: id,
  slot: 'lunch',
  mealType: 'Lunch',
  title: id,
  time: '',
  calories: '400',
  protein: '30',
  carbs: '40',
  fat: '10',
  ingredients: const [],
  imageAsset: '',
  actionLabel: '',
);
