import 'support/family_meal_selection_view_model_factory.dart';
import 'support/family_calendar_view_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('meal selection owns a separate state from the calendar', () async {
    final calendar = createFamilyCalendarViewModel();
    final selection = createFamilyMealSelectionViewModel(calendar: calendar);

    expect(identical(selection.state, calendar.state), isFalse);
    expect(selection.state.selectedMealsForDay, isEmpty);

    await selection.close();
    await calendar.close();
  });
}
