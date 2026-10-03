import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
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
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ControllableCalendarRepo implements CalendarRepository {
  final List<Completer<ApiResult<List<CalendarRestaurantOptionEntity>>>>
  restaurantCompleters = [];
  final List<String?> restaurantQueries = [];

  final List<Completer<ApiResult<CalendarDayEntity>>>
  setDayRestaurantCompleters = [];
  final List<String> setDayRestaurantIds = [];

  final List<Completer<ApiResult<CalendarAvailableMealsEntity>>>
  availableMealsCompleters = [];
  final List<String> availableMealsRestaurantIds = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> getDayCompleters = [];
  final List<String> getDayDates = [];

  @override
  Future<ApiResult<List<CalendarRestaurantOptionEntity>>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
  }) {
    restaurantQueries.add(query);
    final completer =
        Completer<ApiResult<List<CalendarRestaurantOptionEntity>>>();
    restaurantCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    setDayRestaurantIds.add(restaurantId);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    setDayRestaurantCompleters.add(completer);
    return completer.future;
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
  }) {
    availableMealsRestaurantIds.add(restaurantId);
    final completer = Completer<ApiResult<CalendarAvailableMealsEntity>>();
    availableMealsCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    getDayDates.add(date);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    getDayCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) => throw UnimplementedError();
}

class _ProfileRepoFake implements ProfileRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _TestViewModel extends CalendarViewModel {
  _TestViewModel(
    super.getCalendarUseCase,
    super.getCalendarDayUseCase,
    super.getRestaurantsUseCase,
    super.setDayRestaurantUseCase,
    super.getAvailableMealsUseCase,
    super.saveDayMealsUseCase,
    super.autoSelectDayUseCase,
    super.confirmDayMealsUseCase,
    super.getCurrentCustomerSubscriptionUseCase,
    super.sharedPrefHelper,
  );

  void seed(CalendarState s) => emit(s);
}

Future<_TestViewModel> _createTestViewModel(
  _ControllableCalendarRepo repo,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final profileRepo = _ProfileRepoFake();
  return _TestViewModel(
    GetCalendarUseCase(repo),
    GetCalendarDayUseCase(repo),
    GetCalendarRestaurantsUseCase(repo),
    SetCalendarDayRestaurantUseCase(repo),
    GetCalendarAvailableMealsUseCase(repo),
    SaveCalendarDayMealsUseCase(repo),
    AutoSelectCalendarDayUseCase(repo),
    ConfirmCalendarDayMealsUseCase(repo),
    GetCurrentCustomerSubscriptionUseCase(profileRepo),
    SharedPrefHelper(prefs),
  );
}

CalendarDayEntity _testDay(
  int day, {
  bool isEditable = true,
  String? restaurantId,
}) {
  final futureDate = DateTime.now().add(Duration(days: day + 5));
  return CalendarDayEntity(
    dayNumber: day,
    weekday: 'Day$day',
    date: DateTime(futureDate.year, futureDate.month, futureDate.day),
    canEdit: isEditable,
    restaurantId: restaurantId,
  );
}

CalendarRestaurantOptionEntity _testOption(String id, String name) {
  return CalendarRestaurantOptionEntity(
    id: id,
    name: name,
    description: 'Desc',
    mealCount: 5,
    rating: '4.5',
    logoType: CalendarRestaurantLogoType.healthyBowl,
  );
}

CalendarRestaurantEntity _testRestaurant(String id, String name) {
  return CalendarRestaurantEntity(
    id: id,
    name: name,
    category: 'Healthy',
    rating: '4.5',
    deliveryDuration: '30m',
    deliveryWindow: '12:00 - 13:00',
  );
}

CalendarMealEntity _testMeal(String id, String slot) {
  return CalendarMealEntity(
    id: id,
    slot: slot,
    mealType: slot,
    title: id,
    time: '12:00',
    calories: '500',
    protein: '30g',
    carbs: '40g',
    fat: '10g',
    ingredients: const [],
    imageAsset: '',
    actionLabel: 'Select',
  );
}

CalendarSlotMealsEntity _testSlotMeals(
  String slot,
  List<CalendarMealEntity> meals, {
  bool hasNextPage = false,
  int page = 1,
}) {
  return CalendarSlotMealsEntity(
    slot: slot,
    displayName: slot,
    slotNameAr: slot,
    slotNameEn: slot,
    count: 1,
    page: page,
    pageSize: 5,
    hasNextPage: hasNextPage,
    meals: meals,
  );
}

