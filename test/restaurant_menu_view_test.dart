import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';

void main() {
  testWidgets('preview restaurant menu hides meal selection controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.preview,
            availableMeals: _availableMeals(),
            selectedMealIds: const ['meal-1'],
            onMealToggled: (_) {},
          ),
        ),
      ),
    );

    expect(_selectButtons, findsNothing);
  });

  testWidgets('selection restaurant menu shows meal selection controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            availableMeals: _availableMeals(),
            selectedMealIds: const ['meal-1'],
            onMealToggled: (_) {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(_selectButtons, findsOneWidget);
  });
}

Finder get _selectButtons {
  return find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == 'RestaurantMenuSelectButton',
  );
}

CalendarAvailableMealsEntity _availableMeals() {
  return CalendarAvailableMealsEntity(
    restaurant: null,
    meals: [_meal(id: 'meal-1', selected: true)],
    slotRequirements: const [
      CalendarSlotRequirementEntity(
        slot: 'lunch',
        displayName: 'Lunch',
        slotNameAr: 'الغداء',
        slotNameEn: 'Lunch',
        count: 1,
      ),
    ],
  );
}

CalendarMealEntity _meal({required String id, bool selected = false}) {
  return CalendarMealEntity(
    id: id,
    slot: 'lunch',
    selected: selected,
    mealType: 'Lunch',
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
