import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty meals add button opens restaurant picker before meal picker', () {
    final source = File(
      'lib/features/calendar/presentation/screens/calendar_screen.dart',
    ).readAsStringSync();

    expect(
      source,
      contains(
        'onAddMeals: readOnly\n'
        '                        ? null\n'
        '                        : () => _openRestaurantPicker(context),',
      ),
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
    final closeRouteIndex = source.indexOf(
      '_closeMealPickerRoute();',
      closeGuardIndex,
    );
    final closeGuard = source.substring(closeGuardIndex, closeRouteIndex);

    expect(closeGuardIndex, isNonNegative);
    expect(closeRouteIndex, isNonNegative);
    expect(
      closeGuard,
      contains('state.saveSuccessCount != _handledSaveSuccessCount'),
    );
  });
}
