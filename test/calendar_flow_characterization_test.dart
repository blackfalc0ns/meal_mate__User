import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
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
  final List<Completer<ApiResult<CalendarSubscriptionEntity>>>
  getCalendarCompleters = [];
  final List<String> getCalendarSubscriptionIds = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> getDayCompleters = [];
  final List<String> getDayDates = [];

  final List<Completer<ApiResult<List<CalendarRestaurantOptionEntity>>>>
  restaurantCompleters = [];
  final List<String?> restaurantQueries = [];

  final List<Completer<ApiResult<CalendarDayEntity>>>
  setDayRestaurantCompleters = [];
  final List<String> setDayRestaurantIds = [];

  final List<Completer<ApiResult<CalendarAvailableMealsEntity>>>
  availableMealsCompleters = [];
  final List<String> availableMealsRestaurantIds = [];
  final List<int?> availableMealsPages = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> saveDayMealsCompleters =
      [];
  final List<List<CalendarMealEntity>> saveDayMealsList = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> autoSelectCompleters = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> confirmDayMealsCompleters =
      [];
  final List<String> confirmDayMealsDates = [];

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) {
    getCalendarSubscriptionIds.add(subscriptionId);
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
    getDayDates.add(date);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    getDayCompleters.add(completer);
    return completer.future;
  }

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
    confirmDayMealsDates.add(date);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    confirmDayMealsCompleters.add(completer);
    return completer.future;
  }
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

Future<_TestViewModel> _createViewModel(_ControllableCalendarRepo repo) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return _TestViewModel(
    GetCalendarUseCase(repo),
    GetCalendarDayUseCase(repo),
    GetCalendarRestaurantsUseCase(repo),
    SetCalendarDayRestaurantUseCase(repo),
    GetCalendarAvailableMealsUseCase(repo),
    SaveCalendarDayMealsUseCase(repo),
    AutoSelectCalendarDayUseCase(repo),
    ConfirmCalendarDayMealsUseCase(repo),
    GetCurrentCustomerSubscriptionUseCase(_ProfileRepoFake()),
    SharedPrefHelper(prefs),
  );
}

CalendarDayEntity _createDay(
  int dayNumber, {
  bool isEditable = true,
  String? restaurantId,
  String? restaurantName,
  List<CalendarMealEntity> meals = const [],
  List<String> selectedMealIds = const [],
  bool isLocked = false,
}) {
  final futureDate = DateTime.now().add(Duration(days: dayNumber + 5));
  final date = DateTime(futureDate.year, futureDate.month, futureDate.day);
  return CalendarDayEntity(
    dayNumber: dayNumber,
    weekday: 'Day$dayNumber',
    date: date,
    canEdit: isEditable,
    isLocked: isLocked,
    restaurantId: restaurantId,
    restaurant: restaurantId != null
        ? CalendarRestaurantEntity(
            id: restaurantId,
            name: restaurantName ?? 'Rest $restaurantId',
            category: 'Healthy',
            rating: '4.5',
            deliveryDuration: '30m',
            deliveryWindow: '12:00 - 1:00',
          )
        : null,
    meals: meals,
    selectedMealIds: selectedMealIds,
    status: isLocked ? 'locked' : (isEditable ? 'open' : 'frozen'),
  );
}

