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
    final screen = File(
      'lib/features/calendar/presentation/screens/calendar_screen.dart',
    ).readAsStringSync();
    expect(
      screen,
      contains('onSelectRestaurant: () => _openRestaurantPicker(context)'),
    );
  });

  test(
    'restaurant picker selection waits for available meals before opening',
    () {
      final source = File(
        'lib/features/calendar/presentation/screens/calendar_screen.dart',
      ).readAsStringSync();

      expect(
        source,
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

  test('change meal opens picker before loading available meals', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen.dart',
    ).readAsStringSync();

    final changeMealCallbackIndex = source.indexOf('onChangeMeal: () {');
    final openMealPickerIndex = source.indexOf(
      '_openMealPicker(context);',
      changeMealCallbackIndex,
    );
    final loadAvailableMealsIndex = source.indexOf(
      'LoadCalendarAvailableMealsEvent(',
      changeMealCallbackIndex,
    );

    expect(changeMealCallbackIndex, isNonNegative);
    expect(openMealPickerIndex, isNonNegative);
    expect(loadAvailableMealsIndex, isNonNegative);
    expect(openMealPickerIndex, lessThan(loadAvailableMealsIndex));
  });

  test('meal picker closes only after save success count changes', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen.dart',
    ).readAsStringSync();

    final closeGuardIndex = source.indexOf('if (_mealSheetOpen &&');
    final snackbarIndex = source.indexOf(
      'CustomSnackbar.showSuccess(',
      closeGuardIndex,
    );
    final closeRouteIndex = source.indexOf(
      '_closeMealPickerRoute();',
      closeGuardIndex,
    );
    final closeGuard = source.substring(closeGuardIndex, closeRouteIndex);

    expect(closeGuardIndex, isNonNegative);
    expect(snackbarIndex, isNonNegative);
    expect(closeRouteIndex, isNonNegative);
    expect(snackbarIndex, lessThan(closeRouteIndex));
    expect(
      closeGuard,
      contains('state.saveSuccessCount != _handledSaveSuccessCount'),
    );
  });

  test('meal picker save button is selected separately from sheet rebuilds', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen.dart',
    ).readAsStringSync();

    final openMealPickerSource =
        File(
          'lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart',
        ).readAsStringSync() +
        File(
          'lib/features/calendar/presentation/widgets/calendar_meal_save_button.dart',
        ).readAsStringSync();

    expect(openMealPickerSource, contains('BlocSelector<'));
    expect(openMealPickerSource, contains('CalendarViewModel,'));
    expect(openMealPickerSource, contains('CalendarState,'));
    expect(openMealPickerSource, contains('canSave: state.canSaveMeals'));
    expect(openMealPickerSource, contains('isSaving: state.isSaving'));
    expect(openMealPickerSource, contains('onSave: null,'));
    expect(openMealPickerSource, contains('RoundedLoadingButton('));
    expect(source, contains('RoundedLoadingButtonController()'));
    expect(openMealPickerSource, contains('controller: saveButtonController'));
    expect(openMealPickerSource, contains('animateOnTap: false'));
    expect(openMealPickerSource, isNot(contains('return AppButton(')));
  });
}
