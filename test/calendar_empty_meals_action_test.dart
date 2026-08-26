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
}