void main() {
  test(
    'restaurant search race: earlier query completing after later query does not overwrite',
    () async {
      final repo = _ControllableCalendarRepo();
      final viewModel = await _createTestViewModel(repo);

      final day = _testDay(1);
      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          selectedDate: day.date,
          days: [day],
        ),
      );

      // Dispatch query 'a', then query 'av'
      viewModel.doIntent(
        const LoadCalendarRestaurantsEvent(localeName: 'en', query: 'a'),
      );
      viewModel.doIntent(
        const LoadCalendarRestaurantsEvent(localeName: 'en', query: 'av'),
      );

      expect(repo.restaurantCompleters, hasLength(2));

      // Complete 'av' first with 'new'
      repo.restaurantCompleters[1].complete(
        ApiSuccessResult(data: [_testOption('new', 'New Restaurant')]),
      );
      await pumpEventQueue();

      expect(viewModel.state.restaurants.map((item) => item.id), ['new']);

      // Complete 'a' second with 'old'
      repo.restaurantCompleters[0].complete(
        ApiSuccessResult(data: [_testOption('old', 'Old Restaurant')]),
      );
      await pumpEventQueue();

      // Assert 'new' is retained and loading is false
      expect(viewModel.state.restaurants.map((item) => item.id), ['new']);
      expect(viewModel.state.isRestaurantsLoading, isFalse);

      await viewModel.close();
    },
  );

  test(
    'available-meals race: selecting restaurant A then B, A completing later does not overwrite B',
    () async {
      final repo = _ControllableCalendarRepo();
      final viewModel = await _createTestViewModel(repo);

      final day = _testDay(1);
      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          selectedDate: day.date,
          days: [day],
        ),
      );

      final restA = _testOption('rest-a', 'Restaurant A');
      final restB = _testOption('rest-b', 'Restaurant B');

      // Select A, then select B
      viewModel.doIntent(
        SelectCalendarRestaurantEvent(restaurant: restA, localeName: 'en'),
      );
      viewModel.doIntent(
        SelectCalendarRestaurantEvent(restaurant: restB, localeName: 'en'),
      );

      expect(repo.setDayRestaurantCompleters, hasLength(2));

      // Complete setDayRestaurant for B
      repo.setDayRestaurantCompleters[1].complete(
        ApiSuccessResult(data: _testDay(1, restaurantId: 'rest-b')),
      );
      await pumpEventQueue();

      // Complete available meals for B
      expect(repo.availableMealsCompleters, hasLength(1));
      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(
          data: CalendarAvailableMealsEntity(
            restaurant: _testRestaurant('rest-b', 'Restaurant B'),
            meals: [_testMeal('meal-b', 'lunch')],
            slotRequirements: const [],
          ),
        ),
      );
      await pumpEventQueue();

      expect(viewModel.state.availableMeals?.restaurant?.id, 'rest-b');

      // Complete setDayRestaurant for A
      repo.setDayRestaurantCompleters[0].complete(
        ApiSuccessResult(data: _testDay(1, restaurantId: 'rest-a')),
      );
      await pumpEventQueue();

      // If A triggers loadAvailableMeals, complete it
      if (repo.availableMealsCompleters.length > 1) {
        repo.availableMealsCompleters[1].complete(
          ApiSuccessResult(
            data: CalendarAvailableMealsEntity(
              restaurant: _testRestaurant('rest-a', 'Restaurant A'),
              meals: [_testMeal('meal-a', 'lunch')],
              slotRequirements: const [],
            ),
          ),
        );
        await pumpEventQueue();
      }

      expect(viewModel.state.availableMeals?.restaurant?.id, 'rest-b');
      expect(viewModel.state.isAvailableMealsLoading, isFalse);

      await viewModel.close();
    },
  );

  test(
    'day-switch race: selecting day 1 then day 2, day 1 completing later does not overwrite day 2',
    () async {
      final repo = _ControllableCalendarRepo();
      final viewModel = await _createTestViewModel(repo);

      final day1 = _testDay(1);
      final day2 = _testDay(2);
      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          selectedDate: day1.date,
          days: [day1, day2],
        ),
      );

      viewModel.doIntent(SelectCalendarDayEvent(day: day1, localeName: 'en'));
      viewModel.doIntent(SelectCalendarDayEvent(day: day2, localeName: 'en'));

      expect(repo.getDayCompleters, hasLength(2));

      // Complete day 2 first
      repo.getDayCompleters[1].complete(
        ApiSuccessResult(data: day2.copyWith(hasMeals: true)),
      );
      await pumpEventQueue();

      // Complete day 1 second
      repo.getDayCompleters[0].complete(
        ApiSuccessResult(data: day1.copyWith(hasMeals: true)),
      );
      await pumpEventQueue();

      expect(viewModel.state.selectedDate, day2.date);
      expect(viewModel.state.selectedDay?.date, day2.date);

      await viewModel.close();
    },
  );

  test(
    'pagination-context race: load-more for old context does not merge after context change',
    () async {
      final repo = _ControllableCalendarRepo();
      final viewModel = await _createTestViewModel(repo);

      final day1 = _testDay(1, restaurantId: 'rest-a');
      final day2 = _testDay(2, restaurantId: 'rest-b');

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          selectedDate: day1.date,
          days: [day1, day2],
          availableMeals: CalendarAvailableMealsEntity(
            restaurant: _testRestaurant('rest-a', 'Restaurant A'),
            slots: [
              _testSlotMeals(
                'lunch',
                [_testMeal('meal-1', 'lunch')],
                hasNextPage: true,
                page: 1,
              ),
            ],
            meals: [_testMeal('meal-1', 'lunch')],
            slotRequirements: const [],
          ),
        ),
      );

      // Start load-more for lunch
      viewModel.doIntent(
        const LoadMoreCalendarMealsEvent(slot: 'lunch', localeName: 'en'),
      );
      expect(repo.availableMealsCompleters, hasLength(1));

      // Now switch day to day2
      viewModel.doIntent(SelectCalendarDayEvent(day: day2, localeName: 'en'));
      await pumpEventQueue();

      // Now complete the old page request
      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(
          data: CalendarAvailableMealsEntity(
            restaurant: _testRestaurant('rest-a', 'Restaurant A'),
            slots: [
              _testSlotMeals(
                'lunch',
                [_testMeal('meal-2', 'lunch')],
                hasNextPage: false,
                page: 2,
              ),
            ],
            meals: [_testMeal('meal-2', 'lunch')],
            slotRequirements: const [],
          ),
        ),
      );
      await pumpEventQueue();

      // Old page must not merge into the new day's availableMeals
      expect(viewModel.state.availableMeals, isNull);
      expect(viewModel.state.isLoadingMoreMeals, isFalse);

      await viewModel.close();
    },
  );
}
