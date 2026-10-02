part of 'calendar_state.dart';

extension CalendarStateX on CalendarState {
  List<CalendarRestaurantOptionEntity> restaurantsWithUsageLimits() {
    return restaurants;
  }

  CalendarDayEntity? get selectedDay {
    final date = selectedDate;
    if (date == null) return days.firstOrNull;
    return days
        .where((day) => day.date != null && _isSameDay(day.date!, date))
        .firstOrNull;
  }

  bool get hasCalendarData => days.isNotEmpty;

  bool get hasRestaurantPool => restaurants.isNotEmpty;

  bool get canEditSelectedDay => selectedDay?.isEditable == true;

  List<CalendarMealEntity> get selectedDayMeals {
    return selectedDay?.meals ?? const [];
  }

  int get requiredMealsCount {
    final availableCount = availableMeals?.requiredMealsCount ?? 0;
    if (availableCount > 0) return availableCount;
    final day = selectedDay;
    if (day == null) return 0;
    return day.slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
  }

  bool get canSaveMeals {
    final available = availableMeals;
    if (available == null ||
        localSelectedMealIds.length != requiredMealsCount) {
      return false;
    }
    for (final requirement in available.slotRequirements) {
      final count = available.meals
          .where(
            (meal) =>
                meal.slot == requirement.slot &&
                localSelectedMealIds.contains(meal.id),
          )
          .length;
      if (count != requirement.count) return false;
    }
    return true;
  }

  bool get canConfirmSelectedDayMeals {
    final day = selectedDay;
    if (day == null || !day.isEditable || isConfirming || isSaving) return false;
    final meals = selectedDayMeals;
    if (meals.isEmpty) return false;
    final requiredCount = day.slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
    if (requiredCount > 0 && meals.length != requiredCount) return false;
    return true;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
