import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty meals add button opens restaurant picker before meal picker', () {
    final source = File(
      'lib/features/calendar/presentation/widgets/calendar_day_content.dart',
    ).readAsStringSync();
    expect(
      source,
      contains('onAddMeals: readOnly ? null : () => onSelectRestaurant()'),
    );
    final body = File(
      'lib/features/calendar/presentation/screens/calendar_screen_body.dart',
    ).readAsStringSync();
    expect(
      body,
      contains('activeCoordinator.openRestaurantPicker(context)'),
    );
  });

  test(
    'restaurant picker selection waits for available meals before opening',
    () {
      final coordinator = File(
        'lib/features/calendar/presentation/screens/calendar_navigation_coordinator.dart',
      ).readAsStringSync();

      expect(
        coordinator,
        isNot(
          contains(
            'SelectCalendarRestaurantEvent(\n'
            '        restaurant: selectedRestaurant,\n'
            '        localeName: locale.localeName,\n'
            '      ),\n'
            '    );\n'
            '    _openMealPicker(this.context);',
          ),
        ),
      );
    },
  );

  test('change meal opens picker and loads available meals', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen_body.dart',
    ).readAsStringSync();

    final changeMealCallbackIndex = source.indexOf('onChangeMeal: onChangeMeal ??');
    final openMealPickerIndex = source.indexOf(
      'activeCoordinator.openMealPicker(context)',
      changeMealCallbackIndex,
    );
    final loadAvailableMealsIndex = source.indexOf(
      'context.read<MealSelectionCubit>().load(',
      changeMealCallbackIndex,
    );

    expect(changeMealCallbackIndex, isNonNegative);
    expect(openMealPickerIndex, isNonNegative);
    expect(loadAvailableMealsIndex, isNonNegative);
    expect(loadAvailableMealsIndex, lessThan(openMealPickerIndex));
  });

  test('meal picker closes only on MealsSavedEffect', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen_effects.dart',
    ).readAsStringSync();

    final effectConditionIndex = source.indexOf('case MealsSavedEffect():');
    final snackbarIndex = source.indexOf(
      'activeCoordinator.showSuccessSnackBar(',
      effectConditionIndex,
    );
    final closeRouteIndex = source.indexOf(
      'activeCoordinator.closeMealPicker(',
      effectConditionIndex,
    );

    expect(effectConditionIndex, isNonNegative);
    expect(snackbarIndex, isNonNegative);
    expect(closeRouteIndex, isNonNegative);
    expect(snackbarIndex, lessThan(closeRouteIndex));
  });

  test('meal picker save button is declarative and selected separately from sheet rebuilds', () {
    final openMealPickerSource =
        File(
          'lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart',
        ).readAsStringSync() +
        File(
          'lib/features/calendar/presentation/widgets/calendar_meal_save_button.dart',
        ).readAsStringSync();

    expect(openMealPickerSource, contains('BlocSelector<'));
    expect(openMealPickerSource, contains('MealSelectionCubit,'));
    expect(openMealPickerSource, contains('MealSelectionState,'));
    expect(openMealPickerSource, contains('state.isSaving'));
    expect(openMealPickerSource, isNot(contains('RoundedLoadingButtonController()')));
  });
}
