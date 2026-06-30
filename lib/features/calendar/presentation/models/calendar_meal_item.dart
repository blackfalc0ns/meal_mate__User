enum CalendarMealState { completed, current, upcoming }

class CalendarMealItem {
  const CalendarMealItem({
    required this.time,
    required this.title,
    required this.calories,
    required this.asset,
    required this.state,
    this.extra,
  });

  final String time;
  final String title;
  final String calories;
  final String asset;
  final CalendarMealState state;
  final String? extra;
}
