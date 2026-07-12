class CalendarDayEntity {
  const CalendarDayEntity({
    required this.dayNumber,
    required this.weekday,
    this.isSelected = false,
    this.isMuted = false,
    this.hasMeals = true,
  });

  final int dayNumber;
  final String weekday;
  final bool isSelected;
  final bool isMuted;
  final bool hasMeals;
}