CalendarRestaurantOptionEntity _createOption(String id, String name) {
  return CalendarRestaurantOptionEntity(
    id: id,
    name: name,
    description: 'Desc',
    mealCount: 5,
    rating: '4.5',
    logoType: CalendarRestaurantLogoType.healthyBowl,
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

CalendarMealEntity _createMeal(
  String id, {
  required String slot,
  String? blockReason,
}) {
  return CalendarMealEntity(
    id: id,
    title: 'Meal $id',
    description: 'Description $id',
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ControllableCalendarRepo repo;
  late _TestViewModel viewModel;

  setUp(() async {
    repo = _ControllableCalendarRepo();
    viewModel = await _createViewModel(repo);
  });

  tearDown(() async {
    await viewModel.close();
  });

  group('Calendar flow characterization tests', () {
    test('1. initial load: loads days and fetches selected day details', () async {
      final day1 = _createDay(1);
      final day2 = _createDay(2);
      final subscription = CalendarSubscriptionEntity(
        subscriptionId: 'sub-1',
        days: [day1, day2],
      );

      viewModel.doIntent(
        const LoadCalendarEvent(subscriptionId: 'sub-1', localeName: 'en'),
      );
      expect(viewModel.state.isCalendarLoading, isTrue);
      expect(repo.getCalendarSubscriptionIds, ['sub-1']);

      repo.getCalendarCompleters[0].complete(
        ApiSuccessResult(data: subscription),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isCalendarLoading, isFalse);
      expect(viewModel.state.days.length, 2);
      expect(viewModel.state.selectedDate, day1.date);
      expect(repo.getDayDates, [DateFormat('yyyy-MM-dd').format(day1.date!)]);

      final detailedDay1 = _createDay(
        1,
        restaurantId: 'rest-1',
        restaurantName: 'Green Bowl',
      );
      repo.getDayCompleters[0].complete(ApiSuccessResult(data: detailedDay1));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.restaurant?.name, 'Green Bowl');
      expect(viewModel.state.isSelectedDayLoading, isFalse);
    });

    test('2. day switch: updates selectedDate and fetches day details when meals empty', () async {
      final day1 = _createDay(1, restaurantId: 'r1');
      final day2 = _createDay(2, restaurantId: 'r2');
      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day1, day2],
          selectedDate: day1.date,
        ),
      );

      viewModel.doIntent(
        SelectCalendarDayEvent(day: day2, localeName: 'en'),
      );

      expect(viewModel.state.selectedDate, day2.date);
      expect(viewModel.state.isSelectedDayLoading, isTrue);
      expect(repo.getDayDates, [DateFormat('yyyy-MM-dd').format(day2.date!)]);

      final detailedDay2 = _createDay(
        2,
        restaurantId: 'r2',
        restaurantName: 'Salad Bar',
      );
      repo.getDayCompleters[0].complete(ApiSuccessResult(data: detailedDay2));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.restaurant?.name, 'Salad Bar');
      expect(viewModel.state.isSelectedDayLoading, isFalse);
    });

    test('3. restaurant selection followed by meal load', () async {
      final day1 = _createDay(1);
      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day1],
          selectedDate: day1.date,
        ),
      );

      final option = _createOption('r-100', 'Power Eats');
      viewModel.doIntent(
        SelectCalendarRestaurantEvent(restaurant: option, localeName: 'en'),
      );

      expect(viewModel.state.isAvailableMealsLoading, isTrue);
      expect(repo.setDayRestaurantIds, ['r-100']);

      final updatedDay = _createDay(
        1,
        restaurantId: 'r-100',
        restaurantName: 'Power Eats',
      );
      repo.setDayRestaurantCompleters[0].complete(
        ApiSuccessResult(data: updatedDay),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.restaurantId, 'r-100');
      expect(repo.availableMealsRestaurantIds, ['r-100']);

      final mealsEntity = _createAvailableMeals(
        restaurantId: 'r-100',
        meals: [_createMeal('m-1', slot: 'Lunch')],
      );
      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(data: mealsEntity),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isAvailableMealsLoading, isFalse);
      expect(viewModel.state.availableMeals?.meals.first.id, 'm-1');
    });

    test('4. meal toggle and slot replacement behavior', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final m2 = _createMeal('m2', slot: 'Lunch');
      final mBlocked = _createMeal('mB', slot: 'Lunch', blockReason: 'Unavailable');

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

      viewModel.seed(
        CalendarState(
          availableMeals: available,
          localSelectedMealIds: const [],
        ),
      );

      // Toggle m1 -> selected
      viewModel.doIntent(const ToggleCalendarMealEvent('m1'));
      expect(viewModel.state.localSelectedMealIds, ['m1']);

      // Toggle m1 again -> deselected
      viewModel.doIntent(const ToggleCalendarMealEvent('m1'));
      expect(viewModel.state.localSelectedMealIds, isEmpty);

      // Select m1
      viewModel.doIntent(const ToggleCalendarMealEvent('m1'));
      expect(viewModel.state.localSelectedMealIds, ['m1']);

      // Slot limit is 1, select m2 -> replaces m1
      viewModel.doIntent(const ToggleCalendarMealEvent('m2'));
      expect(viewModel.state.localSelectedMealIds, ['m2']);

      // Blocked meal should be ignored
      viewModel.doIntent(const ToggleCalendarMealEvent('mB'));
      expect(viewModel.state.localSelectedMealIds, ['m2']);
    });

    test('5. load-more meals merge', () async {
      final day = _createDay(1, restaurantId: 'r1');
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

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
          availableMeals: available,
        ),
      );

      viewModel.doIntent(
        const LoadMoreCalendarMealsEvent(slot: 'Lunch', localeName: 'en'),
      );
      expect(viewModel.state.isLoadingMoreMeals, isTrue);
      expect(repo.availableMealsPages, [2]);

      final m2 = _createMeal('m2', slot: 'Lunch');
      final morePage = _createAvailableMeals(
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
      repo.availableMealsCompleters[0].complete(
        ApiSuccessResult(data: morePage),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoadingMoreMeals, isFalse);
      expect(viewModel.state.availableMeals?.meals.map((m) => m.id).toList(), [
        'm1',
        'm2',
      ]);
    });

    test('6. save success increments saveSuccessCount and replaces day', () async {
      final day = _createDay(1, restaurantId: 'r1');
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

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
          availableMeals: available,
          localSelectedMealIds: ['m1'],
        ),
      );

      viewModel.doIntent(const SaveCalendarDayMealsEvent(localeName: 'en'));
      expect(viewModel.state.isSaving, isTrue);

      final savedDay = _createDay(
        1,
        restaurantId: 'r1',
        meals: [m1],
        selectedMealIds: ['m1'],
      );
      repo.saveDayMealsCompleters[0].complete(
        ApiSuccessResult(data: savedDay),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isSaving, isFalse);
      expect(viewModel.state.saveSuccessCount, 1);
      expect(viewModel.state.availableMeals, isNull);
      expect(viewModel.state.selectedDay?.meals.first.id, 'm1');
    });

    test('7. confirm success updates day to non-editable and increments confirmSuccessCount', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final day = _createDay(
        1,
        restaurantId: 'r1',
        meals: [m1],
        selectedMealIds: ['m1'],
      );

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
        ),
      );

      viewModel.doIntent(const ConfirmCalendarDayMealsEvent(localeName: 'en'));
      expect(viewModel.state.isConfirming, isTrue);

      final confirmedDay = day.copyWith(
        canEdit: false,
        status: 'SentToRestaurant',
      );
      repo.confirmDayMealsCompleters[0].complete(
        ApiSuccessResult(data: confirmedDay),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isConfirming, isFalse);
      expect(viewModel.state.confirmSuccessCount, 1);
      expect(viewModel.state.selectedDay?.isEditable, isFalse);
    });

    test('8. selection-locked failure marks day as locked and non-editable', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final day = _createDay(
        1,
        restaurantId: 'r1',
        meals: [m1],
        selectedMealIds: ['m1'],
      );

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
        ),
      );

      viewModel.doIntent(const ConfirmCalendarDayMealsEvent(localeName: 'en'));
      expect(viewModel.state.isConfirming, isTrue);

      repo.confirmDayMealsCompleters[0].complete(
        ApiErrorResult(
          failure: Failure(
            errorMessage: 'Locked',
            code: SubscriptionErrorCodes.calendarSelectionLocked,
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Locked',
              backendErrorCode: SubscriptionErrorCodes.calendarSelectionLocked,
            ),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isConfirming, isFalse);
      expect(
        viewModel.state.confirmFailure?.code,
        SubscriptionErrorCodes.calendarSelectionLocked,
      );
      expect(viewModel.state.selectedDay?.isLocked, isTrue);
      expect(viewModel.state.selectedDay?.isEditable, isFalse);
    });

    test('9. day-unavailable triggers calendar reload', () async {
      final m1 = _createMeal('m1', slot: 'Lunch');
      final day = _createDay(
        1,
        restaurantId: 'r1',
        meals: [m1],
        selectedMealIds: ['m1'],
      );

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
        ),
      );

      viewModel.doIntent(const ConfirmCalendarDayMealsEvent(localeName: 'en'));

      repo.confirmDayMealsCompleters[0].complete(
        ApiErrorResult(
          failure: Failure(
            errorMessage: 'Unavailable',
            code: SubscriptionErrorCodes.calendarDayUnavailable,
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Unavailable',
              backendErrorCode: SubscriptionErrorCodes.calendarDayUnavailable,
            ),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isConfirming, isFalse);
      expect(repo.getCalendarSubscriptionIds, contains('sub-1'));
    });

    test('10. duplicate mutation rejection: saving while already saving is ignored', () async {
      final day = _createDay(1, restaurantId: 'r1');
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

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day],
          selectedDate: day.date,
          availableMeals: available,
          localSelectedMealIds: ['m1'],
        ),
      );

      viewModel.doIntent(const SaveCalendarDayMealsEvent(localeName: 'en'));
      expect(repo.saveDayMealsCompleters.length, 1);

      // Trigger confirm/save while already saving
      viewModel.doIntent(const ConfirmCalendarDayMealsEvent(localeName: 'en'));
      expect(repo.saveDayMealsCompleters.length, 1);
      expect(repo.confirmDayMealsCompleters.length, 0);
    });

    test('11. stale response rejection: stale day request ignored after switching day', () async {
      final day1 = _createDay(1);
      final day2 = _createDay(2);

      viewModel.seed(
        CalendarState(
          subscriptionId: 'sub-1',
          days: [day1, day2],
          selectedDate: day1.date,
        ),
      );

      viewModel.doIntent(SelectCalendarDayEvent(day: day1, localeName: 'en'));
      viewModel.doIntent(SelectCalendarDayEvent(day: day2, localeName: 'en'));

      expect(repo.getDayCompleters.length, 2);

      // Completing day1 late
      final detailedDay1 = _createDay(
        1,
        restaurantId: 'r1',
        restaurantName: 'Old Day Restaurant',
      );
      repo.getDayCompleters[0].complete(
        ApiSuccessResult(data: detailedDay1),
      );
      await Future<void>.delayed(Duration.zero);

      // Should still be on day2 and day1 restaurant name not applied to selectedDay
      expect(viewModel.state.selectedDate, day2.date);

      // Completing day2
      final detailedDay2 = _createDay(
        2,
        restaurantId: 'r2',
        restaurantName: 'New Day Restaurant',
      );
      repo.getDayCompleters[1].complete(
        ApiSuccessResult(data: detailedDay2),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedDay?.restaurant?.name, 'New Day Restaurant');
    });
  });
}
