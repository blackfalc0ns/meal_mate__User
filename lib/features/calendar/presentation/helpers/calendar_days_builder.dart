import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

abstract final class CalendarDaysBuilder {
  static List<CalendarDayEntity> serviceDays(
    List<CalendarDayEntity> days, {
    required DateTime? selectedDate,
    bool includeFriday = true,
  }) {
    return days
        .where((day) => includeFriday || day.date?.weekday != DateTime.friday)
        .map(
          (day) => day.copyWith(
            isSelected: _isSameDay(day.date, selectedDate),
            isMuted: false,
          ),
        )
        .toList();
  }

  static List<CalendarDayEntity> monthDays({
    required DateTime focusedMonth,
    required DateTime? selectedDate,
    bool includeFriday = true,
    required List<CalendarDayEntity> serviceDays,
  }) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final leadingDays = (firstDay.weekday + 1) % 7;
    final gridStart = firstDay.subtract(Duration(days: leadingDays));
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    return List.generate(totalCells, (index) {
          final date = DateTime(
            gridStart.year,
            gridStart.month,
            gridStart.day + index,
          );
          final serviceDay = serviceDays
              .where((day) => _isSameDay(day.date, date))
              .firstOrNull;
          if (serviceDay != null) {
            return serviceDay.copyWith(
              isSelected: _isSameDay(serviceDay.date, selectedDate),
              isMuted: false,
            );
          }
          return CalendarDayEntity(
            dayNumber: date.day,
            weekday: '',
            date: date,
            isMuted: true,
            hasMeals: false,
          );
        })
        .where((day) => includeFriday || day.date?.weekday != DateTime.friday)
        .toList();
  }

  static bool _isSameDay(DateTime? a, DateTime? b) {
    return a != null &&
        b != null &&
        a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}
