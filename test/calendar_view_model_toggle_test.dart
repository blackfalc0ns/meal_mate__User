import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'selecting another meal in a full slot replaces the previous selection',
    () async {
      SharedPreferences.setMockInitialValues({});
      final viewModel = await _calendarViewModel();

      viewModel.seed(
        CalendarState(
          availableMeals: CalendarAvailableMealsEntity(
            restaurant: null,
            meals: [
              _meal(id: 'meal-1', slot: 'lunch'),
              _meal(id: 'meal-2', slot: 'lunch'),
            ],
            slotRequirements: const [
              CalendarSlotRequirementEntity(
                slot: 'lunch',
                slotNameAr: 'الغداء',
                slotNameEn: 'Lunch',
                count: 1,
              ),
            ],
          ),
          localSelectedMealIds: const ['meal-1'],
        ),
      );

      viewModel.doIntent(const ToggleCalendarMealEvent('meal-2'));

      expect(viewModel.state.localSelectedMealIds, const ['meal-2']);
      await viewModel.close();
    },
  );

  test(
    'passes restaurant search query through the calendar view model',
    () async {
      SharedPreferences.setMockInitialValues({});
      final calendarRepository = _CalendarRepositoryFake();
      final profileRepository = _ProfileRepositoryFake();
      final sharedPreferences = await SharedPreferences.getInstance();
      final viewModel = _TestCalendarViewModel(
        GetCalendarUseCase(calendarRepository),
        GetCalendarDayUseCase(calendarRepository),
        GetCalendarRestaurantsUseCase(calendarRepository),
        SetCalendarDayRestaurantUseCase(calendarRepository),
        GetCalendarAvailableMealsUseCase(calendarRepository),
        SaveCalendarDayMealsUseCase(calendarRepository),
        AutoSelectCalendarDayUseCase(calendarRepository),
        GetCurrentCustomerSubscriptionUseCase(profileRepository),
        SharedPrefHelper(sharedPreferences),
      );

      viewModel.seed(
        CalendarState(
          subscriptionId: 'subscription-1',
          selectedDate: DateTime(2026, 9, 6),
          days: [
            CalendarDayEntity(
              dayNumber: 6,
              weekday: 'Sun',
              date: DateTime(2026, 9, 6),
            ),
          ],
        ),
      );

      viewModel.doIntent(
        const LoadCalendarRestaurantsEvent(localeName: 'en', query: 'Healthy'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(calendarRepository.lastRestaurantQuery, 'Healthy');
      await viewModel.close();
    },
  );
}

Future<_TestCalendarViewModel> _calendarViewModel() async {
  final calendarRepository = _CalendarRepositoryFake();
  final profileRepository = _ProfileRepositoryFake();
  final sharedPreferences = await SharedPreferences.getInstance();

  return _TestCalendarViewModel(
    GetCalendarUseCase(calendarRepository),
    GetCalendarDayUseCase(calendarRepository),
    GetCalendarRestaurantsUseCase(calendarRepository),
    SetCalendarDayRestaurantUseCase(calendarRepository),
    GetCalendarAvailableMealsUseCase(calendarRepository),
    SaveCalendarDayMealsUseCase(calendarRepository),
    AutoSelectCalendarDayUseCase(calendarRepository),
    GetCurrentCustomerSubscriptionUseCase(profileRepository),
    SharedPrefHelper(sharedPreferences),
  );
}

CalendarMealEntity _meal({required String id, required String slot}) {
  return CalendarMealEntity(
    id: id,
    slot: slot,
    mealType: slot,
    title: id,
    time: '',
    calories: '',
    protein: '',
    carbs: '',
    fat: '',
    ingredients: const [],
    imageAsset: '',
    actionLabel: '',
  );
}

class _TestCalendarViewModel extends CalendarViewModel {
  _TestCalendarViewModel(
    super.getCalendarUseCase,
    super.getCalendarDayUseCase,
    super.getRestaurantsUseCase,
    super.setDayRestaurantUseCase,
    super.getAvailableMealsUseCase,
    super.saveDayMealsUseCase,
    super.autoSelectDayUseCase,
    super.getCurrentCustomerSubscriptionUseCase,
    super.sharedPrefHelper,
  );

  void seed(CalendarState state) => emit(state);
}

class _CalendarRepositoryFake implements CalendarRepository {
  String? lastRestaurantQuery;

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<CalendarRestaurantOptionEntity>>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
  }) {
    lastRestaurantQuery = query;
    return Future.value(ApiSuccessResult(data: []));
  }

  @override
  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    throw UnimplementedError();
  }
}

class _ProfileRepositoryFake implements ProfileRepository {
  @override
  Future<ApiResult<void>> deleteCustomerProfileImage() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCurrentEntity>>
  getCurrentCustomerSubscription() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingEntity>> getProfileBilling() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) {
    throw UnimplementedError();
  }
}
