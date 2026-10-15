import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ControllableCalendarRepo implements CalendarRepository {
  final List<Completer<ApiResult<CalendarSubscriptionEntity>>>
  getCalendarCompleters = [];
  final List<String> getCalendarSubscriptionIds = [];

  final List<Completer<ApiResult<CalendarDayEntity>>> getDayCompleters = [];
  final List<String> getDayDates = [];

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
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _ControllableProfileRepo implements SubscriptionBillingRepository {
  Completer<ApiResult<SubscriptionBillingCurrentEntity>>? currentSubCompleter;

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription() {
    currentSubCompleter =
        Completer<ApiResult<SubscriptionBillingCurrentEntity>>();
    return currentSubCompleter!.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _TestOverviewCubit extends CalendarOverviewViewModel {
  _TestOverviewCubit(
    super.getCalendarUseCase,
    super.getCalendarDayUseCase,
    super.getCurrentCustomerSubscriptionUseCase,
    super.sharedPrefHelper,
  );

  void seed(CalendarOverviewState s) => emit(s);
}

SubscriptionBillingCurrentEntity _createBillingCurrent(String? subscriptionId) {
  return SubscriptionBillingCurrentEntity(
    emptyStateCode: subscriptionId == null ? 'no_subscription' : '',
    subscription: subscriptionId == null
        ? null
        : SubscriptionBillingSubscriptionEntity(
            subscriptionId: subscriptionId,
            status: 'active',
            statusNameAr: 'نشط',
            programId: 'p1',
            programNameAr: 'برنامج',
            programNameEn: 'Program',
            bundleId: 'b1',
            bundleNameAr: 'باقة',
            bundleNameEn: 'Bundle',
            tier: 'standard',
            tierNameAr: 'قياسي',
            tierNameEn: 'Standard',
            tierLogoUrl: '',
            mealsPerDay: 3,
            imageUrl: '',
            startDate: '2026-01-01',
            endDate: '2026-02-01',
            nextRenewalDate: '2026-02-01',
            totalServiceDays: 30,
            completedServiceDays: 5,
            remainingServiceDays: 25,
            progressPercentage: 16,
            paidAmount: 500.0,
            currencyCode: 'SAR',
            restaurant: const SubscriptionBillingRestaurantEntity(
              restaurantId: 'r1',
              nameAr: 'مطعم',
              nameEn: 'Restaurant',
              logoUrl: '',
            ),
            actions: const SubscriptionBillingActionsEntity(
              canRenew: false,
              canFreeze: false,
              canCancel: false,
              canUpgrade: false,
              renewUnavailableReason: '',
              freezeUnavailableReason: '',
              cancelUnavailableReason: '',
              upgradeUnavailableReason: '',
              freezeStartDelayDays: 0,
              maximumFreezeDays: 0,
              freezeExtendsSubscriptionEnd: false,
              earliestFreezeStartDate: '',
              renewalEndpoint: '',
              freezeEndpoint: '',
              cancellationEndpoint: '',
              upgradeEndpoint: '',
              cancellationQuoteEndpoint: '',
            ),
          ),
  );
}

CalendarDayEntity _createDay(
  int dayNumber, {
  bool isEditable = true,
  String? restaurantId,
  List<CalendarMealEntity> meals = const [],
}) {
  final futureDate = DateTime.now().add(Duration(days: dayNumber + 5));
  final date = DateTime(futureDate.year, futureDate.month, futureDate.day);
  return CalendarDayEntity(
    dayNumber: dayNumber,
    weekday: 'Day$dayNumber',
    date: date,
    canEdit: isEditable,
    restaurantId: restaurantId,
    restaurant: restaurantId != null
        ? CalendarRestaurantEntity(
            id: restaurantId,
            name: 'Rest $restaurantId',
            category: 'Healthy',
            rating: '4.5',
            deliveryDuration: '30m',
            deliveryWindow: '12:00 - 1:00',
          )
        : null,
    meals: meals,
    status: isEditable ? 'open' : 'frozen',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ControllableCalendarRepo calendarRepo;
  late _ControllableProfileRepo profileRepo;
  late SharedPreferences prefs;
  late SharedPrefHelper prefHelper;
  late _TestOverviewCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    prefHelper = SharedPrefHelper(prefs);
    calendarRepo = _ControllableCalendarRepo();
    profileRepo = _ControllableProfileRepo();

    cubit = _TestOverviewCubit(
      GetCalendarUseCase(calendarRepo),
      GetCalendarDayUseCase(calendarRepo),
      GetCurrentCustomerSubscriptionUseCase(profileRepo),
      prefHelper,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('CalendarOverviewCubit', () {
    test(
      '1. subscription resolution: resolves from profile repo and saves to prefs when subscriptionId is null',
      () async {
        cubit.loadCalendar(subscriptionId: null, localeName: 'en');

        expect(profileRepo.currentSubCompleter, isNotNull);
        profileRepo.currentSubCompleter!.complete(
          ApiSuccessResult(data: _createBillingCurrent('resolved-sub-99')),
        );
        await Future<void>.delayed(Duration.zero);

        expect(calendarRepo.getCalendarSubscriptionIds, ['resolved-sub-99']);
        expect(cubit.state.subscriptionId, 'resolved-sub-99');
        expect(cubit.state.isCalendarLoading, isTrue);

        final day1 = _createDay(1);
        calendarRepo.getCalendarCompleters[0].complete(
          ApiSuccessResult(
            data: CalendarSubscriptionEntity(
              subscriptionId: 'resolved-sub-99',
              days: [day1],
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.isCalendarLoading, isFalse);
        expect(cubit.state.days.length, 1);
        expect(
          prefHelper.getData(key: StorageKeys.currentSubscriptionId),
          'resolved-sub-99',
        );
      },
    );

    test('2. empty subscription marks hasNoSubscription: true', () async {
      cubit.loadCalendar(subscriptionId: null, localeName: 'en');

      profileRepo.currentSubCompleter!.complete(
        ApiSuccessResult(data: _createBillingCurrent(null)),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.hasNoSubscription, isTrue);
      expect(cubit.state.isCalendarLoading, isFalse);
    });

    test(
      '3. not-found retry: clears cached subscription and re-resolves when not found occurs',
      () async {
        await prefHelper.saveData(
          key: StorageKeys.currentSubscriptionId,
          val: 'stale-sub',
        );

        cubit.loadCalendar(subscriptionId: null, localeName: 'en');
        await Future<void>.delayed(Duration.zero);

        expect(profileRepo.currentSubCompleter, isNotNull);
        profileRepo.currentSubCompleter!.complete(
          ApiSuccessResult(data: _createBillingCurrent('stale-sub')),
        );
        await Future<void>.delayed(Duration.zero);

        expect(calendarRepo.getCalendarSubscriptionIds, ['stale-sub']);

        // Return not found failure
        calendarRepo.getCalendarCompleters[0].complete(
          ApiErrorResult(
            failure: Failure(
              errorMessage: 'Not found',
              code: SubscriptionErrorCodes.commonNotFound,
              exception: const ApiException(
                errorType: ApiErrorType.notFound,
                message: 'Not found',
                backendErrorCode: SubscriptionErrorCodes.commonNotFound,
              ),
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        // Should have cleared stale-sub and invoked profile repo to resolve new subscription
        expect(profileRepo.currentSubCompleter, isNotNull);
        profileRepo.currentSubCompleter!.complete(
          ApiSuccessResult(data: _createBillingCurrent('new-sub')),
        );
        await Future<void>.delayed(Duration.zero);

        expect(calendarRepo.getCalendarSubscriptionIds, [
          'stale-sub',
          'new-sub',
        ]);
      },
    );

    test('4. rapid day switching: stale day request ignored', () async {
      final day1 = _createDay(1);
      final day2 = _createDay(2);

      cubit.loadCalendar(subscriptionId: 'sub-1', localeName: 'en');
      calendarRepo.getCalendarCompleters[0].complete(
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: 'sub-1',
            days: [day1, day2],
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      cubit.selectDay(day: day1, localeName: 'en');
      cubit.selectDay(day: day2, localeName: 'en');

      expect(calendarRepo.getDayCompleters.length, 3); // initial + day1 + day2

      // Resolve day1 late
      final detailedDay1 = day1.copyWith(
        meals: [
          const CalendarMealEntity(
            id: 'm-old',
            title: 'Old Meal',
            description: '',
            mealType: 'Lunch',
            time: '',
            calories: '500',
            protein: '30g',
            carbs: '30g',
            fat: '10g',
            ingredients: [],
            imageAsset: '',
            actionLabel: '',
          ),
        ],
      );
      calendarRepo.getDayCompleters[1].complete(
        ApiSuccessResult(data: detailedDay1),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.selectedDate, day2.date);

      // Resolve day2
      final detailedDay2 = day2.copyWith(
        meals: [
          const CalendarMealEntity(
            id: 'm-new',
            title: 'New Meal',
            description: '',
            mealType: 'Lunch',
            time: '',
            calories: '600',
            protein: '40g',
            carbs: '40g',
            fat: '15g',
            ingredients: [],
            imageAsset: '',
            actionLabel: '',
          ),
        ],
      );
      calendarRepo.getDayCompleters[2].complete(
        ApiSuccessResult(data: detailedDay2),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.selectedDay?.meals.single.id, 'm-new');
    });

    test(
      '5. selected-day failure sets calendarFailure and turns off isSelectedDayLoading',
      () async {
        final day1 = _createDay(1);
        final day2 = _createDay(2);
        cubit.loadCalendar(subscriptionId: 'sub-1', localeName: 'en');
        calendarRepo.getCalendarCompleters[0].complete(
          ApiSuccessResult(
            data: CalendarSubscriptionEntity(
              subscriptionId: 'sub-1',
              days: [day1, day2],
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        cubit.selectDay(day: day2, localeName: 'en');
        expect(cubit.state.isSelectedDayLoading, isTrue);

        calendarRepo.getDayCompleters[1].complete(
          ApiErrorResult(
            failure: Failure(
              errorMessage: 'Failed to load day',
              code: 'day_failed',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.isSelectedDayLoading, isFalse);
        expect(cubit.state.calendarFailure?.errorMessage, 'Failed to load day');
      },
    );

    test(
      '6. replaceDay preserves existing meals when the incoming entity omits them',
      () {
        const meal = CalendarMealEntity(
          id: 'm-keep',
          title: 'Keep Meal',
          description: '',
          mealType: 'Lunch',
          time: '',
          calories: '500',
          protein: '30g',
          carbs: '30g',
          fat: '10g',
          ingredients: [],
          imageAsset: '',
          actionLabel: '',
        );
        final day1 = _createDay(1, meals: [meal]);

        cubit.seed(
          CalendarOverviewState(days: [day1], selectedDate: day1.date),
        );

        final updatedDayWithoutMeals = _createDay(
          1,
          restaurantId: 'new-rest',
          meals: const [],
        );
        cubit.replaceDay(updatedDayWithoutMeals);

        expect(cubit.state.selectedDay?.restaurantId, 'new-rest');
        expect(cubit.state.selectedDay?.meals, [meal]);
      },
    );
  });
}
