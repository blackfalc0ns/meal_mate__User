import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
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
                displayName: 'Lunch',
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

  test('saving selected meals does not auto-complete the day', () async {
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
    final serviceDate = DateTime.now().add(const Duration(days: 10));
    final meal = _meal(id: 'meal-1', slot: 'lunch');
    viewModel.seed(
      CalendarState(
        subscriptionId: 'subscription-1',
        selectedDate: serviceDate,
        days: [
          CalendarDayEntity(
            dayNumber: serviceDate.day,
            weekday: 'Mon',
            date: serviceDate,
            canEdit: true,
          ),
        ],
        availableMeals: CalendarAvailableMealsEntity(
          restaurant: null,
          meals: [meal],
          requiredCount: 1,
          slotRequirements: const [
            CalendarSlotRequirementEntity(
              slot: 'lunch',
              displayName: 'Lunch',
              slotNameAr: 'الغداء',
              slotNameEn: 'Lunch',
              count: 1,
            ),
          ],
        ),
        localSelectedMealIds: const ['meal-1'],
      ),
    );

    viewModel.doIntent(const SaveCalendarDayMealsEvent(localeName: 'en'));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(calendarRepository.saveCalls, 1);
    expect(calendarRepository.autoSelectCalls, 0);
    expect(viewModel.state.saveSuccessCount, 1);
    await viewModel.close();
  });

  test('selecting an empty editable day loads its details', () async {
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
    final date = DateTime(2026, 9, 8);
    final emptyDay = CalendarDayEntity(
      dayNumber: date.day,
      weekday: 'Tue',
      date: date,
      hasMeals: false,
      canEdit: true,
    );
    viewModel.seed(
      CalendarState(subscriptionId: 'subscription-1', days: [emptyDay]),
    );

    viewModel.doIntent(SelectCalendarDayEvent(day: emptyDay, localeName: 'en'));
    await Future<void>.delayed(Duration.zero);

    expect(calendarRepository.getDayCalls, 1);
    expect(viewModel.state.selectedDate, date);
    await viewModel.close();
  });

  test('deserializes calendar available meals JSON with slots and pagination', () {
    final json = <String, dynamic>{
      "restaurantId": "8ff16c1f-70ca-42f9-ae42-3c803da87744",
      "nameAr": "جرين بول",
      "logoUrl":
          "https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/logo-green-bowl.png",
      "serviceDate": "2026-09-07",
      "requiredCount": 2,
      "filledCount": 0,
      "slots": [
        {
          "slot": "lunch",
          "slotNameAr": "الغداء",
          "count": 1,
          "page": 1,
          "pageSize": 20,
          "totalCount": 2,
          "totalPages": 1,
          "hasNextPage": false,
          "hasPreviousPage": false,
          "meals": [
            {
              "mealId": "ebb5f986-bce7-41f2-88b1-a29a07fd156e",
              "nameAr": "دجاج مشوي مع أرز",
              "slot": "lunch",
              "slotNameAr": "الغداء",
              "sortOrder": 1,
              "imageUrl":
                  "https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/meal-lunch.jpg",
              "calories": 620.0,
              "proteinG": 38.0,
              "carbsG": 5.0,
              "fatG": 50.0,
              "descriptionAr": "وجبة طازجة محسوبة القيم الغذائية ومعدة يوميًا.",
              "presentAllergenCodes": [],
              "mayContainAllergenCodes": [],
              "dietaryPreferenceCodes": [],
              "ingredients": [],
              "blockReason": null,
              "isSelected": false,
              "name": "دجاج مشوي مع أرز",
              "slotName": "الغداء",
              "description": "وجبة طازجة محسوبة القيم الغذائية ومعدة يوميًا.",
            },
          ],
          "slotName": "الغداء",
        },
        {
          "slot": "snack",
          "slotNameAr": "سناك",
          "count": 1,
          "page": 1,
          "pageSize": 20,
          "totalCount": 2,
          "totalPages": 1,
          "hasNextPage": false,
          "hasPreviousPage": false,
          "meals": [
            {
              "mealId": "b180a081-5883-422d-8607-c1f2b036d8a7",
              "nameAr": "زبادي يوناني بالشوفان",
              "slot": "snack",
              "slotNameAr": "سناك",
              "sortOrder": 1,
              "imageUrl":
                  "https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/meal-snack.jpg",
              "calories": 210.0,
              "proteinG": 14.0,
              "carbsG": 3.0,
              "fatG": 16.0,
              "descriptionAr": "وجبة طازجة محسوبة القيم الغذائية ومعدة يوميًا.",
              "presentAllergenCodes": [],
              "mayContainAllergenCodes": [],
              "dietaryPreferenceCodes": [],
              "ingredients": [],
              "blockReason": null,
              "isSelected": false,
              "name": "زبادي يوناني بالشوفان",
              "slotName": "سناك",
              "description": "وجبة طازجة محسوبة القيم الغذائية ومعدة يوميًا.",
            },
          ],
          "slotName": "سناك",
        },
      ],
      "coreIngredients": [
        {
          "id": "e69721c0-2ee8-4d8e-b4e9-f46c00a4f40d",
          "nameAr": "أفوكادو",
          "iconUrl":
              "https://ik.imagekit.io/f7h9cj23x/catalog/ingredient-photos/avocado.webp",
          "isLocal": true,
          "originCountryCode": "KW",
          "originCountryNameAr": "الكويت",
          "flagEmoji": "🇰🇼",
          "name": "أفوكادو",
          "originCountryName": "الكويت",
        },
      ],
      "selectedMealIds": [],
      "rating": null,
      "ratingCount": 0,
      "deliveryWindowStart": "08:00:00",
      "deliveryWindowEnd": "16:00:00",
      "deliveryTimeText": "8:00 ص - 4:00 م",
      "tier": "Basic",
      "tierNameAr": "أساسي",
      "tierName": "أساسي",
      "tierLogoUrl":
          "https://ik.imagekit.io/f7h9cj23x/uploads/admin/tiers/Group_19497_apsDC4VCMe.png",
      "programNameAr": "برنامج الكيتو المتكامل",
      "programName": "برنامج الكيتو المتكامل",
      "name": "جرين بول",
    };

    final dto = CalendarAvailableMealsResponseDto.fromJson(json);
    expect(dto.restaurantId, "8ff16c1f-70ca-42f9-ae42-3c803da87744");
    expect(dto.slots?.length, 2);
    expect(dto.slots?.first.slot, "lunch");
    expect(dto.slots?.first.page, 1);
    expect(dto.slots?.first.pageSize, 20);
    expect(dto.slots?.first.hasNextPage, false);
    expect(dto.slots?.first.meals?.first.calories, 620.0);

    final entity = dto.toEntity('ar');
    expect(entity.requiredMealsCount, 2);
    expect(entity.slotRequirements.length, 2);
    expect(entity.slots.length, 2);
    expect(entity.slots.first.slot, "lunch");
    expect(entity.slots.first.meals.length, 1);
    expect(entity.meals.length, 2);
    expect(entity.coreIngredients.length, 1);
    expect(entity.restaurant?.name, "جرين بول");
  });

  test(
    'deserializes nutritionTotals with macro percentages and maps to entity',
    () {
      final json = <String, dynamic>{
        "id": "63ccd3ed-b8cd-49b7-967f-dfaeb78af266",
        "serviceDate": "2026-09-05",
        "nutritionTotals": {
          "calories": 620.0,
          "proteinG": 38.0,
          "carbsG": 5.0,
          "fatG": 50.0,
          "proteinPercentage": 24.4,
          "carbsPercentage": 3.2,
          "fatPercentage": 72.3,
        },
      };

      final dayDto = CalendarDayResponseDto.fromJson(json);
      expect(dayDto.nutritionTotals?.calories, 620.0);
      expect(dayDto.nutritionTotals?.proteinPercentage, 24.4);
      expect(dayDto.nutritionTotals?.carbsPercentage, 3.2);
      expect(dayDto.nutritionTotals?.fatPercentage, 72.3);

      final dayEntity = dayDto.toEntity('en');
      expect(dayEntity.nutritionTotals.calories, 620);
      expect(dayEntity.nutritionTotals.proteinG, 38);
      expect(dayEntity.nutritionTotals.carbsG, 5);
      expect(dayEntity.nutritionTotals.fatG, 50);
      expect(dayEntity.nutritionTotals.proteinPercentage, 24.4);
      expect(dayEntity.nutritionTotals.carbsPercentage, 3.2);
      expect(dayEntity.nutritionTotals.fatPercentage, 72.3);
    },
  );

  test(
    'deserializes root-level macro percentages in day JSON and maps to nutritionTotals',
    () {
      final json = <String, dynamic>{
        "id": "63ccd3ed-b8cd-49b7-967f-dfaeb78af266",
        "serviceDate": "2026-09-05",
        "nutritionTotals": {
          "calories": 830.0,
          "proteinG": 52.0,
          "carbsG": 8.0,
          "fatG": 66.0,
        },
        "proteinPercentage": 24.9,
        "carbsPercentage": 3.8,
        "fatPercentage": 71.2,
        "restaurantName": "مطبخ دايت كير",
      };

      final dayDto = CalendarDayResponseDto.fromJson(json);
      expect(dayDto.proteinPercentage, 24.9);
      expect(dayDto.carbsPercentage, 3.8);
      expect(dayDto.fatPercentage, 71.2);

      final dayEntity = dayDto.toEntity('en');
      expect(dayEntity.nutritionTotals.calories, 830);
      expect(dayEntity.nutritionTotals.proteinG, 52);
      expect(dayEntity.nutritionTotals.carbsG, 8);
      expect(dayEntity.nutritionTotals.fatG, 66);
      expect(dayEntity.nutritionTotals.proteinPercentage, 24.9);
      expect(dayEntity.nutritionTotals.carbsPercentage, 3.8);
      expect(dayEntity.nutritionTotals.fatPercentage, 71.2);
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
  int autoSelectCalls = 0;
  int saveCalls = 0;
  int getDayCalls = 0;

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    autoSelectCalls++;
    return Future.value(
      ApiSuccessResult(
        data: CalendarDayEntity(
          dayNumber: DateTime.now().day,
          weekday: 'Mon',
          date: DateTime.now(),
        ),
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
    getDayCalls++;
    final serviceDate = DateTime.parse(date);
    return Future.value(
      ApiSuccessResult(
        data: CalendarDayEntity(
          dayNumber: serviceDate.day,
          weekday: 'Tue',
          date: serviceDate,
          hasMeals: false,
          canEdit: true,
        ),
      ),
    );
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
    saveCalls++;
    final savedDate = DateTime.tryParse(date)!;
    return Future.value(
      ApiSuccessResult(
        data: CalendarDayEntity(
          dayNumber: savedDate.day,
          weekday: 'Mon',
          date: savedDate,
          meals: meals,
          selectedMealIds: meals.map((meal) => meal.id).toList(),
          canEdit: true,
        ),
      ),
    );
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
  Future<ApiResult<ProfileBillingFreezeDetailsEntity>>
  getCurrentCustomerSubscriptionFreezeDetails() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingFreezeDetailsEntity>>
  getCustomerSubscriptionFreezeDetails(String subscriptionId) {
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
  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(
    String subscriptionId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required ProfileBillingFreezeRequestEntity request,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String subscriptionId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProfileBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required ProfileBillingCancellationRequestEntity request,
  }) {
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
