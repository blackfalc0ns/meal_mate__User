sealed class MealSelectionEvent {
  const MealSelectionEvent();
}

class LoadMealsEvent extends MealSelectionEvent {
  const LoadMealsEvent({
    required this.subscriptionId,
    required this.date,
    required this.restaurantId,
    required this.localeName,
    this.initialSelectedMealIds = const <String>[],
  });

  final String subscriptionId;
  final DateTime date;
  final String restaurantId;
  final String localeName;
  final List<String> initialSelectedMealIds;
}

class ToggleMealEvent extends MealSelectionEvent {
  const ToggleMealEvent(this.mealId);

  final String mealId;
}

class LoadMoreMealsEvent extends MealSelectionEvent {
  const LoadMoreMealsEvent({
    required this.slot,
    required this.localeName,
  });

  final String slot;
  final String localeName;
}

class SaveMealsEvent extends MealSelectionEvent {
  const SaveMealsEvent({required this.localeName});

  final String localeName;
}

class AutoSelectMealsEvent extends MealSelectionEvent {
  const AutoSelectMealsEvent({required this.localeName});

  final String localeName;
}

class ConfirmMealsEvent extends MealSelectionEvent {
  const ConfirmMealsEvent({required this.localeName});

  final String localeName;
}

class ClearMealSelectionEvent extends MealSelectionEvent {
  const ClearMealSelectionEvent();
}
