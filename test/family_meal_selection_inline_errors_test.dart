import 'support/family_meal_selection_view_model_factory.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/screens/family_meal_selection_screen.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/screens/family_restaurants_screen.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_meal_selection_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_header.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurant_card.dart';
import 'support/family_calendar_view_model_factory.dart';

const _meal = CalendarMealEntity(
  id: 'meal',
  mealType: 'Lunch',
  title: 'Existing meal',
  time: '',
  calories: '',
  protein: '',
  carbs: '',
  fat: '',
  ingredients: [],
  imageAsset: '',
  actionLabel: 'Select',
);
const _restaurant = CalendarRestaurantOptionEntity(
  id: 'restaurant',
  name: 'Existing restaurant',
  description: '',
  mealCount: 1,
  logoType: CalendarRestaurantLogoType.healthyBowl,
);

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

class _FailingRepository extends Fake implements CalendarRepository {
  final queries = <String?>[];
  final slots = <String?>[];
  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) async {
    queries.add(query);
    return ApiErrorResult(failure: Failure(errorMessage: 'Refresh failed'));
  }

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    String? slot,
    int? page,
    int? pageSize,
  }) async {
    slots.add(slot);
    return ApiErrorResult(failure: Failure(errorMessage: 'Refresh failed'));
  }
}

void main() {
  setUp(registerFamilyMealSelectionFactory);
  tearDown(() => getIt.unregister<FamilyMealSelectionViewModel>());

  testWidgets('restaurant inline retry keeps the failed search query', (
    tester,
  ) async {
    final repository = _FailingRepository();
    getIt.registerSingleton<GetCalendarRestaurantsUseCase>(
      GetCalendarRestaurantsUseCase(repository),
    );
    addTearDown(() => getIt.unregister<GetCalendarRestaurantsUseCase>());
    final calendar = createFamilyCalendarViewModel();
    addTearDown(calendar.close);
    await tester.pumpWidget(
      _app(
        FamilyRestaurantsScreen(
          args: FamilyRestaurantsArgs(
            subscriptionId: 'sub',
            date: DateTime(2026, 10, 15),
            viewModel: calendar,
          ),
        ),
      ),
    );
    await tester.pump();
    final selection = tester
        .element(find.byType(FamilyRestaurantsHeader))
        .read<FamilyMealSelectionViewModel>();
    selection.emit(
      selection.state.copyWith(
        restaurants: [_restaurant],
        filteredRestaurants: [_restaurant],
        clearRestaurantsFailure: true,
      ),
    );
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'chicken');
    await tester.pump();
    tester
        .widget<InlineApiErrorWidget>(find.byType(InlineApiErrorWidget))
        .onRetry!();
    await tester.pump();
    expect(repository.queries, [null, 'chicken', 'chicken']);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('meal inline retry requests the current category', (
    tester,
  ) async {
    final repository = _FailingRepository();
    final calendar = createFamilyCalendarViewModel();
    addTearDown(calendar.close);
    final selection = createFamilyMealSelectionViewModel(
      calendar: calendar,
      subscriptionId: 'sub',
      date: DateTime(2026, 10, 15),
      getAvailableMealsUseCase: GetCalendarAvailableMealsUseCase(repository),
    );
    addTearDown(selection.close);
    await tester.pumpWidget(
      _app(
        FamilyMealSelectionScreen(
          args: FamilyMealSelectionArgs(
            subscriptionId: 'sub',
            date: DateTime(2026, 10, 15),
            selectionViewModel: selection,
          ),
        ),
      ),
    );
    await tester.pump();
    selection.emit(
      selection.state.copyWith(
        selectedCategoryIndex: 2,
        selectedRestaurant: _restaurant,
        availableMeals: const CalendarAvailableMealsEntity(
          restaurant: null,
          meals: [_meal],
          slotRequirements: [],
        ),
        availableMealsFailure: Failure(errorMessage: 'Refresh failed'),
      ),
    );
    await tester.pump();
    tester
        .widget<InlineApiErrorWidget>(find.byType(InlineApiErrorWidget))
        .onRetry!();
    await tester.pump();
    expect(repository.slots, ['lunch']);
    expect(find.byType(FamilyMealSelectionCard), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final mealsScreen in [false, true]) {
    for (final hasData in [false, true]) {
      testWidgets(
        '${mealsScreen ? "meals" : "restaurants"}: error ${hasData ? "keeps content and shows inline retry" : "uses full error without data"}',
        (tester) async {
          final calendar = createFamilyCalendarViewModel();
          addTearDown(calendar.close);
          FamilyMealSelectionViewModel? selection;
          if (mealsScreen) {
            selection = createFamilyMealSelectionViewModel(
              calendar: calendar,
              subscriptionId: 'sub',
              date: DateTime(2026, 10, 15),
            );
            addTearDown(selection.close);
            await tester.pumpWidget(
              _app(
                FamilyMealSelectionScreen(
                  args: FamilyMealSelectionArgs(
                    subscriptionId: 'sub',
                    date: DateTime(2026, 10, 15),
                    selectionViewModel: selection,
                  ),
                ),
              ),
            );
          } else {
            await tester.pumpWidget(
              _app(
                FamilyRestaurantsScreen(
                  args: FamilyRestaurantsArgs(
                    subscriptionId: 'sub',
                    date: DateTime(2026, 10, 15),
                    viewModel: calendar,
                  ),
                ),
              ),
            );
            selection = tester
                .element(find.byType(FamilyRestaurantsHeader))
                .read<FamilyMealSelectionViewModel>();
          }
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));
          final failure = Failure(errorMessage: 'Refresh failed');
          selection.emit(
            selection.state.copyWith(
              restaurants: hasData ? [_restaurant] : const [],
              filteredRestaurants: hasData ? [_restaurant] : const [],
              availableMeals: CalendarAvailableMealsEntity(
                restaurant: null,
                meals: hasData ? [_meal] : const [],
                slotRequirements: const [],
              ),
              restaurantsFailure: failure,
              availableMealsFailure: failure,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));
          expect(
            find.byType(InlineApiErrorWidget),
            hasData ? findsOneWidget : findsNothing,
          );
          expect(
            find.byType(ApiErrorWidget),
            hasData ? findsNothing : findsOneWidget,
          );
          if (hasData) {
            expect(
              find.byType(
                mealsScreen ? FamilyMealSelectionCard : FamilyRestaurantCard,
              ),
              findsOneWidget,
            );
            expect(
              tester
                  .widget<InlineApiErrorWidget>(
                    find.byType(InlineApiErrorWidget),
                  )
                  .onRetry,
              isNotNull,
            );
            selection.emit(
              selection.state.copyWith(
                isLoadingRestaurants: true,
                isLoadingAvailableMeals: true,
                clearRestaurantsFailure: true,
                clearAvailableMealsFailure: true,
              ),
            );
            await tester.pump(const Duration(milliseconds: 50));
            expect(
              find.byType(
                mealsScreen ? FamilyMealSelectionCard : FamilyRestaurantCard,
              ),
              findsOneWidget,
            );
          }
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
