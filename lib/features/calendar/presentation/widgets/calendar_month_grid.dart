part of 'calendar_picker_panel.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.days,
    required this.onDaySelected,
  });

  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final weekdays = [
      locale.calendar_weekday_sat_short,
      locale.calendar_weekday_sun_short,
      locale.calendar_weekday_mon_short,
      locale.calendar_weekday_tue_short,
      locale.calendar_weekday_wed_short,
      locale.calendar_weekday_thu_short,
      locale.calendar_weekday_fri_short,
    ];

    return SizedBox(
      key: const ValueKey('month-grid'),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: weekdays.length + days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (index < weekdays.length) {
            return CalendarMonthWeekdayLabel(label: weekdays[index]);
          }

          final dayIndex = index - weekdays.length;
          final day = days[dayIndex];

          return CalendarDayTile(
            day: day,
            compact: true,
            onPressed: () => onDaySelected(day),
          );
        },
      ),
    );
  }
}
