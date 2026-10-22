import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_en.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_frozen_day_state.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/calendar_meal_details_mapper.dart';

void main() {
  test('month grid keeps leap day and disables dates outside service days', () {
    final date = DateTime(2028, 2, 29);
    final days = CalendarDaysBuilder.monthDays(
      focusedMonth: DateTime(2028, 2),
      selectedDate: date,
      serviceDays: [CalendarDayEntity(dayNumber: 29, weekday: '', date: date)],
    );
    expect(days.length % 7, 0);
    expect(days.where((day) => day.isSelected).single.date, date);
    expect(days.where((day) => !day.isMuted).single.date, date);
    expect(days.map((day) => day.date).toSet().length, days.length);
  });

  for (final status in ['open', 'locked', 'frozen']) {
    testWidgets('day content respects $status editing state', (tester) async {
      var restaurantOpened = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CalendarDayContent(
              selectedDay: CalendarDayEntity(
                dayNumber: 1,
                weekday: '',
                date: DateTime.now().add(const Duration(days: 10)),
                status: status,
                canEdit: status == 'open',
              ),
              showBottomSpace: false,
              onSelectRestaurant: () => restaurantOpened = true,
              onChangeMeal: () =>
                  fail('Empty day must select a restaurant first'),
              onMealTap: (_, _) => fail('Empty day has no meal to open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (status == 'frozen') {
        expect(find.byType(CalendarFrozenDayState), findsOneWidget);
        expect(find.byType(CalendarEmptyMealsState), findsNothing);
      } else {
        final empty = tester.widget<CalendarEmptyMealsState>(
          find.byType(CalendarEmptyMealsState),
        );
        if (status == 'open') {
          expect(empty.onAddMeals, isNotNull);
          empty.onAddMeals!();
          expect(restaurantOpened, isTrue);
        } else {
          expect(empty.onAddMeals, isNull);
        }
      }
      expect(tester.takeException(), isNull);
    });
  }

  test(
    'shared details mapping preserves API percentages and selection callback',
    () {
      var selected = false;
      final details = CalendarMealDetailsMapper.map(
        meal: const CalendarMealEntity(
          title: 'Lunch',
          description: 'Meal description',
          mealType: 'Lunch',
          time: '',
          calories: '620',
          protein: '38g',
          carbs: '5g',
          fat: '50g',
          ingredients: [],
          imageAsset: '',
          actionLabel: '',
          proteinPercentage: 24,
          carbsPercentage: 3,
          fatPercentage: 72,
          allergens: [CalendarMealAllergenEntity(code: 'MILK', label: 'Milk')],
        ),
        locale: AppLocalizationsEn(),
        restaurantName: 'Green Bowl',
        onSelectMeal: () => selected = true,
      );
      expect(details.description, 'Meal description');
      expect(details.restaurantLogo, 'GB');
      expect(details.macroItems.map((item) => item.percent), [
        '%72',
        '%24',
        '%3',
      ]);
      expect(details.allergens.single.label, 'Milk');
      details.onSelectMeal!();
      expect(selected, isTrue);
    },
  );
}
