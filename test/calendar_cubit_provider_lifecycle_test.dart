import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
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
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCalendarRepo implements CalendarRepository {
  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) async {
    return ApiSuccessResult(
      data: const CalendarSubscriptionEntity(
        subscriptionId: 'sub-test',
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
    return ApiSuccessResult(
      data: CalendarDayEntity(
        dayNumber: 1,
        weekday: 'Monday',
        date: DateTime.parse(date),
        status: 'open',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeProfileRepo implements ProfileRepository {
  @override
  Future<ApiResult<ProfileBillingCurrentEntity>>
  getCurrentCustomerSubscription() async {
    return ApiSuccessResult(
      data: const ProfileBillingCurrentEntity(
        emptyStateCode: '',
        subscription: null,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _TrackingOverviewCubit extends CalendarOverviewCubit {
  final List<String> closeLog;
  int closeCount = 0;

  _TrackingOverviewCubit(
    super.a,
    super.b,
    super.c,
    super.d, {
    required this.closeLog,
  });

  @override
  Future<void> close() {
    closeCount++;
    closeLog.add('overview');
    return super.close();
  }
}

class _TrackingRestaurantPickerCubit extends RestaurantPickerCubit {
  final List<String> closeLog;
  int closeCount = 0;

  _TrackingRestaurantPickerCubit(super.a, super.b, {required this.closeLog});

  @override
  Future<void> close() {
    closeCount++;
    closeLog.add('restaurant_picker');
    return super.close();
  }
}

class _TrackingMealSelectionCubit extends MealSelectionCubit {
  final List<String> closeLog;
  int closeCount = 0;

  _TrackingMealSelectionCubit(
    super.a,
    super.b,
    super.c,
    super.d, {
    required this.closeLog,
  });

  @override
  Future<void> close() {
    closeCount++;
    closeLog.add('meal_selection');
    return super.close();
  }
}

class _TrackingFlowCubit extends CalendarFlowCubit {
  final List<String> closeLog;
  int closeCount = 0;

  _TrackingFlowCubit({
    required super.overviewCubit,
    required super.restaurantPickerCubit,
    required super.mealSelectionCubit,
    required this.closeLog,
  });

  @override
  Future<void> close() {
    closeCount++;
    closeLog.add('flow');
    return super.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'CalendarScreen provides exact Cubits and closes each once with Flow closed first',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        StorageKeys.currentSubscriptionId: 'sub-test',
      });
      final prefs = await SharedPreferences.getInstance();
      final prefHelper = SharedPrefHelper(prefs);

      final calendarRepo = _FakeCalendarRepo();
      final profileRepo = _FakeProfileRepo();

      final closeLog = <String>[];

      final overviewCubit = _TrackingOverviewCubit(
        GetCalendarUseCase(calendarRepo),
        GetCalendarDayUseCase(calendarRepo),
        GetCurrentCustomerSubscriptionUseCase(profileRepo),
        prefHelper,
        closeLog: closeLog,
      );

      final restaurantPickerCubit = _TrackingRestaurantPickerCubit(
        GetCalendarRestaurantsUseCase(calendarRepo),
        SetCalendarDayRestaurantUseCase(calendarRepo),
        closeLog: closeLog,
      );

      final mealSelectionCubit = _TrackingMealSelectionCubit(
        GetCalendarAvailableMealsUseCase(calendarRepo),
        SaveCalendarDayMealsUseCase(calendarRepo),
        AutoSelectCalendarDayUseCase(calendarRepo),
        ConfirmCalendarDayMealsUseCase(calendarRepo),
        closeLog: closeLog,
      );

      final flowCubit = _TrackingFlowCubit(
        overviewCubit: overviewCubit,
        restaurantPickerCubit: restaurantPickerCubit,
        mealSelectionCubit: mealSelectionCubit,
        closeLog: closeLog,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (rootContext) => TextButton(
                onPressed: () async {
                  await Navigator.of(rootContext).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CalendarScreen(
                        subscriptionId: 'sub-test',
                        overviewCubit: overviewCubit,
                        restaurantPickerCubit: restaurantPickerCubit,
                        mealSelectionCubit: mealSelectionCubit,
                        flowCubit: flowCubit,
                      ),
                    ),
                  );
                },
                child: const Text('Open Calendar'),
              ),
            ),
          ),
        ),
      );

      // Open CalendarScreen
      await tester.tap(find.text('Open Calendar'));
      await tester.pumpAndSettle();

      // Verify exactly the passed instances were provided via MultiBlocProvider
      final descendantElement = tester.element(find.byType(CalendarHeader));
      final providedOverview = descendantElement.read<CalendarOverviewCubit>();
      final providedPicker = descendantElement.read<RestaurantPickerCubit>();
      final providedMeals = descendantElement.read<MealSelectionCubit>();
      final providedFlow = descendantElement.read<CalendarFlowCubit>();
      expect(providedOverview, same(overviewCubit));
      expect(providedPicker, same(restaurantPickerCubit));
      expect(providedMeals, same(mealSelectionCubit));
      expect(providedFlow, same(flowCubit));

      // Verify none are closed yet while screen is active
      expect(overviewCubit.closeCount, 0);
      expect(restaurantPickerCubit.closeCount, 0);
      expect(mealSelectionCubit.closeCount, 0);
      expect(flowCubit.closeCount, 0);

      // Pop the CalendarScreen route
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      // Verify each cubit instance was closed exactly once
      expect(flowCubit.closeCount, 1);
      expect(overviewCubit.closeCount, 1);
      expect(restaurantPickerCubit.closeCount, 1);
      expect(mealSelectionCubit.closeCount, 1);

      // Verify close order: flow was closed first!
      expect(closeLog.first, 'flow');
    },
  );
}
