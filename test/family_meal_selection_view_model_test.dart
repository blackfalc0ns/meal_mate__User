import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';

void main() {
  test('meal selection owns a separate state from the calendar', () async {
    final calendar = FamilyCalendarViewModel.test(null, null, null, null);
    final selection = FamilyMealSelectionViewModel(calendar: calendar);

    expect(identical(selection.state, calendar.state), isFalse);
    expect(selection.state.selectedMealsForDay, isEmpty);

    await selection.close();
    await calendar.close();
  });
}
